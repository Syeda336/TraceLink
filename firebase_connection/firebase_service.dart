// firebase_services.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // -----------------------
  // Sign up new user
  // -----------------------
  static Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'studentId': studentId,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Sign up success for uid: ${userCredential.user!.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Sign up FirebaseAuthException: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Sign up general error: $e');
      return null;
    }
  }

  // -----------------------
  // Sign in user with email
  // -----------------------
  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Sign in success: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Sign in error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Sign in general error: $e');
      return null;
    }
  }

  // -----------------------
  // Sign in with STUDENT ID
  // -----------------------
  static Future<User?> signInWithStudentId({
    required String studentId,
    required String password,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('studentId', isEqualTo: studentId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('Student ID sign-in: no user found for studentId=$studentId');
        return null;
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      if (data['email'] == null) {
        print('Student ID sign-in: user document missing an email field.');
        return null;
      }

      final String email = data['email'] as String;
      print('Student ID sign-in: found email $email for studentId $studentId');

      try {
        UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('Student ID sign-in success: ${userCredential.user?.uid}');
        return userCredential.user;
      } on FirebaseAuthException catch (e) {
        print(
            'Student ID sign-in auth error for email $email: ${e.code} - ${e.message}');
        return null;
      }
    } catch (e) {
      print('Student ID sign-in general error: $e');
      return null;
    }
  }

  // ***************************************************
  // Update user profile (including email synchronization)
  // ***************************************************
  // ***************************************************
// Update user profile (including email synchronization)
// ***************************************************
static Future<bool> updateUserProfile({
  required String fullName,
  required String email,
  required String phoneNumber,
  required String department,
  required String campus,
  required String bio,
  String? currentPassword,
}) async {
    print('🔥 updateUserProfile STARTED');
    print('🔥 Email: $email, FullName: $fullName');


  try {
    User? user = _auth.currentUser;
    if (user == null) {
      //print('updateUserProfile: no authenticated user.');
      print('🔥 ERROR: No authenticated user');
      return false;
    }

    final String? currentAuthEmail = user.email;
    print('🔥 Current auth email: $currentAuthEmail');

    // If email is changing and different from Auth email
if (email.isNotEmpty && currentAuthEmail != null && currentAuthEmail != email) {
  print('Email change detected: $currentAuthEmail -> $email');
  
  if (currentPassword == null || currentPassword.isEmpty) {
    print('Email change requires current password');
    return false;
  }

  try {
    // 1. Reauthenticate user with current credentials
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: currentAuthEmail,
        password: currentPassword,
      ),
    );
    print('Reauthentication successful for user ${user.uid}');

    // 2. Send verification email to new address
    await user.verifyBeforeUpdateEmail(email);
    print('Verification email sent to: $email');
    
    // Email in Auth will update automatically after user verifies
    // For now, we continue to update Firestore
    
  } on FirebaseAuthException catch (e) {
    print('Email update failed: ${e.code} - ${e.message}');
    return false;
  }
}

    // Update Firestore user document with ALL fields
    try {
      Map<String, dynamic> updateData = {
        'fullName': fullName,
        'email': email, // Always update email in Firestore
        'phoneNumber': phoneNumber,
        'department': department,
        'campus': campus,
        'bio': bio,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(user.uid).update(updateData);
      print('Firestore user document updated for uid: ${user.uid}');
      print('Updated data: $updateData');
    } catch (e) {
      print('Firestore update error: $e');
      return false;
    }

    return true;
  } on FirebaseAuthException catch (e) {
    print('updateUserProfile FirebaseAuthException: ${e.code} - ${e.message}');
    return false;
  } catch (e) {
    print('updateUserProfile general error: $e');
    return false;
  }
}
  // -----------------------
  // Update email only including reauthentication
  // -----------------------
  static Future<bool> updateEmail(String newEmail, {required String currentPassword}) async {
  try {
    User? user = _auth.currentUser;
    if (user == null) {
      print('updateEmail: no authenticated user.');
      return false;
    }

    // 1️⃣ Reauthenticate user
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,      // ⚠️ Use CURRENT email here
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      print('Reauthentication successful for uid: ${user.uid}');
    } on FirebaseAuthException catch (e) {
      print('Reauthentication failed: ${e.code} - ${e.message}');
      return false; // Stop if password is wrong
    }

    // 2️⃣ Update email in Firebase Auth
    await user.updateEmail(newEmail);
    print('Auth email updated to $newEmail for uid: ${user.uid}');

    // 3️⃣ Sync Firestore
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('Firestore email updated for uid: ${user.uid}');
    } catch (e) {
      print('Firestore update after updateEmail failed: $e');
    }

    return true;
  } on FirebaseAuthException catch (e) {
    print('updateEmail FirebaseAuthException: ${e.code} - ${e.message}');
    return false;
  } catch (e) {
    print('updateEmail general error: $e');
    return false;
  }
}

  // -----------------------
  // Get current user data from Firestore
  // -----------------------
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        return userDoc.data() as Map<String, dynamic>?;
      }
      print('getUserData: no current user.');
      return null;
    } catch (e) {
      print('getUserData error: $e');
      return null;
    }
  }

  // -----------------------
  // Sign out
  // -----------------------
  static Future<void> signOut() async {
    await _auth.signOut();
    print('User signed out.');
  }
}

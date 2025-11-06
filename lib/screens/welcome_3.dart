import 'package:flutter/material.dart';
import 'home.dart'; // ✅ make sure this file exists and defines HomePage()

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ remove debug banner
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const Welcoming3(), // ✅ show this screen directly
    );
  }
}

class Welcoming3 extends StatelessWidget {
  const Welcoming3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFB63B6), Color(0xFFFFA0AD)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(), // Push content to vertical center
              // 🌸 Center Circle + Texts
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: ShapeDecoration(
                      color: Colors.white.withValues(alpha: 0.30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.favorite_outline,
                        color: Colors.white,
                        size: 60,
                      ), // placeholder icon (replace with image)
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Earn rewards for helping others',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Build your reputation and earn badges by helping return lost items',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xE5FFFEFE),
                        fontSize: 16,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(), // Push button to bottom
              // 🔘 Dots + Get Started Button
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(alpha: 0.4),
                      const SizedBox(width: 8),
                      _buildDot(alpha: 0.4),
                      const SizedBox(width: 8),
                      _buildDot(width: 32, alpha: 1.0),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: 55.99,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              color: Color(0xFF980FFA),
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot({double width = 8, double alpha = 0.4}) {
    return Container(
      width: width,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

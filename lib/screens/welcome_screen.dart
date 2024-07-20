import 'package:flutter/material.dart';

import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade800],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeTransition(
                    opacity: _animation,
                    child: Image.asset(
                      'assets/book_app_logo.jpg', // Replace with your logo asset path
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 24),
                  FadeTransition(
                    opacity: _animation,
                    child: Text(
                      'Book Library',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  FadeTransition(
                    opacity: _animation,
                    child: Text(
                      'Manage your personal book library with ease.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  FadeTransition(
                    opacity: _animation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFeatureIcon(Icons.add, 'Add Books'),
                        _buildFeatureIcon(Icons.edit, 'Edit Details'),
                        _buildFeatureIcon(Icons.star, 'Rate Books'),
                        _buildFeatureIcon(Icons.done, 'Mark as Read'),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  FadeTransition(
                    opacity: _animation,
                    child: ElevatedButton(
                      onPressed: _navigateToHomeScreen,
                      child: Text('Get Started'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton('assets/icons/facebook.png', () {}),
                      SizedBox(width: 20),
                      _buildSocialButton('assets/icons/google.png', () {}),
                      SizedBox(width: 20),
                      _buildSocialButton('assets/icons/apple-logo.png', () {}),
                      SizedBox(width: 20),
                      _buildSocialButton('assets/icons/instagram.png', () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.white),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        assetPath,
        height: 40,
        width: 40,
      ),
    );
  }
}

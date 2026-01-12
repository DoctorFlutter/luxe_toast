import 'package:flutter/material.dart';
import 'package:luxe_toast/luxe_toast.dart'; // Import your package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Holographic Toast Demo',
      // Dark theme is mandatory for the "High-End" look
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND: A subtle radial gradient to simulate a "spotlight"
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  Color(0xFF2B32B2), // Deep Blue spotlight at top
                  Color(0xFF1488CC), // Lighter Blue
                  Color(0xFF000000), // Fade to Black
                ],
                stops: [0.0, 0.2, 1.0],
              ),
            ),
          ),

          // FOREGROUND CONTENT
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Futuristic HUD (Heads-Up Display) \n Cyberpunk Toast",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.blueAccent, blurRadius: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "By Vivek Raval [ DoctorFlutter ]",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 60),

                  // BUTTON 1: SUCCESS (Green Shimmer)
                  _buildPremiumButton(
                    context,
                    label: "Verify Identity",
                    color: const Color(0xFF00FF94), // Neon Green
                    icon: Icons.fingerprint,
                    onTap: () {
                      LuxeToast.show(
                        context,
                        title: "Identity Verified",
                        message: "Secure connection established successfully.",
                        color: const Color(0xFF00FF94),
                        icon: Icons.check_circle,
                        position: LuxeToastPosition.top,
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // BUTTON 2: ERROR (Red Shimmer)
                  _buildPremiumButton(
                    context,
                    label: "Delete Database",
                    color: const Color(0xFFFF0055), // Neon Red
                    icon: Icons.delete_forever,
                    onTap: () {
                      LuxeToast.show(
                        context,
                        title: "Access Denied",
                        message: "You do not have root privileges for this action.",
                        color: const Color(0xFFFF0055),
                        icon: Icons.gpp_bad,
                        position: LuxeToastPosition.bottom,
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // BUTTON 3: INFO (Purple Shimmer)
                  _buildPremiumButton(
                    context,
                    label: "Cloud Sync",
                    color: const Color(0xFFD500F9), // Neon Purple
                    icon: Icons.cloud_upload,
                    onTap: () {
                      LuxeToast.show(
                        context,
                        title: "Syncing Assets",
                        message: "Uploading 45 files to the decentralized cloud...",
                        color: const Color(0xFFD500F9),
                        icon: Icons.cloud_done,
                        position: LuxeToastPosition.top,
                        duration: const Duration(seconds: 5), // Longer to see shimmer
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // A custom "Glass" button to match the theme
  Widget _buildPremiumButton(
      BuildContext context, {
        required String label,
        required Color color,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 15),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
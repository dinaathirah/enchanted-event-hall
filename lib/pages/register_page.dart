import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/login_and_register_background/flowerbackground.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),


          Container(
            color: const Color(0xFFF6F3FA).withOpacity(0.25),
          ),


          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TITLE
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F2F3A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Create your account to start booking',
                        style: TextStyle(
                          color: Color(0xFF7A7A8C),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),


                      _inputField(
                        label: 'Full Name',
                        hint: 'Your name',
                        icon: Icons.person_outline,
                        controller: nameCtrl,
                      ),

                      const SizedBox(height: 16),


                      _inputField(
                        label: 'Email',
                        hint: 'your@email.com',
                        icon: Icons.email_outlined,
                        controller: emailCtrl,
                      ),

                      const SizedBox(height: 16),


                      _inputField(
                        label: 'Phone Number',
                        hint: '+60 12-345 6789',
                        icon: Icons.phone_outlined,
                        controller: phoneCtrl,
                      ),

                      const SizedBox(height: 16),


                      _inputField(
                        label: 'Password',
                        hint: 'Enter password',
                        icon: Icons.lock_outline,
                        controller: passwordCtrl,
                        isPassword: true,
                      ),

                      const SizedBox(height: 16),


                      _inputField(
                        label: 'Confirm Password',
                        hint: 'Re-enter password',
                        icon: Icons.lock_outline,
                        controller: confirmPasswordCtrl,
                        isPassword: true,
                      ),

                      const SizedBox(height: 28),


                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF8E7CC3), // pastel purple
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () async {
                            if (passwordCtrl.text != confirmPasswordCtrl.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Passwords do not match')),
                              );
                              return;
                            }

                            try {
                              // 1. Create user in Firebase Auth
                              UserCredential userCredential =
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailCtrl.text.trim(),
                                password: passwordCtrl.text.trim(),
                              );

                              final uid = userCredential.user!.uid;

                              // 2. Save user info to Firestore
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .set({
                                'name': nameCtrl.text.trim(),
                                'email': emailCtrl.text.trim(),
                                'phone': phoneCtrl.text.trim(),
                                'role': 'user',
                                'status': 'active',
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Account created successfully')),
                              );

                              Navigator.pop(context); // back to login
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message ?? 'Registration failed')),
                              );
                            }
                          },



                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: Color(0xFF8E7CC3),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _inputField({
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F2F3A),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: const Color(0xFFF6F3FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

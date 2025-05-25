import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import 'chat_screen.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: Consumer<AuthViewModel>(
          builder: (context, authViewModel, _) {
            if (authViewModel.currentUser != null) {
              return ChatScreen();
            }
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: authViewModel.isLoading 
                      ? null 
                      : () async {
                          try {
                            await authViewModel.signInWithGoogle();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Sign in failed: ${e.toString()}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                  child: const Text('Sign in with Google'),
                ),
                const SizedBox(height: 20),
                if (authViewModel.isLoading)
                  const CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
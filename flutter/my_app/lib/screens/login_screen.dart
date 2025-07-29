import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController(text: 'top');
  final _passwordController = TextEditingController(text: '1122');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            Consumer<ApiService>(
              builder: (context, apiService, child) {
                return ElevatedButton(
                  onPressed: apiService.isLoading
                      ? null
                      : () async {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          if (email.isNotEmpty && password.isNotEmpty) {
                            try {
                              await apiService.loginWithApi(email, password);
                              if (apiService.userId != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => HomeScreen()),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all fields')),
                            );
                          }
                        },
                  child: apiService.isLoading
                      ? SpinKitCircle(color: Colors.white, size: 20)
                      : Text('Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
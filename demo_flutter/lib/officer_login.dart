import 'package:demo_flutter/officer_signin.dart';
import 'package:flutter/material.dart';

class OfficerLoginPage extends StatefulWidget {
  const OfficerLoginPage({super.key});

  @override
  State<OfficerLoginPage> createState() => _OfficerLoginPageState();
}

class _OfficerLoginPageState extends State<OfficerLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? selectedRole;

  final List<String> officerRoles = [
    'Municipal Engineer',
    'Sanitation Officer',
    'Road Maintenance Officer',
    'Water Supply Officer',
    'Streetlight Officer',
  ];

  void registerOfficer() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Email validation
    if (!email.contains("@") || !email.contains(".")) {
      showMessage("Enter a valid Email ID");
      return;
    }

    // Password length validation
    if (password.length < 8) {
      showMessage("Password must be at least 8 characters long");
      return;
    }

    // Password match validation
    if (password != confirmPassword) {
      showMessage("Passwords do not match");
      return;
    }

    // Role selection validation
    if (selectedRole == null) {
      showMessage("Please select your role");
      return;
    }

    // If everything is correct
    showMessage("Registration Successful!", success: true);
  }

  void showMessage(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('Officer Registration'),
        backgroundColor: Colors.orange.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Officer Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.email, color: Colors.orange),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Create Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.lock, color: Colors.orange),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.lock, color: Colors.orange),
              ),
            ),

            const SizedBox(height: 20),

            // Dropdown for Role
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Officer Role",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.group, color: Colors.orange),
              ),
              initialValue: selectedRole,
              items: officerRoles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: registerOfficer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade400,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Register', style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OfficerSignInPage()),
  );
},
              child: Text(
                'Already have an account? Login',
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back', style: TextStyle(color: Colors.orange.shade600)),
            ),
          ],
        ),
      ),
    );
  }
}

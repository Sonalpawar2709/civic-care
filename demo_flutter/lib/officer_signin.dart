import 'package:flutter/material.dart';

class OfficerSignInPage extends StatefulWidget {
  const OfficerSignInPage({super.key});

  @override
  State<OfficerSignInPage> createState() => _OfficerSignInPageState();
}

class _OfficerSignInPageState extends State<OfficerSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedRole;
  bool isLoading = false;

  Future<void> officerSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // Simulate API delay

    if (!mounted) return; // 🛠 FIX for BuildContext async gap

    setState(() => isLoading = false);

    // Dummy check
    if (emailController.text == "officer@test.com" &&
        passwordController.text == "12345678") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign-In Successful")),
      );

      // Navigation (example)
      // if (!mounted) return;
      // Navigator.push(context, MaterialPageRoute(builder: (_) => OfficerHomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text("Officer Sign-In"),
        backgroundColor: Colors.orange.shade400,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Officer Email",
                  prefixIcon: const Icon(Icons.email, color: Colors.orange),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter email";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter password";
                  }
                  if (value.length < 8) {
                    return "Password must be at least 8 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Role Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Your Role",
                  prefixIcon: const Icon(Icons.badge, color: Colors.orange),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                initialValue: selectedRole,
                items: const [
                  DropdownMenuItem(
                      value: "Municipality Officer",
                      child: Text("Municipality Officer")),
                  DropdownMenuItem(
                      value: "Sanitation Officer",
                      child: Text("Sanitation Officer")),
                  DropdownMenuItem(
                      value: "Water Supply Officer",
                      child: Text("Water Supply Officer")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Please select a role" : null,
              ),
              const SizedBox(height: 40),

              // Sign-In Button
              ElevatedButton(
                onPressed: isLoading ? null : officerSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 18),
                      ),
              ),

              const SizedBox(height: 20),

              // Back Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Back",
                  style: TextStyle(color: Colors.orange.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

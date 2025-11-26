import 'package:flutter/material.dart';

void main() {
  runApp(const CivicCareApp());
}

// ----------------------------------------------------
// MAIN APP
// ----------------------------------------------------

class CivicCareApp extends StatelessWidget {
  const CivicCareApp({super.key}); // Lint fix applied

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Civic Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const LoginSelectionPage(),
    );
  }
}

// ----------------------------------------------------
// 1. LOGIN SELECTION PAGE
// ----------------------------------------------------

class LoginSelectionPage extends StatelessWidget {
  const LoginSelectionPage({super.key}); // Lint fix applied

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 105, 6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Civic Care",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 32, 66, 216),
                ),
              ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome to Civic Care",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Your city. Your voice. Your solution.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange.shade700,
                      ),
                      textAlign: TextAlign.center,

                    ),
                    const SizedBox(height: 50),
                    // Citizen Button
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigates to the Citizen Reporting Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CitizenReportingPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 8,
                        ),
                        child: const Text(
                          "Citizen",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Officer Button
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigates to the Officer Dashboard placeholder
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OfficerDashboard()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade400,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Officer",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}


// ----------------------------------------------------
// 2. CITIZEN ISSUE REPORTING PAGE (NEW IMPLEMENTATION)
// ----------------------------------------------------

class CitizenReportingPage extends StatefulWidget {
  const CitizenReportingPage({super.key});

  @override
  State<CitizenReportingPage> createState() => _CitizenReportingPageState();
}

class _CitizenReportingPageState extends State<CitizenReportingPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<String> _categories = [
    'Pothole',
    'Street Light Outage',
    'Graffiti',
    'Illegal Dumping',
    'Water Leak',
    'Other',
  ];

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this data would be sent to Firestore.
      // For now, we'll just show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Report Submitted!\nCategory: $_selectedCategory, Location: ${_locationController.text}',
          ),
          backgroundColor: Colors.green,
        ),
      );
      // Clear form after submission
      setState(() {
        _selectedCategory = null;
        _descriptionController.clear();
        _locationController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report an Issue'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Tell us about the problem in your city.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Issue Category *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.category, color: Colors.orange),
                ),
                initialValue: _selectedCategory,
                hint: const Text('Select a category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an issue category.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Location Text Field
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location/Address *',
                  hintText: 'e.g., Corner of Main St and Elm Ave',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.location_on, color: Colors.orange),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location of the issue.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Description Text Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Detailed Description *',
                  hintText: 'Describe the issue (size, severity, etc.)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 80.0),
                    child: Icon(Icons.description, color: Colors.orange),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _submitReport,
                icon: const Icon(Icons.send),
                label: const Text('Submit Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel and Go Back', style: TextStyle(color: Colors.orange.shade600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}

// ----------------------------------------------------
// 3. OFFICER DASHBOARD PLACEHOLDER (UNCHANGED)
// ----------------------------------------------------

class OfficerDashboard extends StatelessWidget {
  const OfficerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Officer Dashboard'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, size: 80, color: Colors.deepOrange),
            const SizedBox(height: 20),
            const Text(
              'Officer Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('This is where officers manage reported issues.'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

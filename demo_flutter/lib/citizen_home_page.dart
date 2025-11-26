import 'package:demo_flutter/post_complaint_page.dart';
import 'feedback_page.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CitizenHomePage extends StatelessWidget {
  const CitizenHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 227, 142, 15),
  title: Column(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Text(
        "CIVIC CARE",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      Text(
        "Your City • Your Voice • Your Solution",
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  ),
  centerTitle: true,
),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Welcome section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 130, 10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Good Afternoon, Welcome CIVIC CARE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Here are today’s actions for you",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Complaint card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.8)
,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overflow of Sewerage or Storm Water reported",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "ID: W0210C28125506",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.black54, size: 20),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "14, 2nd Main Road, Cholanayakanahalli, Satara Urban, IN, India",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  const Color.fromARGB(255, 228, 130, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("View Status"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
// Complaint card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.8)
,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "broken streetlight at lakshminagar",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "ID: W0210C28125506",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.black54, size: 20),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "lakshmi road, satara Urban, IN, India",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  const Color.fromARGB(255, 228, 130, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("View Status"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons grid
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _actionTile(
                  icon: FontAwesomeIcons.commentDots,
                  title: "Post A Complaint",
                  subtitle: "We are committed to receiving your complaint",
                  color1: const Color(0xFFF5B041),
                  color2: const Color(0xFFD1F2EB),
                 onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PostComplaintPage()),
  );
},

               
                ),
                _actionTile(
                  icon: FontAwesomeIcons.message,
                  title: "Provide Feedback",
                  subtitle: "Tell your experience of Swachhata App",
                  color1: const Color.fromARGB(255, 201, 138, 29),
                  color2: const Color(0xFFD1F2EB),
                  onTap: () {
                    Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => const FeedbackPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF1BA57B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 32), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Complaints"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
  colors: [
    Colors.orange.withValues(alpha: 0.5),
    Colors.orangeAccent.withValues(alpha: 0.7),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
),

          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

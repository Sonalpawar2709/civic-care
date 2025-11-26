import 'dart:convert';
import 'dart:io';
import 'package:demo_flutter/citizen_home_page.dart' show CitizenHomePage;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:exif/exif.dart';

String? _selectedCategory;

class PostComplaintPage extends StatefulWidget {
  const PostComplaintPage({super.key});

  @override
  State<PostComplaintPage> createState() => _PostComplaintPageState();
}

class _PostComplaintPageState extends State<PostComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _taxPaid = false;

  File? _image;
  final picker = ImagePicker();

  // GPS / EXIF vars
  double? _selectedLat;
  double? _selectedLon;
  String _gpsText = "No location selected";

  // -------------------------------
  //  Helper: convert EXIF DMS -> decimal
  // -------------------------------
  double _convertToDegree(dynamic values) {
    // values may be an IfdTag with .values or a List
    try {
      List vals;
      if (values is List) {
        vals = values;
      } else if (values is Map && values['values'] != null) {
        vals = List.from(values['values']);
      } else if (values is IfdTag) {
        vals = List.from((values).values as Iterable<dynamic>);
      } else {
        // try to access .values property dynamically
        vals = List.from((values).values);
      }

      double d = vals[0].toDouble();
      double m = vals[1].toDouble();
      double s = vals[2].toDouble();
      return d + (m / 60.0) + (s / 3600.0);
    } catch (e) {
      return 0.0;
    }
  }

  // -------------------------------
  //  STEP-2 & 5: Image Picker + EXIF GPS extraction
  // -------------------------------
  Future pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Read EXIF bytes and attempt to extract GPS
      try {
        final bytes = await _image!.readAsBytes();
        final tags = await readExifFromBytes(bytes);

        // tags might be an empty map if no exif
        if (tags!.isNotEmpty) {
          final latTag = tags['GPS GPSLatitude'] ?? tags['GPSLatitude'];
          final lonTag = tags['GPS GPSLongitude'] ?? tags['GPSLongitude'];
          final latRef = tags['GPS GPSLatitudeRef'] ?? tags['GPSLatitudeRef'];
          final lonRef = tags['GPS GPSLongitudeRef'] ?? tags['GPSLongitudeRef'];

          if (latTag != null && lonTag != null) {
            double lat = _convertToDegree(latTag);
            double lon = _convertToDegree(lonTag);

            // Adjust sign by reference (N/S, E/W)
            try {
              final latR = latRef?.printable?.toString() ?? latRef?.toString();
              final lonR = lonRef?.printable?.toString() ?? lonRef?.toString();
              if (latR != null && latR.toUpperCase().contains('S')) lat = -lat;
              if (lonR != null && lonR.toUpperCase().contains('W')) lon = -lon;
            } catch (_) {}

            setState(() {
              _selectedLat = lat;
              _selectedLon = lon;
              _gpsText = 'Lat: ${lat.toStringAsFixed(6)}, Lon: ${lon.toStringAsFixed(6)}';
            });
            debugPrint('EXIF GPS extracted: $_gpsText');
          } else {
            setState(() {
              _gpsText = 'No GPS metadata found';
            });
            debugPrint('No GPS tags in EXIF');
          }
        } else {
          setState(() {
            _gpsText = 'No EXIF metadata found';
          });
          debugPrint('EXIF empty');
        }
      } catch (e) {
        setState(() {
          _gpsText = 'Error reading EXIF';
        });
        debugPrint('EXIF read error: $e');
      }
    } else {
      debugPrint('No image selected');
    }
  }

  // -------------------------------
  //  Submit Complaint (sends image + optional location)
  // -------------------------------
  Future submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      var uri = Uri.parse('http://127.0.0.1:5000/submit_complaint');

      var request = http.MultipartRequest('POST', uri);

      request.fields['name'] = _nameController.text;
      request.fields['address'] = _addressController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['category'] = _selectedCategory ?? 'Other';
      request.fields['tax_paid'] = _taxPaid ? 'Yes' : 'No';

      // include location if available
      request.fields['latitude'] = _selectedLat?.toString() ?? '';
      request.fields['longitude'] = _selectedLon?.toString() ?? '';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          filename: basename(_image!.path),
        ),
      );

      debugPrint('Sending request to backend...');

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          var data = json.decode(respStr);

          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Complaint submitted successfully')),
          );

          // Reset fields
          _formKey.currentState!.reset();
          setState(() {
            _image = null;
            _selectedCategory = null;
            _taxPaid = false;
            _selectedLat = null;
            _selectedLon = null;
            _gpsText = 'No location selected';
          });

          // Navigate to success screen
          Navigator.pushReplacement(
            context as BuildContext,
            MaterialPageRoute(
              builder: (context) => ComplaintSuccessPage(
                complaintId: data['complaint_id']?.toString(),
                message: data['message'] ?? 'Submitted',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            const SnackBar(content: Text('Error submitting complaint')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 227, 142, 15),
        title: const Text('Post A Complaint', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 12),

                const Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your address',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
                ),
                const SizedBox(height: 12),

                const Text(' Complaint Description', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Describe your complaint',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Please add description' : null,
                ),
                const SizedBox(height: 12),

                const Text(' Complaint Category', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Select a Category'),
                  items: const [
                    DropdownMenuItem(value: 'Garbage Issue', child: Text('Garbage Issue')),
                    DropdownMenuItem(value: 'Street Light', child: Text('Street Light')),
                    DropdownMenuItem(value: 'Water Supply', child: Text('Water Supply')),
                    DropdownMenuItem(value: 'Road Damage', child: Text('Road Damage')),
                    DropdownMenuItem(value: 'Drainage Problem', child: Text('Drainage Problem')),
                    DropdownMenuItem(value: 'Tree Cutting', child: Text('Tree Cutting')),
                    DropdownMenuItem(value: 'Animal Nuisance', child: Text('Animal Nuisance')),
                    DropdownMenuItem(value: 'Noise Complaint', child: Text('Noise Complaint')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 20),

                const Text('Upload Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _image == null ? 'No file chosen' : basename(_image!.path),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: pickImage,
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text('Upload', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),

                // Step-4: image preview
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _image!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_gpsText, style: const TextStyle(color: Colors.grey)),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          // If EXIF GPS already extracted, show it; otherwise try to pick image if none
                          if (_gpsText == 'No location selected' && _image == null) {
                            // encourage user to upload an image with GPS
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Upload an image taken with GPS to auto-fill location')),
                            );
                          } else if (_gpsText == 'No location selected' && _image != null) {
                            // try re-reading EXIF
                            await pickImage();
                          }
                        },
                        icon: const Icon(Icons.location_on, color: Colors.white),
                        label: const Text('Get Location', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                        value: _taxPaid,
                        activeColor: const Color.fromARGB(255, 227, 142, 15),
                        onChanged: (value) {
                          setState(() {
                            _taxPaid = value!;
                          });
                        }),
                    const Text(' Tax Paid', style: TextStyle(fontWeight: FontWeight.w500))
                  ],
                ),

                const SizedBox(height: 25),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 227, 142, 15),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: submitComplaint,
                    child: const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------
//  Step-5: Complaint Success Page
// -------------------------------
class ComplaintSuccessPage extends StatelessWidget {
  final String? complaintId;
  final String message;

  const ComplaintSuccessPage({super.key, this.complaintId, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 34, 139, 34),
        title: const Text('Complaint Submitted'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 84, color: Colors.green),
              const SizedBox(height: 18),
              Text(
                'Success',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              if (complaintId != null) Text('Complaint ID: $complaintId'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  CitizenHomePage()),
                  );
                },
                child: const Text('Go to Home'),
              )
            ],
          ),
        ),
      ),
    );
  }
}





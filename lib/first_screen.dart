// lib/first_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_flutter_67_12/services/firestore.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();

    // Splash: เปิด SecondScreen หลัง 3 วินาที
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SecondScreen()),
      ),
    );

    // ตรวจเช็ค Internet
    checkInternetConnection();
  }

  void checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      _showToast(context, "Mobile network available.");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      _showToast(context, "Wifi network available.");
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      _showToast(context, "Ethernet network available.");
    } else if (connectivityResult == ConnectivityResult.vpn) {
      _showToast(context, "VPN network available.");
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      _showToast(context, "Bluetooth network available.");
    } else if (connectivityResult == ConnectivityResult.other) {
      _showToast(context, "Other network available.");
    } else if (connectivityResult == ConnectivityResult.none) {
      _showAlertDialog(
        context,
        "No Internet Connection",
        "Please check your internet connection.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/image/icon.png'), width: 200),
              SizedBox(height: 50),
              SpinKitSpinningLines(color: Colors.deepPurple, size: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}

void _showToast(BuildContext context, String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.lightGreen,
    textColor: Colors.white,
    fontSize: 18.0,
  );
}

void _showAlertDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(msg),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Dialog Add/Edit Person
  void openPersonBox(String? personId) async {
    if (personId != null) {
      final person = await firestoreService.getPersonById(personId);
      nameController.text = person?['personname'] ?? '';
      emailController.text = person?['personemail'] ?? '';
      ageController.text = (person?['personage'] ?? 0).toString();
    } else {
      nameController.clear();
      emailController.clear();
      ageController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(personId == null ? "Add Person" : "Edit Person"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final String name = nameController.text;
              final String email = emailController.text;
              final int age = int.tryParse(ageController.text) ?? 0;

              if (personId != null) {
                firestoreService.updatePerson(personId, name, email, age);
              } else {
                firestoreService.addPerson(name, email, age);
              }

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Persons List"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openPersonBox(null),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getPersons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(fontSize: 26, color: Colors.redAccent),
              ),
            );
          }

          List<DocumentSnapshot> personsList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: personsList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot person = personsList[index];
              String personId = person.id;

              Map<String, dynamic> personData =
                  person.data() as Map<String, dynamic>;

              String personText = personData['personname'] ?? '';
              String emailText = personData['personemail'] ?? '';
              int ageText = personData['personage'] ?? 0;

              return ListTile(
                title: Text('$personText (Age: $ageText)'),
                subtitle: Text(emailText),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => openPersonBox(personId),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => firestoreService.deletePerson(personId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

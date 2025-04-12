import 'package:avoura/core/services/auth_services.dart';
import 'package:avoura/core/services/crud_services.dart';
import 'package:avoura/views/screens/update_contact_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Stream<QuerySnapshot> _stream;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    _stream = CRUDService().getContacts();
    super.initState();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Function to request permission and make a direct phone call
  void _requestPermissionAndCall(String phone) async {
    PermissionStatus status = await Permission.phone.request();
    if (status.isGranted) {
      await FlutterPhoneDirectCaller.callNumber(phone);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied to make calls")),
      );
    }
  }

  // Function to search contacts
  void searchContacts(String search) {
    setState(() {
      _stream = CRUDService().getContacts(searchQuery: search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              onChanged: (value) {
                searchContacts(value);
              },
              focusNode: _searchFocusNode,
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text("Search"),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                          setState(() {
                            _stream = CRUDService().getContacts();
                          });
                        },
                        icon: const Icon(Icons.close),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
        child: const Icon(Icons.person_add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    maxRadius: 32,
                    child: Text(
                      FirebaseAuth.instance.currentUser!.email![0]
                          .toUpperCase(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(FirebaseAuth.instance.currentUser!.email!),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                AuthService().logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged Out")),
                );
                Navigator.pushReplacementNamed(context, "/login");
              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something Went Wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading"));
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Contacts Found ..."));
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateContact(
                      name: data["name"],
                      phone: data["phone"],
                      email: data["email"],
                      docID: document.id,
                    ),
                  ),
                ),
                leading: CircleAvatar(child: Text(data["name"][0])),
                title: Text(data["name"]),
                subtitle: Text(data["phone"]),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    _requestPermissionAndCall(data["phone"]);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
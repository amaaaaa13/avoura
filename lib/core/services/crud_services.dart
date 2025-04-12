import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:avoura/models/contact.dart';

class CRUDService {
  User? user = FirebaseAuth.instance.currentUser;

  // Add new contacts to Firestore
  Future<void> addNewContacts(String name, String phone, String email) async {
    Contact contact = Contact(
      id: '', // Firestore will generate the ID
      name: name,
      phone: phone,
      email: email,
    );
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .add(contact.toFirestore()); // Use Contact model
      print("Document Added");
    } catch (e) {
      print(e.toString());
    }
  }

  // Read documents inside Firestore
  Stream<QuerySnapshot> getContacts({String? searchQuery}) {
    var contactsQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("contacts")
        .orderBy("name");

    // A filter to perform search
    if (searchQuery != null && searchQuery.isNotEmpty) {
      String searchEnd = searchQuery + "\uf8ff";
      contactsQuery = contactsQuery.where("name",
          isGreaterThanOrEqualTo: searchQuery, isLessThan: searchEnd);
    }

    return contactsQuery.snapshots(); // Return QuerySnapshot
  }

  // Update a contact
  Future<void> updateContact(
      String name, String phone, String email, String docID) async {
    Contact contact = Contact(
      id: docID,
      name: name,
      phone: phone,
      email: email,
    );
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .update(contact.toFirestore()); // Use Contact model
      print("Document Updated");
    } catch (e) {
      print(e.toString());
    }
  }

  // Delete contact from Firestore
  Future<void> deleteContact(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .delete();
      print("Contact Deleted");
    } catch (e) {
      print(e.toString());
    }
  }
}

class Contact {
  final String id;
  final String name;
  final String phone;
  final String email;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  // Factory constructor to create Contact from Firestore document
  factory Contact.fromFirestore(Map<String, dynamic> doc, String id) {
    return Contact(
      id: id,
      name: doc['name'] ?? '',
      phone: doc['phone'] ?? '',
      email: doc['email'] ?? '',
    );
  }

  // Convert Contact to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}

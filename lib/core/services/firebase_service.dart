import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Singleton pattern
  FirebaseService._privateConstructor();
  static final FirebaseService instance = FirebaseService._privateConstructor();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveResponse({
    required String name,
    required String email,
    required String message,
    required String deviceId,
  }) async {
    await _firestore
        .collection('portfolio')
        .doc('portfolio')
        .collection('user-messages')
        .add({
      'name': name,
      'email': email,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'deviceId': deviceId,
    });
  }

  Stream<QuerySnapshot> getResponses() {
    return _firestore
        .collection('portfolio')
        .doc('portfolio')
        .collection('user-messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

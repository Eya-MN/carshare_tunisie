import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {
  RequestService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _requests => _db.collection('ride_requests');

  // Create a ride request
  Future<DocumentReference<Map<String, dynamic>>> createRequest({
    required String rideId,
    required String passengerId,
    required String passengerName,
    required String from,
    required String to,
    required double price,
    required int seats,
  }) async {
    return await _requests.add({
      'rideId': rideId,
      'driverId': '', // Will be filled by the ride data
      'passengerId': passengerId,
      'passengerName': passengerName,
      'from': from,
      'to': to,
      'price': price,
      'seats': seats,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get pending requests for a driver
  Stream<QuerySnapshot<Map<String, dynamic>>> getPendingRequestsStream(String driverId) {
    return _requests
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get accepted requests for a driver
  Stream<QuerySnapshot<Map<String, dynamic>>> getAcceptedRequestsStream(String driverId) {
    return _requests
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'accepted')
        .orderBy('acceptedAt', descending: true)
        .snapshots();
  }

  // Get rejected requests for a driver
  Stream<QuerySnapshot<Map<String, dynamic>>> getRejectedRequestsStream(String driverId) {
    return _requests
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'rejected')
        .orderBy('rejectedAt', descending: true)
        .snapshots();
  }

  // Get requests for a passenger
  Stream<QuerySnapshot<Map<String, dynamic>>> getPassengerRequestsStream(String passengerId) {
    return _requests
        .where('passengerId', isEqualTo: passengerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Accept a request
  Future<void> acceptRequest(String requestId) async {
    await _requests.doc(requestId).update({
      'status': 'accepted',
      'acceptedAt': FieldValue.serverTimestamp(),
    });
  }

  // Reject a request
  Future<void> rejectRequest(String requestId) async {
    await _requests.doc(requestId).update({
      'status': 'rejected',
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }

  // Cancel a request (by passenger)
  Future<void> cancelRequest(String requestId) async {
    await _requests.doc(requestId).update({
      'status': 'cancelled',
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }

  // Get request details
  Stream<DocumentSnapshot<Map<String, dynamic>>> getRequestStream(String requestId) {
    return _requests.doc(requestId).snapshots();
  }

  // Update driver ID for requests when a ride is published
  Future<void> updateRequestDriverId(String rideId, String driverId) async {
    final requests = await _requests.where('rideId', isEqualTo: rideId).get();
    
    for (final request in requests.docs) {
      await request.reference.update({'driverId': driverId});
    }
  }

  // Get accepted requests count
  Future<int> getAcceptedRequestsCount(String driverId) async {
    final snapshot = await _requests
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'accepted')
        .get();
    
    return snapshot.docs.length;
  }

  // Check if user has already requested a ride
  Future<bool> hasUserRequestedRide(String rideId, String passengerId) async {
    final snapshot = await _requests
        .where('rideId', isEqualTo: rideId)
        .where('passengerId', isEqualTo: passengerId)
        .where('status', whereIn: ['pending', 'accepted'])
        .get();
    
    return snapshot.docs.isNotEmpty;
  }
}

enum RequestStatus {
  pending,
  accepted,
  rejected,
}

class RideRequest {
  final String id;
  final String passengerId;
  final String passengerName;
  final String? passengerImageUrl;
  final String fromCity;
  final String toCity;
  final DateTime requestedDate;
  final int seatsNeeded;
  final double maxPrice;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RideRequest({
    required this.id,
    required this.passengerId,
    required this.passengerName,
    this.passengerImageUrl,
    required this.fromCity,
    required this.toCity,
    required this.requestedDate,
    required this.seatsNeeded,
    required this.maxPrice,
    this.status = RequestStatus.pending,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      id: json['id'] as String,
      passengerId: json['passengerId'] as String,
      passengerName: json['passengerName'] as String,
      passengerImageUrl: json['passengerImageUrl'] as String?,
      fromCity: json['fromCity'] as String,
      toCity: json['toCity'] as String,
      requestedDate: DateTime.parse(json['requestedDate'] as String),
      seatsNeeded: json['seatsNeeded'] as int,
      maxPrice: (json['maxPrice'] as num).toDouble(),
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == 'RequestStatus.${json['status']}',
        orElse: () => RequestStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passengerId': passengerId,
      'passengerName': passengerName,
      'passengerImageUrl': passengerImageUrl,
      'fromCity': fromCity,
      'toCity': toCity,
      'requestedDate': requestedDate.toIso8601String(),
      'seatsNeeded': seatsNeeded,
      'maxPrice': maxPrice,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}


import 'package:latlong2/latlong.dart' as latlong;

class CatatanModel {
  final latlong.LatLng position;
  final String note;
  final String address;
  final String type;

  CatatanModel({
    required this.position,
    required this.note,
    required this.address,
    required this.type,
  });

  // Convert CatatanModel ke JSON string
  Map<String, dynamic> toJson() {
  return {
      'lat': position.latitude,
      'lng': position.longitude,
      'note': note,
      'address': address,
      'type': type,
    };
  }

  // Convert JSON string kembali ke CatatanModel
  factory CatatanModel.fromJson(Map<String, dynamic> data) {
  return CatatanModel(
      position: latlong.LatLng(data['lat'], data['lng']),
      note: data['note'],
      address: data['address'],
      type: data['type'] ?? 'Rumah',
    );
  }
}

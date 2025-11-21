// Import paket yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'catatan_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();

}

class _MapScreenState extends State<MapScreen> {
  final List<CatatanModel> _savedNotes = [];
  final MapController _mapController = MapController();

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> _findMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();

    _mapController.move(
      latlong.LatLng(position.latitude, position.longitude),
      15.0,
    );
  }
  @override
  void initState() {
    super.initState();
    _loadNotes(); // Load data marker dari SharedPreferences
  }

// Simpan data marker ke SharedPreferences
// FITUR SIMPAN & LOAD (Tugas 3)
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _savedNotes.map((note) => note.toJson()).toList(),
    );
    await prefs.setString('saved_notes', encodedData);
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesString = prefs.getString('saved_notes');
    if (notesString != null) {
      final List<dynamic> decodedData = jsonDecode(notesString);
      setState(() {
        _savedNotes.clear();
        _savedNotes.addAll(decodedData
            .map((item) => CatatanModel.fromJson(item))
            .toList());
      });
    }
  }

  // Fungsi menangani Long Press pada peta
  void _handleLongPress(TapPosition _, latlong.LatLng point) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(point.latitude, point.longitude);

    String address = placemarks.first.street ?? "Alamat tidak dikenal";

    String? selectedType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih Jenis lokasi'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Toko'),
              child: const Text('Toko'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Rumah'),
              child: const Text('Rumah'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'Kantor'),
              child: const Text('Kantor'),
            ),
          ],
        );
      },
    );

    if (selectedType == null) return;

    setState(() {
      _savedNotes.add(
        CatatanModel(
          position: point,
          note: "Catatan Baru",
          address: address,
          type: selectedType,
        ),
      );
       _saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geo-Catatan")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const latlong.LatLng(-6.2, 106.8),
          initialZoom: 13.0,
          onLongPress: _handleLongPress,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),

          // MARKER LAYER DENGAN HAPUS MARKER
         MarkerLayer(
                markers: _savedNotes.map(
                (n) {
                IconData icon;
                Color iconColor;
                switch (n.type) {
                case 'Toko':
                icon = Icons.store;
                iconColor = Colors.blue;
                break;
                case 'Rumah':
                icon = Icons.home;
                iconColor = Colors.green;
                break;
                case 'Kantor':
                icon = Icons.business;
                iconColor = Colors.orange;
                break;
                default:
                icon = Icons.location_on;
                iconColor = Colors.red;
                }

                return Marker(
                  point: n.position,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text("Hapus Marker"),
                            content: const Text(
                                "Apakah anda yakin ingin menghapus catatan ini?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _savedNotes.remove(n);
                                    _saveNotes();
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Hapus"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 40,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findMyLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

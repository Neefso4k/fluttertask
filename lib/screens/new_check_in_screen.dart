import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/check_in.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../widgets/location_widget.dart';

class NewCheckInScreen extends StatefulWidget {
  final StorageService storageService;

  const NewCheckInScreen({Key? key, required this.storageService})
      : super(key: key);

  @override
  State<NewCheckInScreen> createState() => _NewCheckInScreenState();
}

class _NewCheckInScreenState extends State<NewCheckInScreen> {
  final TextEditingController _noteController = TextEditingController();
  final LocationService _locationService = LocationService();
  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? _photoBytes;
  bool _isLoading = false;
  bool _isLoadingLocation = false;
  bool _locationPermissionDenied = false;
  Map<String, dynamic>? _locationData;
  String? _locationError;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Take photo with camera
  Future<void> _takePhotoWithCamera() async {
    try {
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera not supported on web. Please use "Pick from Gallery".')),
        );
        return;
      }

      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _photoBytes = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take photo: $e')),
      );
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _photoBytes = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Show bottom sheet with options
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A3E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Choose Image Source',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.blue),
                  title: const Text('Take Photo (Camera)', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Capture a new photo', style: TextStyle(color: Colors.white54)),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhotoWithCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.folder_open, color: Colors.green),
                  title: const Text('Pick from Gallery', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Choose existing image', style: TextStyle(color: Colors.white54)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                if (kIsWeb) ...[
                  const Divider(color: Colors.white24),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Note: Camera is not available on web',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    final result = await _locationService.getCurrentLocation();

    setState(() {
      _isLoadingLocation = false;
      if (result['success']) {
        _locationData = result;
        _locationPermissionDenied = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location retrieved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _locationError = result['error'];
        _locationPermissionDenied = result['permissionDenied'] ?? false;

        // Show a more detailed error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to get location'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });
  }

  Future<void> _saveCheckIn() async {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a note')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final checkIn = CheckIn(
        id: const Uuid().v4(),
        note: _noteController.text.trim(),
        photoBytes: _photoBytes,
        latitude: _locationData?['latitude'] ?? 0.0,
        longitude: _locationData?['longitude'] ?? 0.0,
        accuracy: _locationData?['accuracy'],
        timestamp: DateTime.now(),
      );

      await widget.storageService.saveCheckIn(checkIn);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-in saved successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save check-in: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('New Check-In'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0E27),
                Color(0xFF1A1A3E),
                Color(0xFF2D1B4E),
              ],
            ),
          ),
        ),
        actions: [
          if (_photoBytes != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _photoBytes = null;
                });
              },
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove photo',
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1A3E),
              Color(0xFF2D1B4E),
              Color(0xFF1A2A4A),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Note Field
              Card(
                color: Colors.white.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      hintText: 'Enter your check-in note...',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white54),
                      hintStyle: TextStyle(color: Colors.white38),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Photo Section
              Card(
                color: Colors.white.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Photo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_photoBytes != null)
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                maxHeight: 300, // Prevents image from being too tall
                              ),
                              child: Image.memory(
                                _photoBytes!,
                                fit: BoxFit.contain, // Changed from cover to contain!
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.broken_image, size: 50, color: Colors.white54),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _showImagePickerOptions,
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('Change Photo'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(0.15),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _photoBytes = null;
                                    });
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showImagePickerOptions,
                            icon: const Icon(Icons.add_photo_alternate),
                            label: const Text('Add Photo'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.white.withOpacity(0.15),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location Section
              Card(
                color: Colors.white.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: LocationWidget(
                    isLoading: _isLoadingLocation,
                    locationData: _locationData,
                    error: _locationError,
                    permissionDenied: _locationPermissionDenied,
                    onGetLocation: _getLocation,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCheckIn,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Check-In'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF6C5CE7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
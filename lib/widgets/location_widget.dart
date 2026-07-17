import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  final bool isLoading;
  final Map<String, dynamic>? locationData;
  final String? error;
  final bool permissionDenied;
  final VoidCallback onGetLocation;

  const LocationWidget({
    Key? key,
    required this.isLoading,
    this.locationData,
    this.error,
    this.permissionDenied = false,
    required this.onGetLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        if (isLoading) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Getting location...'),
                ],
              ),
            ),
          ),
        ] else if (error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  error!,
                  style: TextStyle(color: Colors.red[700]),
                ),
                if (permissionDenied) ...[
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onGetLocation,
                    child: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ] else if (locationData != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latitude: ${locationData!['latitude']}'),
                Text('Longitude: ${locationData!['longitude']}'),
                if (locationData!['accuracy'] != null)
                  Text('Accuracy: ${locationData!['accuracy'].toStringAsFixed(1)}m'),
              ],
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onGetLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Location'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}
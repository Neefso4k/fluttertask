import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'check_in.g.dart';

@HiveType(typeId: 0)
class CheckIn {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String note;

  @HiveField(2)
  final Uint8List? photoBytes;  // Changed from photoPath

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final double? accuracy;

  @HiveField(6)
  final DateTime timestamp;

  CheckIn({
    required this.id,
    required this.note,
    this.photoBytes,  // Changed from photoPath
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });
}
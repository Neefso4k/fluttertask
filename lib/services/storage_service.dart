import 'package:hive/hive.dart';
import '../models/check_in.dart';

class StorageService {
  static const String boxName = 'check_ins';
  late Box<CheckIn> _box;

  Future<void> init() async {
    // Open the box - this will work on all platforms
    _box = await Hive.openBox<CheckIn>(boxName);

    // Print how many items are in the box (for debugging)
    print('📦 Loaded ${_box.length} check-ins from storage');
  }

  Future<void> saveCheckIn(CheckIn checkIn) async {
    await _box.put(checkIn.id, checkIn);
    print('✅ Saved check-in: ${checkIn.note}');
  }

  List<CheckIn> getAllCheckIns() {
    final all = _box.values.toList();
    // Sort by timestamp (newest first)
    all.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    print('📋 Found ${all.length} check-ins');
    return all;
  }

  CheckIn? getCheckIn(String id) {
    return _box.get(id);
  }

  Future<void> deleteCheckIn(String id) async {
    await _box.delete(id);
    print('🗑️ Deleted check-in: $id');
  }

  Future<void> clearAll() async {
    await _box.clear();
    print('🗑️ Cleared all check-ins');
  }

  void dispose() {
    // Hive.close();
  }
}
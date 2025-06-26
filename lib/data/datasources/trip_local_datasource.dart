import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/trip_model.dart';

abstract class TripLocalDataSource {
  Future<void> saveTrip(TripModel trip);
  Future<List<TripModel>> getTrips();
  Future<TripModel?> getTripById(String id);
  Future<void> deleteTrip(String id);
}

class TripLocalDataSourceImpl implements TripLocalDataSource {
  late Future<Isar> _isar;

  TripLocalDataSourceImpl() {
    _isar = _initIsar();
  }

  Future<Isar> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      [TripModelSchema],
      directory: dir.path,
    );
  }

  @override
  Future<void> saveTrip(TripModel trip) async {
    final isar = await _isar;
    await isar.write(txn: () async {
      await isar.tripModels.put(trip);
    });
  }

  @override
  Future<List<TripModel>> getTrips() async {
    final isar = await _isar;
    return isar.tripModels.where().findAll();
  }

  @override
  Future<TripModel?> getTripById(String id) async {
    final isar = await _isar;
    return isar.tripModels.where().idEqualTo(id).findFirst();
  }

  @override
  Future<void> deleteTrip(String id) async {
    final isar = await _isar;
    await isar.write(txn: () async {
      await isar.tripModels.deleteById(id);
    });
  }
}
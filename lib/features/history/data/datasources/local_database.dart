import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/storage/secure_storage_service.dart';

part 'local_database.g.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get upiId => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get status => text()(); // 'success', 'failed', 'pending'
  TextColumn get type => text()(); // 'payment', 'refund'
}

@DriftDatabase(tables: [Transactions])
class AppDatabase extends _$AppDatabase {
  final SecureStorageService _secureStorage;

  AppDatabase(this._secureStorage) : super(_openConnection(_secureStorage));

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection(SecureStorageService secureStorage) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'chaltapay.sqlite'));
    final key = await secureStorage.getOrCreateDatabaseKey();

    return NativeDatabase.createInBackground(
      file,
      setup: (database) {
        database.execute('PRAGMA key = "$key"');
      },
    );
  });
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  final secureStorage = SecureStorageService();
  return AppDatabase(secureStorage);
}

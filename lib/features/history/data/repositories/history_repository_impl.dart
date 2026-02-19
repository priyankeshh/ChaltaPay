import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/history_repository.dart';
import '../../data/datasources/local_database.dart';

part 'history_repository_impl.g.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final AppDatabase _database;

  HistoryRepositoryImpl(this._database);

  @override
  Future<void> addTransaction({
    required double amount,
    required String upiId,
    required String type,
    String status = 'success',
  }) async {
    await _database.into(_database.transactions).insert(
          TransactionsCompanion.insert(
            amount: amount,
            upiId: upiId,
            timestamp: DateTime.now(),
            status: status,
            type: type,
          ),
        );
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return (_database.select(_database.transactions)
          ..orderBy([
            (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)
          ]))
        .watch();
  }
}

@Riverpod(keepAlive: true)
HistoryRepository historyRepository(HistoryRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return HistoryRepositoryImpl(database);
}

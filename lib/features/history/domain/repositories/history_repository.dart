import '../../data/datasources/local_database.dart';

abstract class HistoryRepository {
  Future<void> addTransaction({
    required double amount,
    required String upiId,
    required String type,
    String status = 'success',
  });

  Stream<List<Transaction>> watchTransactions();
}

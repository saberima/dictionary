import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkChecker {
  Future<bool> get isConnected;
}

class NetworkCheckerImpl implements NetworkChecker {
  final DataConnectionChecker dataConnectionChecker;

  NetworkCheckerImpl(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;

}
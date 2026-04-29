import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get connectionStream async* {
    await for (final results in _connectivity.onConnectivityChanged) {
      final hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );

      yield hasConnection;
    }
  }
}

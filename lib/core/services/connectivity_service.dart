import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnectedNow() async {
    final results = await _connectivity.checkConnectivity();

    return results.any((result) => result != ConnectivityResult.none);
  }

  Stream<bool> get connectionStream async* {
    yield await isConnectedNow();

    await for (final results in _connectivity.onConnectivityChanged) {
      yield results.any((result) => result != ConnectivityResult.none);
    }
  }
}

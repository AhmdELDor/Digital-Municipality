// import 'dart:async';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class ConnectivityHelper {
//   bool hasInternet = true;
//   StreamSubscription? _subscription;
//   StreamController<bool>? _connectivityChangeStreamController;
//
//   static ConnectivityHelper? _instance;
//
//   ConnectivityHelper._private();
//
//   factory ConnectivityHelper() => _instance ??= ConnectivityHelper._private();
//
//   Stream<bool> get onConnectivityChanged =>
//       (_connectivityChangeStreamController ??=
//               StreamController<bool>.broadcast())
//           .stream;
//
//   void initialize() {
//     Connectivity().checkConnectivity().then((value) => _onConnectivityChange);
//     _subscription = Connectivity()
//         .onConnectivityChanged
//         .listen((value) => _onConnectivityChange);
//   }
//
//   void _onConnectivityChange(ConnectivityResult result) {
//     hasInternet = result != ConnectivityResult.none;
//     _connectivityChangeStreamController?.add(hasInternet);
//   }
//
//   void dispose() {
//     _subscription?.cancel();
//     _subscription = null;
//     _connectivityChangeStreamController?.close();
//     _connectivityChangeStreamController = null;
//   }
// }


import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  bool hasInternet = true;
  StreamSubscription? _subscription;
  StreamController<bool>? _connectivityChangeStreamController;

  static ConnectivityHelper? _instance;

  ConnectivityHelper._private();

  factory ConnectivityHelper() => _instance ??= ConnectivityHelper._private();

  Stream<bool> get onConnectivityChanged =>
      (_connectivityChangeStreamController ??=
      StreamController<bool>.broadcast())
          .stream;

  void initialize() {
    Connectivity().checkConnectivity().then((results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _onConnectivityChange(result);
    });

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _onConnectivityChange(result);
    });
  }


  void _onConnectivityChange(ConnectivityResult result) {
    hasInternet = result != ConnectivityResult.none;
    _connectivityChangeStreamController?.add(hasInternet);
  }


  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _connectivityChangeStreamController?.close();
    _connectivityChangeStreamController = null;
  }
}

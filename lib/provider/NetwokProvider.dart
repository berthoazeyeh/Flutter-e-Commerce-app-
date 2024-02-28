import 'package:flutter/foundation.dart';

class NetworkProvider extends ChangeNotifier {
  // String uris = AppConfiguration.baseUrl;
  String ipAddress = "192.168.43.206";
  bool network = false;

  bool get net => network;
  // String get uri => network;

  void setUritoNetwork() {
    network = true;
    // uris = AppConfiguration.baseUrlNetwork;
    notifyListeners();
  }

  void setIpAddress(String ip) {
    network = false;
    ipAddress = ip;
    // uris = 'http://$ip:8000/';
    notifyListeners();
  }

  void setUritoLocal(String ip) {
    network = false;

    // uris = 'http://$ip:8000/';
    notifyListeners();
  }

  void resetUri() {
    // uris = AppConfiguration.baseUrl;
    notifyListeners();
  }
}

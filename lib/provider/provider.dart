import 'package:flutter/material.dart';

class ContadorProvider extends ChangeNotifier {
  int _contador = 0;
  int get contador => _contador;

  void incrementar() {
    _contador++;
    notifyListeners(); // Notifica a los widgets que usan este estado
  }

  void dencrementar() {
    _contador--;
    notifyListeners(); // Notifica a los widgets que usan este estado
  }
}

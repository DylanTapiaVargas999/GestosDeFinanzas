import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserBalance {
  final String userId;
  final double balance;

  UserBalance({
    required this.userId,
    required this.balance,
  });

  // Convierte el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'balance': balance,
    };
  }

  // Crea un objeto desde JSON
  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      userId: json['userId'],
      balance: (json['balance'] as num).toDouble(),
    );
  }

  // Guarda el balance en un archivo JSON
  static Future<void> saveToFile(UserBalance userBalance) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user_balance.json';
      final file = File(filePath);

      final jsonContent = jsonEncode(userBalance.toJson());
      await file.writeAsString(jsonContent);

      print('Balance guardado en: $filePath');
    } catch (e) {
      print('Error al guardar el balance: $e');
    }
  }

  // Carga el balance desde un archivo JSON
  static Future<UserBalance?> loadFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user_balance.json';
      final file = File(filePath);

      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonData = jsonDecode(content);
        return UserBalance.fromJson(jsonData);
      } else {
        print('El archivo de balance no existe.');
        return null;
      }
    } catch (e) {
      print('Error al cargar el balance: $e');
      return null;
    }
  }
}
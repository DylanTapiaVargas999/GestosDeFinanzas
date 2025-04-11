import '../models/user_balance.dart';

class UserBalanceViewModel {
  UserBalance? userBalance;

  // Carga el balance del usuario desde el archivo
  Future<void> loadBalance() async {
    userBalance = await UserBalance.loadFromFile();
    userBalance ??= UserBalance(userId: 'default_user', balance: 0.0);
  }

  // Guarda el balance del usuario en el archivo
  Future<void> saveBalance() async {
    if (userBalance == null) {
      throw Exception('El balance no está inicializado.');
    }
    await UserBalance.saveToFile(userBalance!);
  }

  // Obtiene el balance actual
  double getBalance() {
    return userBalance?.balance ?? 0.0;
  }

  // Agrega una cantidad al balance actual
  Future<void> addToBalance(double amount) async {
    if (userBalance == null) {
      throw Exception('El balance no está cargado.');
    }
    userBalance = UserBalance(
      userId: userBalance!.userId,
      balance: userBalance!.balance + amount,
    );
    await saveBalance();
  }

  // Reemplaza completamente el balance actual
  Future<void> replaceBalance(double newBalance) async {
    if (userBalance == null) {
      throw Exception('El balance no está cargado.');
    }
    userBalance = UserBalance(
      userId: userBalance!.userId,
      balance: newBalance,
    );
    await saveBalance();
  }
}
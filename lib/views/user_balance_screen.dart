import 'package:flutter/material.dart';
import '../viewmodels/user_balance_viewmodel.dart';

class UserBalanceScreen extends StatefulWidget {
  const UserBalanceScreen({super.key});

  @override
  State<UserBalanceScreen> createState() => _UserBalanceScreenState();
}

class _UserBalanceScreenState extends State<UserBalanceScreen> {
  final UserBalanceViewModel _viewModel = UserBalanceViewModel();
  final TextEditingController _balanceController = TextEditingController();
  String userId = "12345"; // ID del usuario (puedes obtenerlo dinámicamente)
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    setState(() {
      isLoading = true;
    });
    await _viewModel.loadBalance();
    setState(() {
      _balanceController.text = _viewModel.getBalance().toStringAsFixed(2);
      isLoading = false;
    });
  }

  Future<void> _addToBalance() async {
    final amount = double.tryParse(_balanceController.text);
    if (amount == null || amount <= 0) {
      _showError('Por favor, ingrese un monto válido mayor a 0.');
      return;
    }
    await _viewModel.addToBalance(amount);
    _showMessage('Monto agregado exitosamente');
    _loadBalance();
  }

  Future<void> _replaceBalance() async {
    final newBalance = double.tryParse(_balanceController.text);
    if (newBalance == null || newBalance < 0) {
      _showError('Por favor, ingrese un monto válido mayor o igual a 0.');
      return;
    }
    await _viewModel.replaceBalance(newBalance);
    _showMessage('Balance reemplazado exitosamente');
    _loadBalance();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Balance'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingrese el monto:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _balanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Monto',
                      prefixText: '\$',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _addToBalance,
                        child: const Text('Agregar'),
                      ),
                      ElevatedButton(
                        onPressed: _replaceBalance,
                        child: const Text('Reemplazar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
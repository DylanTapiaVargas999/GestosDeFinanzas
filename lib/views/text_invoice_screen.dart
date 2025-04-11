import 'package:flutter/material.dart';
import '../viewmodels/invoice_viewmodel.dart';

class TextInvoiceScreen extends StatefulWidget {
  const TextInvoiceScreen({super.key});

  @override
  State<TextInvoiceScreen> createState() => _TextInvoiceScreenState();
}

class _TextInvoiceScreenState extends State<TextInvoiceScreen> {
  final InvoiceViewModel _viewModel = InvoiceViewModel(apiKey: "AIzaSyAPwGfQo9eI2KubbXhabdH8ESDRR4s5Llo", userId: '');
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> _processInvoice() async {
    setState(() {
      isLoading = true;
    });

    await _viewModel.processTextInvoice(_controller.text);

    setState(() {
      isLoading = false;
    });

    if (_viewModel.lastError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.lastError!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura procesada correctamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar Factura por Texto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Ingresa la factura en formato de texto:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ejemplo:\nManzana 1.50\nDetergente 3.75\n...',
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _processInvoice,
                    child: const Text('Procesar Factura'),
                  ),
          ],
        ),
      ),
    );
  }
}
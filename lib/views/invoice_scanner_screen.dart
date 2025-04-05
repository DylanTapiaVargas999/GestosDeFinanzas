import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../viewmodels/invoice_viewmodel.dart';

class InvoiceScannerScreen extends StatefulWidget {
  final String apiKey;

  const InvoiceScannerScreen({super.key, required this.apiKey});

  @override
  State<InvoiceScannerScreen> createState() => _InvoiceScannerScreenState();
}

class _InvoiceScannerScreenState extends State<InvoiceScannerScreen> {
  late final InvoiceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = InvoiceViewModel(apiKey: widget.apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escáner de Facturas')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await _viewModel.pickAndAnalyzeImage();
                setState(() {});
              },
              child: const Text('Seleccionar Imagen'),
            ),
            if (_viewModel.currentImage != null)
              Image.memory(_viewModel.currentImage!),
            Expanded(
              child: ListView.builder(
                itemCount: _viewModel.messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MarkdownBody(data: _viewModel.messages[index]),
                    ),
                  );
                },
              ),
            ),
            if (_viewModel.isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
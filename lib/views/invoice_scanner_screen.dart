import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../viewmodels/invoice_viewmodel.dart';

class InvoiceScannerScreen extends StatefulWidget {
  final String apiKey;
  final userId = 'Pedro Perez'; // Definir el nombre del usuario aquí


  const InvoiceScannerScreen({super.key, required this.apiKey});

  @override
  State<InvoiceScannerScreen> createState() => _InvoiceScannerScreenState();
}

class _InvoiceScannerScreenState extends State<InvoiceScannerScreen> {
  late final InvoiceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = InvoiceViewModel(apiKey: widget.apiKey, userId: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner de Facturas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _viewModel.clearData();
              setState(() {});
            },
            tooltip: 'Limpiar resultados',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Botones de captura de imagen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galería'),
                      onPressed: () async {
                        await _viewModel.pickAndAnalyzeImageFromGallery();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Cámara'),
                      onPressed: () async {
                        await _viewModel.captureAndAnalyzeImageFromCamera();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Mostrar imagen seleccionada
            if (_viewModel.currentImage != null)
              Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    _viewModel.currentImage!,
                    fit: BoxFit.contain,
                    height: 200,
                  ),
                ),
              ),

            // Mostrar errores si existen
            if (_viewModel.lastError != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _viewModel.lastError!,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Título de resultados
            if (_viewModel.messages.isNotEmpty && !_viewModel.isLoading)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Resultados del análisis:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Lista de resultados
            Expanded(
              child: _viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _viewModel.messages.isEmpty
                      ? const Center(
                          child: Text(
                            'Selecciona o captura una factura para analizar',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _viewModel.messages.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: MarkdownBody(
                                  data: _viewModel.messages[index],
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(fontSize: 15),
                                    strong: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
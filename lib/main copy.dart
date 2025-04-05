import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const String _apiKey = "AIzaSyAPwGfQo9eI2KubbXhabdH8ESDRR4s5Llo";

void main() {
  runApp(const InvoiceAnalyzerApp());
}

class InvoiceAnalyzerApp extends StatelessWidget {
  const InvoiceAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factura Analyzer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const InvoiceScannerScreen(),
    );
  }
}

class InvoiceScannerScreen extends StatefulWidget {
  const InvoiceScannerScreen({super.key});

  @override
  _InvoiceScannerScreenState createState() => _InvoiceScannerScreenState();
}

class _InvoiceScannerScreenState extends State<InvoiceScannerScreen> {
  File? _image;
  Uint8List? _webImage;
  final picker = ImagePicker();
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final List<String> _messages = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
    _chat = _model.startChat();
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
        analyzeImage(bytes);
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
        analyzeImage(await File(pickedFile.path).readAsBytes());
      }
    }
  }

  Future<void> analyzeImage(Uint8List imageBytes) async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await _chat.sendMessage(
        Content.multi([
          TextPart(
            """Solo extre no des mas conversacion ni una entrada de dialogo solo dame a la categoria que pertenece
            (Categorias: Alimentos,Hogar,Ropa,Salud ,Tecnología,Entretenimiento,Transporte,Mascotas,Otros:otros no pertenece a 
            ninguna de las otras categorias) ,productos y precios de esta factura y que esten en un formato json.
            
            Ejemplo :

              {
              "compras": [
                {
                  "categoria": "Alimentos",
                  "producto": "Manzana",
                  "precio": 1.50
                }
              }
            
            """,
          ),
          DataPart('image/jpeg', imageBytes),
        ]),
      );

      if (response.text != null) {
        setState(() {
          _messages.add(response.text!);
        });
      }
    } catch (e) {
      print('Error al analizar la imagen: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
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
              onPressed: getImage,
              child: const Text('Seleccionar Imagen'),
            ),
            if (kIsWeb && _webImage != null)
              Image.memory(_webImage!)
            else if (_image != null)
              Image.file(_image!),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MarkdownBody(data: _messages[index]),
                    ),
                  );
                },
              ),
            ),
            if (_loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

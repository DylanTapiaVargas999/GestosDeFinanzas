import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class JsonViewerScreen extends StatefulWidget {
  const JsonViewerScreen({super.key});

  @override
  State<JsonViewerScreen> createState() => _JsonViewerScreenState();
}

class _JsonViewerScreenState extends State<JsonViewerScreen> {
  String? jsonContent;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJsonFile();
  }

  Future<void> _loadJsonFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/response.json';
      final file = File(filePath);

      if (await file.exists()) {
        final content = await file.readAsString();

        // Intentamos formatear el contenido JSON
        try {
          final jsonData = jsonDecode(content);
          final formattedJson = const JsonEncoder.withIndent('  ').convert(jsonData);
          setState(() {
            jsonContent = formattedJson;
          });
        } catch (e) {
          // Si no se puede formatear, mostramos el contenido original
          setState(() {
            jsonContent = content;
          });
        }
      } else {
        setState(() {
          jsonContent = 'El archivo JSON no existe.';
        });
      }
    } catch (e) {
      setState(() {
        jsonContent = 'Error al leer el archivo JSON: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contenido del Archivo JSON'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : jsonContent == null || jsonContent!.isEmpty
                ? const Center(
                    child: Text(
                      'No hay contenido para mostrar.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : SingleChildScrollView(
                    child: Text(
                      jsonContent!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
      ),
    );
  }
}
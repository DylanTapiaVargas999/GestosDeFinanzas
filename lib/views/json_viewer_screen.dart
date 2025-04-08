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
        setState(() {
          jsonContent = content;
        });
      } else {
        setState(() {
          jsonContent = 'El archivo JSON no existe.';
        });
      }
    } catch (e) {
      setState(() {
        jsonContent = 'Error al leer el archivo JSON: ${e.toString()}';
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
        child: jsonContent == null
            ? const Center(child: CircularProgressIndicator())
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
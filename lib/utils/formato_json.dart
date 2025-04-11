import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<void> saveResponseToJson(String responseText) async {
    try {
      // Limpia el texto de la respuesta eliminando "```json" y "```"
      String cleanedResponse = responseText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Obtén el directorio de la aplicación
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/response.json';
      final file = File(filePath);

      // Inicializa una lista para almacenar los datos
      List<dynamic> existingData = [];

      // Si el archivo existe, lee su contenido y parsea el JSON
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          existingData = jsonDecode(content) as List<dynamic>;
        }
      }

      // Parsear la nueva respuesta como JSON
      final newData = jsonDecode(cleanedResponse);

      // Agregar los nuevos datos al contenido existente
      existingData.add(newData);

      // Guardar el contenido actualizado en el archivo
      await file.writeAsString(jsonEncode(existingData), mode: FileMode.write);

      print('Archivo actualizado y guardado en: $filePath');
    } catch (e) {
      print('Error al guardar el archivo: ${e.toString()}');
    }
  }
}
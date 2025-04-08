import 'dart:typed_data';
import 'package:gemini_3/viewmodels/image_picker_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io'; // Importa dart:io para manejar archivos
import 'package:path_provider/path_provider.dart'; // Para obtener el directorio de la aplicación

class InvoiceViewModel {
  final GenerativeModel _model;
  late final ChatSession _chat;
  final ImagePickerService _imagePickerService = ImagePickerService();

  List<String> messages = [];
  bool isLoading = false;
  Uint8List? currentImage;
  String? lastError;

  InvoiceViewModel({required String apiKey})
      : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey) {
    _chat = _model.startChat();
  }

  Future<void> saveResponseToJson(String responseText) async {
  try {
    // Obtén el directorio de la aplicación
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/response.json';

    // Escribe el contenido en el archivo
    final file = File(filePath);
    await file.writeAsString(responseText);

    messages.add('Archivo guardado en: $filePath');
  } catch (e) {
    lastError = 'Error al guardar el archivo: ${e.toString()}';
    messages.add(lastError!);
  }
  }

  // Método para seleccionar imagen de la galería
  Future<void> pickAndAnalyzeImageFromGallery() async {
    try {
      lastError = null;
      final imageBytes = await _imagePickerService.pickImageFromGallery();
      if (imageBytes == null) return;

      currentImage = imageBytes;
      await analyzeImage(imageBytes);
    } catch (e) {
      lastError = 'Error al seleccionar imagen: ${e.toString()}';
      messages.add(lastError!);
    }
  }

  // Método para capturar imagen de la cámara
  Future<void> captureAndAnalyzeImageFromCamera() async {
    try {
      lastError = null;
      // Verificar permisos de cámara
      final cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          lastError = 'Permisos de cámara denegados';
          messages.add(lastError!);
          return;
        }
      }

      final imageBytes = await _imagePickerService.captureImageFromCamera();
      if (imageBytes == null) return;

      currentImage = imageBytes;
      await analyzeImage(imageBytes);
    } catch (e) {
      lastError = 'Error al capturar imagen: ${e.toString()}';
      messages.add(lastError!);
    }
  }

  // Método para analizar la imagen (ahora público por si necesitas usarlo directamente)
  Future<void> analyzeImage(Uint8List imageBytes) async {
  isLoading = true;
  messages.add("Analizando factura...");
  
  try {
    final response = await _chat.sendMessage(
      Content.multi([
        TextPart("""
          Solo extrae no des más conversación ni una entrada de diálogo solo dame a la categoría que pertenece
          (Categorías: Alimentos, Hogar, Ropa, Salud, Tecnología, Entretenimiento, Transporte, Mascotas, Otros:otros no pertenece a 
          ninguna de las otras categorías), productos y precios de esta factura y que estén en un formato json.
          
          Ejemplo:
            {
              "compras": [
                {
                  "categoria": "Alimentos",
                  "producto": "Manzana",
                  "precio": 1.50
                }
              ]
            }
        """),
        DataPart('image/jpeg', imageBytes),
      ]),
    );

    if (response.text != null) {
      messages.add(response.text!);
      await saveResponseToJson(response.text!); // Guarda el texto en un archivo JSON
    }
  } catch (e) {
    lastError = 'Error al analizar la imagen: ${e.toString()}';
  } finally {
    isLoading = false;
  }
  }

  // Método para limpiar los datos
  void clearData() {
    messages.clear();
    currentImage = null;
    lastError = null;
    isLoading = false;
  }
}
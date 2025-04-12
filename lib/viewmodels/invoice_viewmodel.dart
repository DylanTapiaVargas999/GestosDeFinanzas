import 'dart:typed_data';
import 'package:gemini_3/utils/formato_json.dart';
import 'package:gemini_3/viewmodels/image_picker_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart'; // Importa el paquete para formatear fechas


class InvoiceViewModel {
  final GenerativeModel _model;
  late final ChatSession _chat;
  final ImagePickerService _imagePickerService = ImagePickerService();
  final String userId; // Agregamos el userId como propiedad

  List<String> messages = [];
  bool isLoading = false;
  Uint8List? currentImage;
  String? lastError;
  InvoiceViewModel({required String apiKey, required this.userId})
      : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey) {
    _chat = _model.startChat();
  }

  // Método para analizar una imagen
  Future<void> analyzeImage(Uint8List imageBytes) async {
    isLoading = true;
    messages.add("Analizando factura...");

    try {
      final response = await _chat.sendMessage(
        Content.multi([
          TextPart(_getAnalysisPrompt(userId)), // Pasamos el userId
          DataPart('image/jpeg', imageBytes),
        ]),
      );

      if (response.text != null) {
        messages.add(response.text!);
        await FileUtils.saveResponseToJson(response.text!); // Guarda el texto en un archivo JSON
      }
    } catch (e) {
      lastError = 'Error al analizar la imagen: ${e.toString()}';
      messages.add(lastError!);
    } finally {
      isLoading = false;
    }
  }

  // Método para procesar una factura en texto
  Future<void> processTextInvoice(String invoiceText) async {
    try {
      isLoading = true;
      messages.add("Procesando factura de texto...");

      final response = await _chat.sendMessage(
        Content.text(_getTextAnalysisPrompt(invoiceText, userId)), // Pasamos el userId
      );

      if (response.text != null) {
        messages.add(response.text!);
        await FileUtils.saveResponseToJson(response.text!); // Guarda el texto en un archivo JSON
      }
    } catch (e) {
      lastError = 'Error al procesar la factura de texto: ${e.toString()}';
      messages.add(lastError!);
    } finally {
      isLoading = false;
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
      final imageBytes = await _imagePickerService.captureImageFromCamera();
      if (imageBytes == null) return;

      currentImage = imageBytes;
      await analyzeImage(imageBytes);
    } catch (e) {
      lastError = 'Error al capturar imagen: ${e.toString()}';
      messages.add(lastError!);
    }
  }

  // Método para limpiar los datos
  void clearData() {
    messages.clear();
    currentImage = null;
    lastError = null;
    isLoading = false;
  }

    // Método para obtener la fecha actual en el formato deseado
  String _getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(now); // Formato: "día/mes/año"
  }

// Prompts reutilizables
  String _getAnalysisPrompt(String userId) {
    final currentDate = _getCurrentDate(); // Obtén la fecha actual
    return """
      Usuario: $userId

      Solo extrae no des más conversación ni una entrada de diálogo solo dame a la categoría que pertenece
      (Categorías: Alimentos, Hogar, Ropa, Salud, Tecnología, Entretenimiento, Transporte, Mascotas, Otros:otros no pertenece a 
      ninguna de las otras categorías),el nombre del producto,el precio, el usuario(El nombre de usuario ya esta definodo) y la fecha.Que estén en un formato json.
      Si la fecha no se especifica, usa la fecha actual: $currentDate.
      Si lo que se te entrega no es una factura, no respondas nada.
      Si la fecha está en el futuro reemplaza la fecha por la fecha actual: $currentDate.
      Si lo que se te entrega no son datos como precios o productos, no respondas nada.
      No tomar en cuenta las horas, minutos y segundos de la fecha.
      Ejemplo de tipo de respuesta que quiero:
        {
          "compras": [
            {
              "categoria": "Alimentos",
              "producto": "Manzana",
              "precio": 1.50,
              "usuario": "pedro perez",
              "fecha": "$currentDate"
            }
          ]
        }
    """;
  }

  String _getTextAnalysisPrompt(String invoiceText, String userId) {
    final currentDate = _getCurrentDate(); // Obtén la fecha actual
    return """
      Usuario: $userId

      Solo extrae no des más conversación ni una entrada de diálogo solo dame a la categoría que pertenece
      (Categorías: Alimentos, Hogar, Ropa, Salud, Tecnología, Entretenimiento, Transporte, Mascotas, Otros:otros no pertenece a 
      ninguna de las otras categorías),el nombre del producto,el precio, el usuario(El nombre de usuario ya esta definodo) y la fecha.Que estén en un formato json.
      Si la fecha no se especifica, usa la fecha actual: $currentDate.
      Si lo que se te entrega no son datos como precios o productos, no respondas nada.
      Si la fecha está en el futuro reemplaza la fecha por la fecha actual: $currentDate.
      No tomar en cuenta las horas, minutos y segundos de la fecha.
      Ejemplo de tipo de respuesta que quiero:
      {
        "compras": [
          {
            "categoria": "Alimentos",
            "producto": "Manzana",
            "precio": 1.50,
            "usuario": "pedro perez",
            "fecha": "$currentDate"
          }
        ]
      }
      
      Factura:
      $invoiceText
    """;
  }
}
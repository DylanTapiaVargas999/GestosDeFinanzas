import 'dart:typed_data';
import 'package:gemini_3/viewmodels/image_picker_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class InvoiceViewModel {
  final GenerativeModel _model;
  late final ChatSession _chat;
  final ImagePickerService _imagePickerService = ImagePickerService();

  List<String> messages = [];
  bool isLoading = false;
  Uint8List? currentImage;

  InvoiceViewModel({required String apiKey}) 
      : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey) {
    _chat = _model.startChat();
  }

  Future<void> pickAndAnalyzeImage() async {
    final imageBytes = await _imagePickerService.pickImage();
    if (imageBytes == null) return;

    currentImage = imageBytes;
    await _analyzeImage(imageBytes);
  }

  Future<void> _analyzeImage(Uint8List imageBytes) async {
    isLoading = true;
    
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
      }
    } catch (e) {
      messages.add('Error al analizar la imagen: $e');
    } finally {
      isLoading = false;
    }
  }
}
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    return await pickedFile.readAsBytes();
  }
}
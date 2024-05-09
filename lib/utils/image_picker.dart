import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  try {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
      source: ImageSource.gallery,
      requestFullMetadata: true,
    );

    return pickedImage;
  } catch (e) {
    throw Exception(e.toString());
  }
}
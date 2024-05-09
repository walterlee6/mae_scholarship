import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final _firebaseStorage = FirebaseStorage.instance;

  Future<String> saveImageToStorage({
    required XFile image,
    required String messageId,
  }) async {
    try {
      Reference ref = _firebaseStorage.ref('images').child(messageId);
      TaskSnapshot snapshot = await ref.putFile(File(image.path));
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

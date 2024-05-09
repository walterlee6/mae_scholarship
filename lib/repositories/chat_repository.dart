import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarship_application/extensions/extensions.dart';
import 'package:scholarship_application/modal/message.dart';
import 'package:scholarship_application/repositories/storage_repository.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  Future sendMessage({
    required String apiKey,
    required XFile? image,
    required String promptText,
  }) async {
    final textModel = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final imageModel =
        GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final sentMessageId = Uuid().v4();

    Message message = Message(
      id: sentMessageId,
      message: promptText,
      createdAt: DateTime.now(),
      isMine: true,
    );

    if (image != null) {
      final downloadUrl = await StorageRepository().saveImageToStorage(
        image: image,
        messageId: sentMessageId,
      );

      message = message.copyWith(imageUrl: downloadUrl);
    }

    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(userId)
        .collection('messages')
        .doc(sentMessageId)
        .set(message.toMap());

    GenerateContentResponse response;

    try {
      if (image == null) {
        response = await textModel.generateContent([Content.text(promptText)]);
      } else {
        final imageBytes = await image.readAsBytes();

        final prompt = TextPart(promptText);
        final mimeType = image.getMimeTypeFromExtension();
        final imagePart = DataPart(mimeType, imageBytes);

        response = await imageModel.generateContent([Content.multi([prompt, imagePart,])]);
      }
      final responseText = response.text;
      final receivedMessageId = Uuid().v4();
      final responseMessage = Message(
        id: receivedMessageId,
        message: responseText!,
        createdAt: DateTime.now(),
        isMine: false,
      );

      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .doc(receivedMessageId)
          .set(responseMessage.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future sendTextMessage({
    required String textPrompt,
    required String apiKey,
  }) async {
    try {
      final textModel = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final sentMessageId = Uuid().v4();

      Message message = Message(
        id: sentMessageId,
        message: textPrompt,
        createdAt: DateTime.now(),
        isMine: true,
      );

      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .doc(sentMessageId)
          .set(message.toMap());
      
      final response = await textModel.generateContent([Content.text(textPrompt)]);
      final responseText = response.text;
      final receivedMessageId = Uuid().v4();
      final responseMessage = Message(
        id: receivedMessageId,
        message: responseText!,
        createdAt: DateTime.now(),
        isMine: false,
      );
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .doc(receivedMessageId)
          .set(responseMessage.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final chatViewModelProvider = Provider((ref) => ChatViewModel(ref));

class ChatViewModel {
  ChatViewModel(this.ref);

  final Ref ref;

  Future<void> createChatRoom(String name) async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .add({'name': name});
  }

  Future<void> sendMessage(
      String content, String senderId, String roomId,{String? imageUrl}) async {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(roomId)
        .collection('message')
        .add({
      'senderId': senderId,
      'content': content,
      'imageUrl':imageUrl,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  Future<String?> uploadImage(String roomId, String senderId)async{
    final picker=ImagePicker();
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile==null)return null;
    final file=File(pickedFile.path);
    final storageRef=FirebaseStorage.instance.ref().child('chat_images/$roomId/${DateTime.now().toString()}');
    await storageRef.putFile(file);
    return await storageRef.getDownloadURL();

  }
}

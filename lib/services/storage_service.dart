import 'dart:typed_data';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  StorageService({FirebaseStorage? storage}) : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadUserCin({
    required String uid,
    required String fileName,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ref = _storage.ref('users/$uid/cin/$fileName');
    final metadata = SettableMetadata(contentType: contentType);
    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }

  Future<String> uploadProfilePhoto({
    required String userId,
    required XFile imageFile,
  }) async {
    final file = File(imageFile.path);
    final ref = _storage.ref('users/$userId/profile/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(file, metadata);
    return ref.getDownloadURL();
  }
}

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image
  Future<String> uploadImage(File file, String folder) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      String filePath = '$folder/$fileName';

      Reference ref = _storage.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw 'Failed to upload image.';
    }
  }

  // Upload document
  Future<String> uploadDocument(File file, String folder) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      String filePath = '$folder/$fileName';

      Reference ref = _storage.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw 'Failed to upload document.';
    }
  }

  // Upload profile image
  Future<String> uploadProfileImage(File file, String userId) async {
    return await uploadImage(file, 'profiles/$userId');
  }

  // Upload expense receipt
  Future<String> uploadExpenseReceipt(File file, String projectId) async {
    return await uploadImage(file, 'receipts/$projectId');
  }

  // Upload labour photo
  Future<String> uploadLabourPhoto(File file, String labourId) async {
    return await uploadImage(file, 'labour/$labourId');
  }

  // Delete file
  Future<void> deleteFile(String fileUrl) async {
    try {
      Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw 'Failed to delete file.';
    }
  }

  // Get download URL
  Future<String> getDownloadUrl(String filePath) async {
    try {
      Reference ref = _storage.ref().child(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      throw 'Failed to get download URL.';
    }
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class FirebaseStorageHelper {
  static Future<String?> uploadImageToFirebase(
    BuildContext context,
    PlatformFile file,
  ) async {
    try {
      // Get file name and create storage reference
      String fileName = file.name;
      String filePath = file.path!;
      final storageRef = FirebaseStorage.instance.ref().child(
        'ConsultantProfilePics/$fileName',
      );

      UploadTask uploadTask;

      if (kIsWeb) {
        // Web: Upload as bytes
        Uint8List? fileBytes = file.bytes;
        if (fileBytes == null) return null;
        uploadTask = storageRef.putData(fileBytes);
      } else {
        // Mobile: Upload file
        File file = File(filePath);
        uploadTask = storageRef.putFile(file);
      }

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File uploaded successfully")),
        );
      }

      return downloadUrl;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to upload file: $e")));
      }
      return null;
    }
  }

  static Future<String?> uploadDocumentToFirebase(
    PlatformFile file,
    BuildContext context,
  ) async {
    try {
      String fileName =
          "${basename(file.name)}_${DateTime.now().millisecondsSinceEpoch}";
      Reference storageRef = FirebaseStorage.instance.ref().child(
        'ConsultantsDocuments/$fileName',
      );

      UploadTask uploadTask;

      if (kIsWeb) {
        // Web: Upload as bytes
        if (file.bytes == null) return null;
        uploadTask = storageRef.putData(file.bytes!);
      } else {
        // Mobile: Upload as file
        if (file.path == null) return null;
        uploadTask = storageRef.putFile(File(file.path!));
      }

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully uploaded document")),
        );
      }

      return downloadUrl;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload document: $e")),
        );
      }

      return null;
    }
  }

  static Future<bool> deleteImageFromFirebase(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      debugPrint("Error deleting image: $e");
      return false;
    }
  }

  static Future<String?> getFileType(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      final metadata = await ref.getMetadata();
      return metadata.contentType;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> uploadImageOrFileToFirebase(
    BuildContext context,
    PlatformFile file,
  ) async {
    try {
      // Get file name and extension
      String fileName = file.name;
      String filePath = file.path!;

      // Determine the folder based on file type
      String folder = 'ConsultantBills';

      final storageRef = FirebaseStorage.instance.ref().child(
        '$folder/$fileName',
      );

      UploadTask uploadTask;

      if (kIsWeb) {
        Uint8List? fileBytes = file.bytes;
        if (fileBytes == null) return null;
        uploadTask = storageRef.putData(fileBytes);
      } else {
        File fileToUpload = File(filePath);
        uploadTask = storageRef.putFile(fileToUpload);
      }

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File uploaded successfully")),
        );
      }

      return downloadUrl;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to upload file: $e")));
      }
      return null;
    }
  }
}

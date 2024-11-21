import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart'; // For Firebase Realtime Database

class HomeController extends GetxController {
  // Firebase Realtime Database reference
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("notes");

  // Observable list to store notes
  var notes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotes(); // Fetch notes on initialization
  }

  // Fetch notes from Firebase Realtime Database
  Future<void> fetchNotes() async {
    _dbRef.onValue.listen((event) {
      final snapshotValue = event.snapshot.value;

      if (snapshotValue == null) {
        notes.value = []; // No data
        return;
      }

      try {
        if (snapshotValue is Map<dynamic, dynamic>) {
          // Map structure handling
          notes.value = snapshotValue.entries
              .map((entry) => {
            "id": entry.key.toString(), // Using Firebase's unique ID
            ...(entry.value as Map<dynamic, dynamic>).cast<String, dynamic>(),
          })
              .toList();
        } else {
          throw Exception("Unsupported data structure: ${snapshotValue.runtimeType}");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Data parsing error: $e");
        }
        Get.snackbar("Error", "Failed to load notes. Please try again.");
      }
    });
  }

  // Add a note to Firebase Realtime Database
  Future<void> addNote(String title, String note) async {
    try {
      // Ensure a valid reference
      final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('notes');
      final String noteId = _dbRef.push().key ?? ""; // Generate a unique ID

      if (noteId.isEmpty) {
        Get.snackbar("Error", "Failed to generate note ID");
        return;
      }

      final data = {
        "title": title,
        "note": note,
        "timestamp": DateTime.now().toIso8601String(),
      };

      // Save to Firebase
      await _dbRef.child(noteId).set(data);
      Get.snackbar("Success", "Note added successfully!");
    } catch (error) {
      Get.snackbar("Error", "Failed to add note: $error");
    }
  }

  // Delete a note from Firebase Realtime Database
  Future<void> deleteNote(String id) async {
    try {
      await _dbRef.child(id).remove();
      Get.snackbar("Success", "Note deleted successfully!");
    } catch (error) {
      if (kDebugMode) {
        print("Delete note error: $error");
      }
      Get.snackbar("Error", "Failed to delete note: $error");
    }
  }
}

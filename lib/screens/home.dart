import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controllers.dart';
import 'all_notes.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var size = Get.size;
    final HomeController controller = Get.put(HomeController());

    final titleController = TextEditingController();
    final noteController = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (titleController.text.trim().isEmpty && noteController.text.trim().isEmpty) {
            // Show a toaster message
            Get.snackbar(
              "Error",
              "Why such rush? Write something.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            // Save the note to Firebase
            controller.addNote(
              titleController.text.trim(),
              noteController.text.trim(),
            );

            titleController.clear();
            noteController.clear();
          }
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.save_as_outlined, color: Colors.white),
      ),

      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              // onTap: () => Get.toNamed('/all-notes'),
              onTap: () => Get.to(() => const AllNotes()),
              child: const Icon(Icons.format_list_bulleted, color: Colors.white,)),
          ),
        ],
        title: const Text(
          'Loose Leaf',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title:',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: noteController,
                      cursorColor: Colors.white,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start writing...',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  
  }
}

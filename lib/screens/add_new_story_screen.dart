import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_api_dicoding/model/api_response.dart';
import 'package:story_api_dicoding/repository/story_repository.dart';

class AddNewStory extends StatefulWidget {
  AddNewStory({super.key});

  @override
  State<AddNewStory> createState() => _AddNewStoryState();
}

class _AddNewStoryState extends State<AddNewStory> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  PlatformFile? _imageFile;
  bool isLoading = false;

  void _logout(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Logout Success")));
        context.goNamed('login');
      }
    });
  }

  Future<void> _pickImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null) return;

    setState(() {
      _photoController.text = result.files.single.path!;
      _imageFile = result.files.single;
    });
  }

  Future<void> _uploadStory(PlatformFile? imageFile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        if (context.mounted) _logout(context);
      }
      ApiResponse apiResponse = await StoryRepository(
        token: token!,
      ).postNewStory(
        description: _descriptionController.text,
        photoFile: imageFile,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(apiResponse.message)));
        context.goNamed('home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } else {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Story')),
      body: Container(
        padding: const EdgeInsets.all(32),
        height: deviceSize.height,
        width: deviceSize.width,
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                controller: _photoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () {
                      _pickImage();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(4),
                ),
                width: deviceSize.width,
                height: deviceSize.width - (32 * 2),
                child: _buildIimagePreview(_imageFile),
                    // _imageFile == null
                    //     ? Center(child: Text("No Image Uploaded"))
                    //     : (kIsWeb)
                    //     ? Image.memory(_imageFile!.bytes!, fit: BoxFit.cover)
                    //     : Image.file(File(_imageFile!.path!)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await _uploadStory(_imageFile).then((_) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                },
                child: Text("Upload"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIimagePreview(PlatformFile? file){
    if (file == null) {
      return const Center(child: Text("No Image Uploaded"));
    }

    if (kIsWeb && file.bytes != null) {
      return Image.memory(file.bytes!, fit: BoxFit.cover);
    }

    if (!kIsWeb && file.path != null) {
      return Image.file(File(file.path!), fit: BoxFit.cover);
    }

    return const Center(child: Text("Failed to load image"));
  }
}

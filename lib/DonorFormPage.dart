import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonorFormPage extends ConsumerStatefulWidget {
  const DonorFormPage({super.key});

  @override
  ConsumerState<DonorFormPage> createState() => _DonorFormPageState();
}

class _DonorFormPageState extends ConsumerState<DonorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  File? _imageFile;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final supabase = Supabase.instance.client;
      String? imageUrl;

      // Upload image to Supabase storage if selected
      if (_imageFile != null) {
        final fileName = 'donor_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.storage.from('media').upload(fileName, _imageFile!);
        imageUrl = supabase.storage.from('media').getPublicUrl(fileName);
      }

      // Insert into posts table
      await supabase.from('posts').insert({
        'title': _titleCtrl.text,
        'description': _descCtrl.text,
        'location': _locCtrl.text,
        'role': 'donor',
        'kind': 'donation',
        'images': imageUrl != null ? [imageUrl] : [],
        'likes': 0,
      });

      if (mounted) {
        Navigator.pop(context); // Go back to feed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Donation post created ✅")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Donation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v!.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Enter description" : null,
              ),
              TextFormField(
                controller: _locCtrl,
                decoration: const InputDecoration(labelText: "Location"),
              ),
              const SizedBox(height: 12),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : const SizedBox(),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pick Image"),
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text("Post Donation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

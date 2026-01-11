import 'package:flutter/material.dart';

class NGOFormPage extends StatefulWidget {
  const NGOFormPage({super.key});

  @override
  State<NGOFormPage> createState() => _NGOFormPageState();
}

class _NGOFormPageState extends State<NGOFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCategory;

  final List<String> categories = [
    "Clothes",
    "Food",
    "Medicine",
    "Shelter",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NGO Request Form"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Request Title",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter a title" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter a description" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  setState(() => _selectedCategory = val);
                },
                validator: (val) => val == null ? "Select category" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter location" : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add image/document picker here
                },
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Document / Image"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Save NGO request to Supabase
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Request Submitted ✅")),
                    );
                  }
                },
                child: const Text("Submit Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

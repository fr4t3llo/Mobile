// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NewEntryPage extends StatefulWidget {
  final String userId;

  const NewEntryPage({super.key, required this.userId});

  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedEmoji = '📝';
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> _emojiOptions = [
    '😊',
    '😢',
    '😍',
    '😎',
    '🥳',
    '😴',
    '🏃',
    '🌧️',
    '☀️',
    '🎉',
    '📚',
    '🍔',
    '💼',
    '🎮',
    '🎵',
    '📝',
    '❤️',
    '🤔',
  ];

  void _saveEntry() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String? userEmail = _auth.currentUser?.email;
      await FirebaseFirestore.instance.collection('diary_entries').add({
        'userId': widget.userId,
        'userEmail': userEmail ?? 'No email',
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'emoji': _selectedEmoji,
        'date': Timestamp.now(),
      });

      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving entry: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Diary Entry'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_as_outlined, color: Colors.black),
            onPressed: _isLoading ? null : _saveEntry,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Mood',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _emojiOptions.length,
                        itemBuilder: (context, index) {
                          final emoji = _emojiOptions[index];
                          final isSelected = emoji == _selectedEmoji;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedEmoji = emoji;
                              });
                            },
                            child: Container(
                              width: 50,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.indigo.shade100
                                        : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    isSelected
                                        ? Border.all(
                                          color: Colors.indigo,
                                          width: 2,
                                        )
                                        : null,
                              ),
                              child: Center(
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'What happened today?',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

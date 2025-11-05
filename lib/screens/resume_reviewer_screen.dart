import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/auth_provider.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ResumeReviewerScreen extends StatefulWidget {
  const ResumeReviewerScreen({super.key});

  @override
  State<ResumeReviewerScreen> createState() => _ResumeReviewerScreenState();
}

class _ResumeReviewerScreenState extends State<ResumeReviewerScreen> {
  File? _pickedFile;
  String? _feedback;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
        _feedback = null; // Clear old review
      });
    }
  }

  Future<void> _reviewResume() async {
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a PDF file first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _feedback = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final apiService = authProvider.apiService;

      final response = await apiService.reviewResume(_pickedFile!);

      setState(() {
        _feedback = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _feedback = '❌ Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Reviewer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Card(
              color: Colors.blue[50],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'How it works',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pick your resume below and our AI will provide:\n'
                      '• A quick summary\n'
                      '• Three key strengths\n'
                      '• Three areas for improvement',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // File picker button
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(
                _pickedFile == null
                    ? 'Pick a PDF Resume'
                    : 'File: ${_pickedFile!.path.split('/').last.split('\\').last}',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 16),

            // Review button
            ElevatedButton.icon(
              onPressed:
                  (_pickedFile == null || _isLoading) ? null : _reviewResume,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.rate_review),
              label: Text(_isLoading ? 'Reviewing...' : 'Get AI Review'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            // Feedback section
            if (_feedback != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    'AI Feedback',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: GptMarkdown(
                  _feedback!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

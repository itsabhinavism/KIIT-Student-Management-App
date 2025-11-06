import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/teaching_section_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/kiit_logo_widget.dart';

class CreateNoticeScreen extends StatefulWidget {
  const CreateNoticeScreen({super.key});

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();

  String _type = 'notice';
  String _scope = 'section';
  String? _selectedUniqueId;
  List<TeachingSection> _sections = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _loadSections() async {
    final user = context.read<AuthProvider>().user;
    if (user?.role == 'teacher') {
      try {
        final apiService = context.read<AuthProvider>().apiService;
        final sections = await apiService.getMyTeachingSections();
        setState(() {
          _sections = sections;
          if (sections.isNotEmpty) {
            _selectedUniqueId = sections.first.uniqueId;
          }
        });
      } catch (e) {
        // Handle error silently
        print(e);
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Find the section ID from the unique ID
    String? sectionIdToSubmit;
    if (_scope == 'section') {
      if (_selectedUniqueId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a section')),
        );
        return;
      }
      // Find the matching section object
      final selectedSection = _sections.firstWhere(
        (s) => s.uniqueId == _selectedUniqueId,
      );
      sectionIdToSubmit = selectedSection.sectionId;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = context.read<AuthProvider>().apiService;

      await apiService.createNotice(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _type,
        scope: _scope,
        sectionId: sectionIdToSubmit,
        registrationLink: _type == 'event' && _linkController.text.isNotEmpty
            ? _linkController.text.trim()
            : null,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_type == 'event' ? 'Event' : 'Notice'} created successfully',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final isAdmin = user?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Notice/Event'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: const [
          KiitLogoWidget(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type selector
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'notice', child: Text('Notice')),
                DropdownMenuItem(value: 'event', child: Text('Event')),
              ],
              onChanged: (value) {
                setState(() => _type = value!);
              },
            ),

            const SizedBox(height: 16),

            // Scope selector
            if (isAdmin)
              DropdownButtonFormField<String>(
                initialValue: 'global',
                decoration: const InputDecoration(
                  labelText: 'Scope',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'global', child: Text('Global')),
                ],
                onChanged: (value) {
                  setState(() => _scope = value!);
                },
              )
            else
              DropdownButtonFormField<String>(
                initialValue: _scope,
                decoration: const InputDecoration(
                  labelText: 'Scope',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'section', child: Text('Section')),
                ],
                onChanged: (value) {
                  setState(() => _scope = value!);
                },
              ),

            const SizedBox(height: 16),

            // Section selector for teachers
            if (_scope == 'section' && !isAdmin)
              DropdownButtonFormField<String>(
                initialValue: _selectedUniqueId,
                decoration: const InputDecoration(
                  labelText: 'Select Section',
                  border: OutlineInputBorder(),
                ),
                items: _sections
                    .map((section) => DropdownMenuItem(
                          value: section.uniqueId,
                          child: Text(section.displayName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedUniqueId = value);
                },
                validator: (value) {
                  if (_scope == 'section' && value == null) {
                    return 'Please select a section';
                  }
                  return null;
                },
              ),

            if (_scope == 'section' && !isAdmin) const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Registration link (only for events)
            if (_type == 'event') ...[
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Registration Link (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
            ],

            // Submit button
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Create ${_type == 'event' ? 'Event' : 'Notice'}'),
            ),
          ],
        ),
      ),
    );
  }
}

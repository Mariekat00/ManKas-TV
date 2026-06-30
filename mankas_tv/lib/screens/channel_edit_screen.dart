import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/admin_service.dart';
import '../services/snackbar_service.dart';
import '../utils/app_strings.dart';

class ChannelEditScreen extends StatefulWidget {
  final Channel? channel;

  const ChannelEditScreen({super.key, this.channel});

  @override
  State<ChannelEditScreen> createState() => _ChannelEditScreenState();
}

class _ChannelEditScreenState extends State<ChannelEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _logoController = TextEditingController();
  final _categoryController = TextEditingController();
  final _countryController = TextEditingController();
  final _languageController = TextEditingController();
  final AdminService _admin = AdminService();
  bool _isLoading = false;

  bool get _isEditing => widget.channel != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = widget.channel!.name;
      _urlController.text = widget.channel!.streamUrl;
      _logoController.text = widget.channel!.logo ?? '';
      _categoryController.text = widget.channel!.category ?? '';
      _countryController.text = widget.channel!.country ?? '';
      _languageController.text = widget.channel!.language ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _logoController.dispose();
    _categoryController.dispose();
    _countryController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final channel = Channel(
      id: widget.channel?.id ?? '',
      name: _nameController.text.trim(),
      logo: _logoController.text.trim().isEmpty ? null : _logoController.text.trim(),
      streamUrl: _urlController.text.trim(),
      category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
      country: _countryController.text.trim().isEmpty ? null : _countryController.text.trim(),
      language: _languageController.text.trim().isEmpty ? null : _languageController.text.trim(),
    );

    try {
      if (_isEditing) {
        await _admin.updateChannel(channel);
        AppSnackBarService.instance.success('"${channel.name}" modifiée');
      } else {
        await _admin.addChannel(channel);
        AppSnackBarService.instance.success('"${channel.name}" ajoutée');
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      AppSnackBarService.instance.error('Erreur: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier' : AppStrings.of(context).addChannel),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL du flux *',
                  hintText: 'https://...m3u8',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _logoController,
                decoration: const InputDecoration(
                  labelText: 'URL du logo',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  hintText: 'Sports, News, Music...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(
                        labelText: 'Pays',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _languageController,
                      decoration: const InputDecoration(
                        labelText: 'Langue',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _isLoading ? null : _save,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_isEditing ? 'Enregistrer' : AppStrings.of(context).addChannel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

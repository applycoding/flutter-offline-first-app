import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/templates.dart';
import '../providers.dart';

class NewInspectionSheet extends ConsumerStatefulWidget {
  const NewInspectionSheet({super.key});

  @override
  ConsumerState<NewInspectionSheet> createState() => _NewInspectionSheetState();
}

class _NewInspectionSheetState extends ConsumerState<NewInspectionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _siteController = TextEditingController();
  final _assetController = TextEditingController();
  final _inspectorController = TextEditingController(text: 'Arpan Bom');
  String _template = checklistTemplates.keys.first;
  String? _error;

  @override
  void dispose() {
    _siteController.dispose();
    _assetController.dispose();
    _inspectorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final site = _siteController.text.trim();
    final asset = _assetController.text.trim();
    final inspector = _inspectorController.text.trim();
    if (site.isEmpty) {
      setState(() => _error = 'Enter a site name.');
      return;
    }
    if (asset.isEmpty) {
      setState(() => _error = 'Enter an asset id.');
      return;
    }
    if (inspector.isEmpty) {
      setState(() => _error = 'Enter the inspector name.');
      return;
    }
    await ref.read(repositoryProvider).create(
          siteName: site,
          assetId: asset,
          inspector: inspector,
          templateName: _template,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final height = MediaQuery.sizeOf(context).height * 0.85;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: height,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Text(
                'New inspection',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Saved on this device first. Sync sends it when you are online.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('field-site'),
                controller: _siteController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Site'),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('field-asset'),
                controller: _assetController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Asset id'),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('field-inspector'),
                controller: _inspectorController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Inspector'),
              ),
              const SizedBox(height: 12),
              Text('Template', style: Theme.of(context).textTheme.titleSmall),
              RadioGroup<String>(
                groupValue: _template,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _template = value);
                },
                child: Column(
                  children: [
                    for (final name in checklistTemplates.keys)
                      RadioListTile<String>(
                        key: Key('template-$name'),
                        contentPadding: EdgeInsets.zero,
                        title: Text(name),
                        value: name,
                      ),
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  key: const Key('form-error'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('create-inspection'),
                onPressed: _submit,
                child: const Text('Create inspection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verb.dart';
import '../providers/verb_provider.dart';
import '../theme/app_theme.dart';

class VerbFormSheet extends StatefulWidget {
  final Verb? verb;

  const VerbFormSheet({super.key, this.verb});

  @override
  State<VerbFormSheet> createState() => _VerbFormSheetState();
}

class _VerbFormSheetState extends State<VerbFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _baseCtrl;
  late final TextEditingController _pastCtrl;
  late final TextEditingController _ppCtrl;
  late final TextEditingController _meaningCtrl;
  late final TextEditingController _exampleCtrl;
  late final TextEditingController _notesCtrl;
  late bool _isIrregular;
  bool _isSaving = false;

  bool get _isEditing => widget.verb != null;

  @override
  void initState() {
    super.initState();
    _baseCtrl = TextEditingController(text: widget.verb?.baseForm ?? '');
    _pastCtrl = TextEditingController(text: widget.verb?.pastSimple ?? '');
    _ppCtrl = TextEditingController(text: widget.verb?.pastParticiple ?? '');
    _meaningCtrl = TextEditingController(text: widget.verb?.meaning ?? '');
    _exampleCtrl = TextEditingController(text: widget.verb?.example ?? '');
    _notesCtrl = TextEditingController(text: widget.verb?.notes ?? '');
    _isIrregular = widget.verb?.isIrregular ?? true;
  }

  @override
  void dispose() {
    _baseCtrl.dispose();
    _pastCtrl.dispose();
    _ppCtrl.dispose();
    _meaningCtrl.dispose();
    _exampleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = context.read<VerbProvider>();
    final verb = Verb(
      id: widget.verb?.id,
      baseForm: _baseCtrl.text,
      pastSimple: _pastCtrl.text,
      pastParticiple: _ppCtrl.text,
      meaning: _meaningCtrl.text.isEmpty ? null : _meaningCtrl.text,
      example: _exampleCtrl.text.isEmpty ? null : _exampleCtrl.text,
      notes: _notesCtrl.text.isEmpty ? null : _notesCtrl.text,
      isIrregular: _isIrregular,
      isFavorite: widget.verb?.isFavorite ?? false,
      createdAt: widget.verb?.createdAt,
    );

    if (_isEditing) {
      await provider.updateVerb(verb);
    } else {
      await provider.addVerb(verb);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Verb updated' : 'Verb added')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    _isEditing ? 'Edit verb' : 'Add new verb',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.black),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _isIrregular = !_isIrregular),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _isIrregular ? AppTheme.amberSoft : AppTheme.greenSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _isIrregular ? 'Irregular' : 'Regular',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _isIrregular ? const Color(0xFF854F0B) : const Color(0xFF3B6D11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionLabel(text: 'Verb forms *'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _Field(controller: _baseCtrl, hint: 'Base form', validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 8),
                  Expanded(child: _Field(controller: _pastCtrl, hint: 'Past simple', validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 8),
                  Expanded(child: _Field(controller: _ppCtrl, hint: 'Past participle', validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 16),
              _SectionLabel(text: 'Meaning'),
              const SizedBox(height: 8),
              _Field(controller: _meaningCtrl, hint: 'e.g. ir · to move from one place to another'),
              const SizedBox(height: 16),
              _SectionLabel(text: 'Example sentence'),
              const SizedBox(height: 8),
              _Field(controller: _exampleCtrl, hint: 'e.g. She went to the store yesterday.', maxLines: 2),
              const SizedBox(height: 16),
              _SectionLabel(text: 'Notes'),
              const SizedBox(height: 8),
              _Field(controller: _notesCtrl, hint: 'Any additional notes or tips…', maxLines: 2),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(_isEditing ? 'Save changes' : 'Add verb'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.medGray, letterSpacing: 0.3),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({required this.controller, required this.hint, this.maxLines = 1, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      textCapitalization: TextCapitalization.none,
      style: const TextStyle(fontSize: 14, color: AppTheme.black),
      decoration: InputDecoration(hintText: hint),
    );
  }
}

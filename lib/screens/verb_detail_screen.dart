import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verb.dart';
import '../providers/verb_provider.dart';
import '../widgets/verb_form_sheet.dart';
import '../theme/app_theme.dart';

class VerbDetailScreen extends StatelessWidget {
  final Verb verb;

  const VerbDetailScreen({super.key, required this.verb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(verb.baseForm),
        actions: [
          IconButton(
            onPressed: () => context.read<VerbProvider>().toggleFavorite(verb),
            icon: Icon(
              verb.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: verb.isFavorite ? AppTheme.amber : AppTheme.medGray,
            ),
          ),
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => VerbFormSheet(verb: verb),
            ),
            icon: const Icon(Icons.edit_outlined, color: AppTheme.medGray),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verb.baseForm,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: AppTheme.black),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: verb.isIrregular ? AppTheme.amberSoft : AppTheme.greenSoft,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                verb.isIrregular ? 'Irregular verb' : 'Regular verb',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: verb.isIrregular ? const Color(0xFF854F0B) : const Color(0xFF3B6D11),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Verb forms card
            Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.lightGray.withOpacity(0.7), width: 0.5),
              ),
              child: Column(
                children: [
                  _FormRow(label: 'Base form', value: verb.baseForm, color: AppTheme.black),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _FormRow(label: 'Past simple', value: verb.pastSimple, color: const Color(0xFF185FA5)),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  _FormRow(label: 'Past participle', value: verb.pastParticiple, color: const Color(0xFF3B6D11)),
                ],
              ),
            ),

            if (verb.meaning != null && verb.meaning!.isNotEmpty) ...[
              const SizedBox(height: 20),
              const _SectionHeader(text: 'Meaning'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.lightGray.withOpacity(0.7), width: 0.5),
                ),
                child: Text(verb.meaning!, style: const TextStyle(fontSize: 15, color: AppTheme.black)),
              ),
            ],

            if (verb.example != null && verb.example!.isNotEmpty) ...[
              const SizedBox(height: 20),
              const _SectionHeader(text: 'Example'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.blueSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB5D4F4), width: 0.5),
                ),
                child: Text(
                  '"${verb.example!}"',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF185FA5), fontStyle: FontStyle.italic, height: 1.6),
                ),
              ),
            ],

            if (verb.notes != null && verb.notes!.isNotEmpty) ...[
              const SizedBox(height: 20),
              const _SectionHeader(text: 'Notes'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.amberSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFAC775), width: 0.5),
                ),
                child: Text(verb.notes!, style: const TextStyle(fontSize: 14, color: Color(0xFF633806), height: 1.6)),
              ),
            ],

            const SizedBox(height: 20),
            Text(
              'Added ${_formatDate(verb.createdAt)}',
              style: const TextStyle(fontSize: 11, color: AppTheme.lightGray),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _FormRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _FormRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.medGray)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.medGray, letterSpacing: 1.0),
    );
  }
}

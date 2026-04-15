import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verb_provider.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VerbProvider>(
      builder: (ctx, provider, _) {
        // Always show stats for all verbs, regardless of active filters
        final all = provider.getAllVerbsForPractice();
        final irregular = all.where((v) => v.isIrregular).length;
        final regular = all.length - irregular;
        final favorites = all.where((v) => v.isFavorite).length;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Stats', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppTheme.black)),
                  const SizedBox(height: 4),
                  const Text('Your learning progress', style: TextStyle(fontSize: 13, color: AppTheme.medGray)),
                  const SizedBox(height: 24),

                  // Cards row
                  Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Total verbs', value: '${all.length}', color: AppTheme.blue, softColor: AppTheme.blueSoft)),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(label: 'Favorites', value: '$favorites', color: AppTheme.amber, softColor: AppTheme.amberSoft)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Irregular', value: '$irregular', color: const Color(0xFF854F0B), softColor: AppTheme.amberSoft)),
                      const SizedBox(width: 12),
                      Expanded(child: _StatCard(label: 'Regular', value: '$regular', color: AppTheme.green, softColor: AppTheme.greenSoft)),
                    ],
                  ),

                  if (all.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    const _SectionHeader(text: 'Verb types'),
                    const SizedBox(height: 12),
                    _ProgressBar(label: 'Irregular', value: irregular, total: all.length, color: AppTheme.amber),
                    const SizedBox(height: 10),
                    _ProgressBar(label: 'Regular', value: regular, total: all.length, color: AppTheme.green),
                    const SizedBox(height: 28),
                    const _SectionHeader(text: 'Recently added'),
                    const SizedBox(height: 12),
                    ...all.reversed.take(5).map((v) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.lightGray.withOpacity(0.6), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Text(v.baseForm, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.black)),
                            const SizedBox(width: 10),
                            Text('→ ${v.pastSimple} / ${v.pastParticiple}', style: const TextStyle(fontSize: 13, color: AppTheme.medGray)),
                            const Spacer(),
                            if (v.isFavorite) Icon(Icons.star_rounded, size: 14, color: AppTheme.amber),
                          ],
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color softColor;

  const _StatCard({required this.label, required this.value, required this.color, required this.softColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.7), fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _ProgressBar({required this.label, required this.value, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? value / total : 0.0;
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.medGray)),
            const Spacer(),
            Text('$value', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.black)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AppTheme.lightGray.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
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

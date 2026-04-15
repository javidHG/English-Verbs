import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verb.dart';
import '../providers/verb_provider.dart';
import '../theme/app_theme.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<Verb> _queue = [];
  int _index = 0;
  final _pastCtrl = TextEditingController();
  final _ppCtrl = TextEditingController();
  bool _checked = false;
  bool _isCorrect = false;
  int _correct = 0;
  int _total = 0;
  bool _sessionDone = false;
  bool _sessionStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<VerbProvider>();
      if (provider.isLoaded && !provider.isLoading) {
        _startSession();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.watch<VerbProvider>();
    if (provider.isLoaded && !provider.isLoading && !_sessionStarted) {
      _sessionStarted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startSession();
      });
    }
  }

  @override
  void dispose() {
    _pastCtrl.dispose();
    _ppCtrl.dispose();
    super.dispose();
  }

  void _startSession() {
    final provider = context.read<VerbProvider>();
    final all = provider.getAllVerbsForPractice();
    all.shuffle();
    final verbs = all.take(10.clamp(0, all.length)).toList();
    setState(() {
      _queue = verbs;
      _index = 0;
      _correct = 0;
      _total = 0;
      _checked = false;
      _sessionDone = false;
      _sessionStarted = true;
      _pastCtrl.clear();
      _ppCtrl.clear();
    });
  }

  Verb? get _currentVerb => _index < _queue.length ? _queue[_index] : null;

  void _check() {
    if (_currentVerb == null) return;
    final v = _currentVerb!;
    final pastOk = _normalize(_pastCtrl.text) == _normalize(v.pastSimple);
    final ppOk = _normalize(_ppCtrl.text) == _normalize(v.pastParticiple);
    final correct = pastOk && ppOk;
    setState(() {
      _checked = true;
      _isCorrect = correct;
      _total++;
      if (correct) _correct++;
    });
  }

  String _normalize(String s) => s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  void _next() {
    if (_index + 1 >= _queue.length) {
      setState(() => _sessionDone = true);
    } else {
      setState(() {
        _index++;
        _checked = false;
        _isCorrect = false;
        _pastCtrl.clear();
        _ppCtrl.clear();
      });
    }
  }

  void _reveal() {
    final v = _currentVerb!;
    setState(() {
      _pastCtrl.text = v.pastSimple;
      _ppCtrl.text = v.pastParticiple;
      _checked = true;
      _isCorrect = false;
      _total++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VerbProvider>();

    if (provider.isLoading && !provider.isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.darkGray)),
      );
    }

    if (_queue.isEmpty && provider.isLoaded) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_outlined, size: 48, color: AppTheme.lightGray),
                const SizedBox(height: 16),
                const Text('Add verbs first', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.medGray)),
                const SizedBox(height: 6),
                const Text('Go to Verbs tab and add some', style: TextStyle(fontSize: 13, color: AppTheme.lightGray)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: _startSession, child: const Text('Try again')),
              ],
            ),
          ),
        ),
      );
    }

    if (_sessionDone) return _buildResults();

    final verb = _currentVerb;
    if (verb == null) return const SizedBox.shrink();

    final progress = (_index + 1) / _queue.length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Practice', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppTheme.black)),
                  const Spacer(),
                  Text('${_index + 1} / ${_queue.length}', style: const TextStyle(fontSize: 13, color: AppTheme.medGray)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppTheme.lightGray.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.blue),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.lightGray.withOpacity(0.7), width: 0.5),
                ),
                child: Column(
                  children: [
                    const Text('What are the forms of…', style: TextStyle(fontSize: 13, color: AppTheme.medGray)),
                    const SizedBox(height: 12),
                    Text(verb.baseForm, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: AppTheme.black)),
                    if (verb.meaning != null && verb.meaning!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(verb.meaning!, style: const TextStyle(fontSize: 13, color: AppTheme.medGray)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _InputRow(label: 'Past simple', controller: _pastCtrl, enabled: !_checked),
              const SizedBox(height: 10),
              _InputRow(label: 'Past participle', controller: _ppCtrl, enabled: !_checked),
              const SizedBox(height: 24),
              if (_checked)
                _FeedbackBanner(isCorrect: _isCorrect, correctPast: verb.pastSimple, correctPP: verb.pastParticiple),
              const Spacer(),
              if (!_checked)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _reveal,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.lightGray),
                          foregroundColor: AppTheme.medGray,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Reveal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(onPressed: _check, child: const Text('Check')),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    child: Text(_index + 1 < _queue.length ? 'Next verb →' : 'See results'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final pct = _total > 0 ? (_correct / _total * 100).round() : 0;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: pct >= 70 ? AppTheme.greenSoft : AppTheme.amberSoft,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$pct%',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: pct >= 70 ? const Color(0xFF3B6D11) : const Color(0xFF854F0B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                pct >= 80 ? 'Excellent!' : pct >= 60 ? 'Good work!' : 'Keep practicing!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.black),
              ),
              const SizedBox(height: 10),
              Text(
                '$_correct correct out of $_total verbs',
                style: const TextStyle(fontSize: 15, color: AppTheme.medGray),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _sessionStarted = false);
                    _startSession();
                  },
                  child: const Text('Practice again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const _InputRow({required this.label, required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.medGray)),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            style: const TextStyle(fontSize: 14, color: AppTheme.black),
            textCapitalization: TextCapitalization.none,
            decoration: InputDecoration(hintText: label),
          ),
        ),
      ],
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final String correctPast;
  final String correctPP;

  const _FeedbackBanner({required this.isCorrect, required this.correctPast, required this.correctPP});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect ? AppTheme.greenSoft : AppTheme.redSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCorrect ? const Color(0xFFC0DD97) : const Color(0xFFF7C1C1), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle_outline : Icons.info_outline,
            color: isCorrect ? const Color(0xFF3B6D11) : AppTheme.red,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isCorrect
                ? const Text('Correct!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF3B6D11)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Incorrect', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.red)),
                      const SizedBox(height: 2),
                      Text('Past: $correctPast  ·  PP: $correctPP', style: const TextStyle(fontSize: 12, color: AppTheme.medGray)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

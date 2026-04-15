import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verb_provider.dart';
import '../widgets/verb_card.dart';
import '../widgets/verb_form_sheet.dart';
import '../theme/app_theme.dart';
import 'verb_detail_screen.dart';

class VerbListScreen extends StatefulWidget {
  const VerbListScreen({super.key});

  @override
  State<VerbListScreen> createState() => _VerbListScreenState();
}

class _VerbListScreenState extends State<VerbListScreen> {
  final _searchCtrl = TextEditingController();
  bool _searchVisible = false;
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VerbProvider>().loadVerbs();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VerbFormSheet(),
    );
  }

  void _confirmDelete(BuildContext ctx, int id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.white,
        title: const Text('Delete verb',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: const Text('This verb will be permanently removed.',
            style: TextStyle(fontSize: 14, color: AppTheme.medGray)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.medGray)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<VerbProvider>().deleteVerb(id);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Verb deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VerbProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(provider),
                if (_searchVisible) _buildSearchBar(provider),
                _buildFilterRow(provider),
                Expanded(child: _buildList(provider)),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddSheet,
            backgroundColor: AppTheme.darkGray,
            foregroundColor: AppTheme.cream,
            elevation: 0,
            child: const Icon(Icons.add, size: 24),
          ),
        );
      },
    );
  }

  Widget _buildHeader(VerbProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My Verbs',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black)),
              Text('${provider.totalCount} verbs saved',
                  style: const TextStyle(fontSize: 13, color: AppTheme.medGray)),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                _searchVisible = !_searchVisible;
                if (!_searchVisible) {
                  _searchCtrl.clear();
                  provider.search('');
                } else {
                  Future.delayed(const Duration(milliseconds: 100),
                      () => _searchFocus.requestFocus());
                }
              });
            },
            icon: Icon(
              _searchVisible ? Icons.search_off_rounded : Icons.search_rounded,
              color: AppTheme.darkGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(VerbProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: TextField(
        controller: _searchCtrl,
        focusNode: _searchFocus,
        onChanged: provider.search,
        style: const TextStyle(fontSize: 14, color: AppTheme.black),
        decoration: InputDecoration(
          hintText: 'Search by any form or meaning…',
          prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.medGray),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchCtrl.clear();
                    provider.search('');
                  },
                  child: const Icon(Icons.close, size: 16, color: AppTheme.medGray),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterRow(VerbProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // ── Sort ──────────────────────────────────────────────
            _Chip(
              label: 'A–Z',
              active: provider.sortOrder == SortOrder.alphabetical,
              onTap: () => provider.setSortOrder(SortOrder.alphabetical),
            ),
            const SizedBox(width: 6),
            _Chip(
              label: 'Recent',
              active: provider.sortOrder == SortOrder.recent,
              onTap: () => provider.setSortOrder(SortOrder.recent),
            ),
            // ── Divider ───────────────────────────────────────────
            Container(
              height: 20, width: 0.5,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: AppTheme.lightGray,
            ),
            // ── Filters ───────────────────────────────────────────
            // Favorites filter: shows ONLY favorites when active
            _Chip(
              label: '★  Favorites',
              active: provider.favoritesOnly,
              onTap: provider.toggleFavoritesFilter,
              activeColor: AppTheme.amber,
              activeTextColor: const Color(0xFF633806),
              activeBorderColor: const Color(0xFFFAC775),
            ),
            const SizedBox(width: 6),
            _Chip(
              label: 'Irregular',
              active: provider.typeFilter == true,
              onTap: () => provider.setTypeFilter(true),
              activeColor: AppTheme.amberSoft,
              activeTextColor: const Color(0xFF854F0B),
              activeBorderColor: const Color(0xFFFAC775),
            ),
            const SizedBox(width: 6),
            _Chip(
              label: 'Regular',
              active: provider.typeFilter == false,
              onTap: () => provider.setTypeFilter(false),
              activeColor: AppTheme.greenSoft,
              activeTextColor: const Color(0xFF3B6D11),
              activeBorderColor: const Color(0xFFC0DD97),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(VerbProvider provider) {
    if (provider.isLoading) {
      return const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.darkGray));
    }

    if (provider.verbs.isEmpty) {
      final hasFilter = provider.typeFilter != null ||
          provider.favoritesOnly ||
          provider.searchQuery.isNotEmpty;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              provider.favoritesOnly
                  ? Icons.star_outline_rounded
                  : Icons.menu_book_outlined,
              size: 48,
              color: AppTheme.lightGray,
            ),
            const SizedBox(height: 16),
            Text(
              provider.favoritesOnly
                  ? 'No favorites yet'
                  : hasFilter
                      ? 'No verbs match the filter'
                      : 'No verbs yet',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.medGray),
            ),
            const SizedBox(height: 6),
            Text(
              provider.favoritesOnly
                  ? 'Tap the star on any verb to save it here'
                  : hasFilter
                      ? 'Try changing or removing the filter'
                      : 'Tap + to add your first verb',
              style: const TextStyle(fontSize: 13, color: AppTheme.lightGray),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: provider.verbs.length,
      itemBuilder: (ctx, i) {
        final verb = provider.verbs[i];
        return VerbCard(
          // KEY based on verb id — not on list position.
          // This forces Flutter to create a fresh widget when the verb
          // object is replaced, preventing the blank-card bug caused by
          // Slidable holding onto stale state.
          key: ValueKey(verb.id),
          verb: verb,
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => VerbDetailScreen(verb: verb)),
          ),
          onDelete: () => _confirmDelete(ctx, verb.id!),
          onToggleFavorite: () => provider.toggleFavorite(verb),
          onEdit: () => showModalBottomSheet(
            context: ctx,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => VerbFormSheet(verb: verb),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip widget
// ─────────────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? activeTextColor;
  final Color? activeBorderColor;

  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
    this.activeColor,
    this.activeTextColor,
    this.activeBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg     = active ? (activeColor      ?? AppTheme.darkGray) : AppTheme.white;
    final text   = active ? (activeTextColor  ?? AppTheme.cream)    : AppTheme.medGray;
    final border = active ? (activeBorderColor ?? activeColor ?? AppTheme.darkGray) : AppTheme.lightGray;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: text),
        ),
      ),
    );
  }
}

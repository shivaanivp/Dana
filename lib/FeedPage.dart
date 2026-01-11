import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'DonorFormPage.dart';
import 'NGOFormPage.dart';

final sbp = Provider((ref) => Supabase.instance.client);
final feedS = StreamProvider((ref) => ref
    .read(sbp)
    .from('posts')
    .stream(primaryKey: ['id'])
    .order('created_at', ascending: false));

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(feedS);
    return Scaffold(
      appBar: AppBar(title: const Text('Give On Feed')),
      floatingActionButton: PopupMenuButton<String>(
        onSelected: (v) {
          if (v == 'donor') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonorFormPage()),
            );
          }
          if (v == 'ngo') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NGOFormPage()),
            );
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'donor', child: Text('Donor Post')),
          PopupMenuItem(value: 'ngo', child: Text('NGO Request')),
        ],
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
      body: s.when(
        data: (rows) {
          if (rows.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rows.length,
            itemBuilder: (_, i) {
              final p = rows[i] as Map<String, dynamic>;
              return PostCard(p: p);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class PostCard extends ConsumerWidget {
  final Map<String, dynamic> p;
  const PostCard({super.key, required this.p});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imgs = (p['imgs'] as List?)?.cast<String>() ?? [];
    final dt = DateTime.tryParse((p['created_at'] ?? '').toString());
    final ts = dt == null
        ? ''
        : '${dt.toLocal()}'.split('.').first;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Chip(label: Text((p['role'] ?? '').toString().toUpperCase())),
              const SizedBox(width: 8),
              Chip(label: Text((p['kind'] ?? '').toString().toUpperCase())),
              const Spacer(),
              Text(ts, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
            if ((p['title'] ?? '').toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  (p['title'] ?? '').toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if ((p['txt'] ?? '').toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text((p['txt'] ?? '').toString()),
              ),
            if (imgs.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: imgs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imgs[i],
                        width: 260,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(children: [
              LikeBtn(id: (p['id'] ?? '').toString()),
              const SizedBox(width: 12),
              TxtBtn(
                label: 'Comment',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comments page coming next')),
                  );
                },
              ),
              const Spacer(),
              if ((p['kind'] == 'donation') && (p['status'] != 'completed'))
                TxtBtn(label: 'Claim', onTap: () {}),
            ])
          ],
        ),
      ),
    );
  }
}

class TxtBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const TxtBtn({super.key, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class LikeBtn extends ConsumerStatefulWidget {
  final String id;
  const LikeBtn({super.key, required this.id});
  @override
  ConsumerState<LikeBtn> createState() => _LS();
}

class _LS extends ConsumerState<LikeBtn> {
  int c = 0;
  bool me = false;
  bool ld = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    final sb = Supabase.instance.client;
    final u = sb.auth.currentUser;
    final r = await sb
        .from('likes')
        .select('user_id')
        .eq('post_id', widget.id)
        .count(CountOption.exact);
    final r2 = u == null
        ? null
        : await sb
        .from('likes')
        .select('post_id')
        .eq('post_id', widget.id)
        .eq('user_id', u.id)
        .maybeSingle();
    setState(() {
      c = r.count ?? 0;
      me = r2 != null;
      ld = false;
    });
  }

  Future _toggle() async {
    final sb = Supabase.instance.client;
    final u = sb.auth.currentUser;
    if (u == null) return;
    if (me) {
      await sb.from('likes').delete().match({'post_id': widget.id, 'user_id': u.id});
      setState(() {
        me = false;
        c = (c - 1).clamp(0, 1 << 31);
      });
    } else {
      await sb.from('likes').insert({'post_id': widget.id, 'user_id': u.id});
      setState(() {
        me = true;
        c = c + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ld) return const SizedBox.shrink();
    return Row(children: [
      IconButton(
        onPressed: _toggle,
        icon: Icon(me ? Icons.favorite : Icons.favorite_border),
      ),
      Text('$c')
    ]);
  }
}

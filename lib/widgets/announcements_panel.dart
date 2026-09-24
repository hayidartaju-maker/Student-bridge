import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_roles.dart';
import '../providers/app_provider.dart';
import '../services/supabase_service.dart';

class AnnouncementsPanel extends StatefulWidget {
  final AppRole role;

  const AnnouncementsPanel({super.key, required this.role});

  @override
  State<AnnouncementsPanel> createState() => _AnnouncementsPanelState();
}

class _AnnouncementsPanelState extends State<AnnouncementsPanel> {
  late Future<List<Announcement>> _future;

  @override
  void initState() {
    super.initState();
    _future = SupabaseService.instance.fetchAnnouncements();
  }

  void _reload() {
    setState(() => _future = SupabaseService.instance.fetchAnnouncements());
  }

  Future<void> _createAnnouncement() async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add announcement'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a title'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: bodyController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Message'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a message'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              try {
                await SupabaseService.instance.createAnnouncement(
                  title: titleController.text,
                  body: bodyController.text,
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } catch (error) {
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text('Could not publish announcement: $error')),
                );
              }
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );

    titleController.dispose();
    bodyController.dispose();
    if (created == true && mounted) _reload();
  }

  Future<void> _deleteAnnouncement(Announcement item) async {
    final id = item.id;
    if (id == null) return;
    await SupabaseService.instance.deleteAnnouncement(id);
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == AppRole.admin;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.campaign_rounded),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'School notices',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
                if (isAdmin)
                  IconButton(
                    tooltip: 'Add notice',
                    onPressed: _createAnnouncement,
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
              ],
            ),
            FutureBuilder<List<Announcement>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text('Notices are unavailable'),
                    subtitle: Text('${snapshot.error}'),
                    trailing: IconButton(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  );
                }

                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('No school notices yet.'),
                  );
                }

                return Column(
                  children: items.map((item) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.title),
                      subtitle: Text(item.body),
                      isThreeLine: true,
                      leading: const CircleAvatar(
                        child: Icon(Icons.notifications_none_rounded),
                      ),
                      trailing: isAdmin
                          ? IconButton(
                              tooltip: 'Delete notice',
                              onPressed: () => _deleteAnnouncement(item),
                              icon: const Icon(Icons.delete_outline_rounded),
                            )
                          : null,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/notice_model.dart';
import '../../providers/auth_provider.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  late Future<List<Notice>> _noticesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  void _loadNotices() {
    final apiService = context.read<AuthProvider>().apiService;
    setState(() {
      _noticesFuture = apiService.getNotices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final canCreate = user?.role == 'teacher' || user?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices & Events'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadNotices(),
        child: FutureBuilder<List<Notice>>(
          future: _noticesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final notices = snapshot.data ?? [];

            if (notices.isEmpty) {
              return const Center(
                child: Text('No notices or events yet'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return _NoticeCard(notice: notice);
              },
            );
          },
        ),
      ),
      floatingActionButton: canCreate
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-notice')
                    .then((_) => _loadNotices());
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    final isEvent = notice.isEvent;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isEvent ? Colors.blue[100] : Colors.orange[100],
          child: Icon(
            isEvent ? Icons.event : Icons.campaign,
            color: isEvent ? Colors.blue : Colors.orange,
          ),
        ),
        title: Text(
          notice.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notice.description != null) ...[
              const SizedBox(height: 4),
              Text(
                notice.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              _formatDate(notice.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (!notice.isGlobal)
              Text(
                'Section Notice',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        trailing: isEvent && notice.registrationLink != null
            ? IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () => _launchUrl(notice.registrationLink!),
              )
            : null,
        onTap: () => _showDetails(context),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notice.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (notice.description != null) Text(notice.description!),
              const SizedBox(height: 8),
              if (notice.isEvent && notice.registrationLink != null) ...[
                const Divider(),
                TextButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Registration Link'),
                  onPressed: () {
                    _launchUrl(notice.registrationLink!);
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

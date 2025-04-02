import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class EventsScreen extends ConsumerWidget {
  final List<Map<String, dynamic>> pastEvents = [
    {
      'id': '1',
      'name': "Pratijja '24",
      'date': "18 March 2024",
      'icon': Icons.sports_esports,
      'color': Colors.amber,
      'category': "Gaming",
      'location': "Main Auditorium",
      'description': "Annual gaming festival with competitions and workshops",
    },
    {
      'id': '2',
      'name': "Kritarth V.06",
      'date': "9 November 2024",
      'icon': Icons.people,
      'color': Colors.blue,
      'category': "Cultural",
      'location': "Open Air Theater",
      'description': "Cultural fest showcasing talent from across India",
    },
  ];

  final List<Map<String, dynamic>> upcomingEvents = [
    {
      'id': '7',
      'name': "TedXKIIT",
      'date': "5 April 2025",
      'icon': Icons.mic,
      'color': Colors.orange,
      'category': "Conference",
      'location': "Campus Auditorium",
      'description': "Ideas worth spreading from inspiring speakers",
    },
  ];
  EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider) == AppTheme.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KIIT Events'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.red.shade800, Colors.red.shade900]
                  : [Colors.red.shade400, Colors.red.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade900,
              Colors.grey.shade800,
            ],
          )
              : LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade100,
              Colors.red.shade200,
            ],
          ),
        ),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Upcoming', icon: Icon(Icons.upcoming)),
                    Tab(text: 'Past Events', icon: Icon(Icons.history)),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildEventList(upcomingEvents, context, isDarkMode, theme),
                    _buildEventList(pastEvents, context, isDarkMode, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(List<Map<String, dynamic>> events,
      BuildContext context, bool isDarkMode, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isDarkMode
              ? Colors.blueGrey.shade800.withOpacity(0.7)
              : Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/event-detail',
                arguments: event,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: event['color'].withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      event['icon'],
                      color: event['color'],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['name'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${event['date']} • ${event['location']}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white54 : Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: _EventSearchDelegate(events: [...upcomingEvents, ...pastEvents]),
    );
  }
}

class _EventSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> events;

  _EventSearchDelegate({required this.events});

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final results = events.where((e) => e['name'].toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(results[index]['name']),
      ),
    );
  }
}

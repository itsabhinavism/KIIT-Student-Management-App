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
    {
      'id': '3',
      'name': "TechExpo 2024",
      'date': "15 February 2024",
      'icon': Icons.computer,
      'color': Colors.deepPurple,
      'category': "Technology",
      'location': "Convention Center",
      'description': "Exhibition of latest tech innovations and demos",
    },
    {
      'id': '4',
      'name': "Startup Weekend",
      'date': "20 January 2024",
      'icon': Icons.lightbulb,
      'color': Colors.teal,
      'category': "Entrepreneurship",
      'location': "Innovation Hub",
      'description': "Pitch your startup ideas and win funding",
    },
    {
      'id': '5',
      'name': "KIIT MUN 2023",
      'date': "25 October 2023",
      'icon': Icons.account_balance,
      'color': Colors.orange,
      'category': "Debate",
      'location': "Law Campus",
      'description': "Model United Nations with global participation",
    },
    {
      'id': '6',
      'name': "DesignCon 2023",
      'date': "12 September 2023",
      'icon': Icons.design_services,
      'color': Colors.pink,
      'category': "Design",
      'location': "Design Block",
      'description': "Creative design conference and showcase",
    },
    {
      'id': '7',
      'name': "AI Symposium",
      'date': "5 August 2023",
      'icon': Icons.memory,
      'color': Colors.red,
      'category': "AI",
      'location': "Main Hall",
      'description': "Talks on latest AI trends and research",
    },
    {
      'id': '8',
      'name': "Photography Expo",
      'date': "22 July 2023",
      'icon': Icons.camera_alt,
      'color': Colors.brown,
      'category': "Art",
      'location': "Exhibition Gallery",
      'description': "Showcase of best student photography",
    },
    {
      'id': '9',
      'name': "LitFest 2023",
      'date': "10 June 2023",
      'icon': Icons.menu_book,
      'color': Colors.cyan,
      'category': "Literature",
      'location': "Central Library",
      'description': "Literary fest featuring authors and poets",
    },
    {
      'id': '10',
      'name': "Dance Off 2023",
      'date': "5 May 2023",
      'icon': Icons.music_note,
      'color': Colors.purple,
      'category': "Dance",
      'location': "Dance Hall",
      'description': "Dance battle between university teams",
    },
  ];

  final List<Map<String, dynamic>> upcomingEvents = [
    {
      'id': '1',
      'name': "TedXKIIT",
      'date': "5 April 2025",
      'icon': Icons.mic,
      'color': Colors.orange,
      'category': "Conference",
      'location': "Campus Auditorium",
      'description': "Ideas worth spreading from inspiring speakers",
    },
    {
      'id': '2',
      'name': "KIIT Sports Meet",
      'date': "20 April 2025",
      'icon': Icons.sports_soccer,
      'color': Colors.green,
      'category': "Sports",
      'location': "Sports Complex",
      'description': "Annual sports meet with inter-college tournaments",
    },
    {
      'id': '3',
      'name': "Code Fiesta",
      'date': "15 May 2025",
      'icon': Icons.code,
      'color': Colors.indigo,
      'category': "Hackathon",
      'location': "Tech Park",
      'description': "24-hour coding competition with exciting prizes",
    },
    {
      'id': '4',
      'name': "Eco Fest 2025",
      'date': "8 June 2025",
      'icon': Icons.eco,
      'color': Colors.lightGreen,
      'category': "Environment",
      'location': "Green Campus",
      'description': "Awareness fest for sustainable living and ecology",
    },
    {
      'id': '5',
      'name': "Music Mania",
      'date': "25 June 2025",
      'icon': Icons.music_note,
      'color': Colors.deepOrange,
      'category': "Music",
      'location': "Open Arena",
      'description': "Battle of bands and solo performances",
    },
    {
      'id': '6',
      'name': "Legal Awareness Drive",
      'date': "10 July 2025",
      'icon': Icons.gavel,
      'color': Colors.blueGrey,
      'category': "Law",
      'location': "Law Campus",
      'description': "Workshops and sessions on legal literacy",
    },
    {
      'id': '7',
      'name': "Blockchain Bootcamp",
      'date': "30 July 2025",
      'icon': Icons.lock,
      'color': Colors.blueAccent,
      'category': "Technology",
      'location': "IT Block",
      'description': "Hands-on workshop on blockchain applications",
    },
    {
      'id': '8',
      'name': "Robotics Challenge",
      'date': "12 August 2025",
      'icon': Icons.precision_manufacturing,
      'color': Colors.cyan,
      'category': "Engineering",
      'location': "Robotics Lab",
      'description': "National-level robotics design and programming",
    },
    {
      'id': '9',
      'name': "Innovation Fair",
      'date': "1 September 2025",
      'icon': Icons.science,
      'color': Colors.pink,
      'category': "Innovation",
      'location': "Innovation Hub",
      'description': "Showcase of creative student inventions",
    },
    {
      'id': '10',
      'name': "KIIT Job Fair",
      'date': "20 September 2025",
      'icon': Icons.work,
      'color': Colors.teal,
      'category': "Career",
      'location': "Placement Cell",
      'description': "Career opportunities and company meetups",
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
            colors: [Colors.grey.shade900, Colors.grey.shade800],
          )
              : LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade100, Colors.red.shade200],
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
      delegate:
      _EventSearchDelegate(events: [...upcomingEvents, ...pastEvents]),
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
    final results = events
        .where((e) => e['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(results[index]['name']),
      ),
    );
  }
}

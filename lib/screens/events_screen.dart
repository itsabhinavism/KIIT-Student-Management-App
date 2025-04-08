import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  final String rollNumber;

  const EventsScreen({Key? key, required this.rollNumber}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'name': 'KIIT Fest 2025',
      'date': 'April 10, 2025',
      'location': 'Campus 3 Ground',
      'icon': Icons.celebration,
      'color': Colors.orange,
    },
    {
      'name': 'Tech Conclave',
      'date': 'April 15, 2025',
      'location': 'Auditorium Hall A',
      'icon': Icons.memory,
      'color': Colors.blue,
    },
    {
      'name': 'Startup Expo',
      'date': 'April 18, 2025',
      'location': 'Innovation Hub',
      'icon': Icons.rocket_launch,
      'color': Colors.green,
    },
    {
      'name': 'Sports Meet',
      'date': 'April 20, 2025',
      'location': 'Main Stadium',
      'icon': Icons.sports_basketball,
      'color': Colors.deepPurple,
    },
    {
      'name': 'AI Symposium',
      'date': 'April 25, 2025',
      'location': 'Academic Block C',
      'icon': Icons.psychology,
      'color': Colors.teal,
    },
    {
      'name': 'Cultural Night',
      'date': 'April 28, 2025',
      'location': 'Campus 5 Amphitheatre',
      'icon': Icons.music_note,
      'color': Colors.pink,
    },
    {
      'name': 'Internship Fair',
      'date': 'May 1, 2025',
      'location': 'T&P Hall',
      'icon': Icons.work,
      'color': Colors.amber,
    },
    {
      'name': 'Greenathon',
      'date': 'May 3, 2025',
      'location': 'Eco Park',
      'icon': Icons.eco,
      'color': Colors.lightGreen,
    },
    {
      'name': 'Cybersecurity Talk',
      'date': 'May 6, 2025',
      'location': 'Hall B1',
      'icon': Icons.security,
      'color': Colors.red,
    },
    {
      'name': 'KIIT Hackathon',
      'date': 'May 10, 2025',
      'location': 'Innovation Lab',
      'icon': Icons.code,
      'color': Colors.deepOrange,
    },
  ];

  final List<Map<String, dynamic>> _pastEvents = [
    {
      'name': 'Orientation Day',
      'date': 'March 1, 2025',
      'location': 'Campus 1 Auditorium',
      'icon': Icons.travel_explore,
      'color': Colors.blueGrey,
    },
    {
      'name': 'Womens Day Celebration',
      'date': 'March 8, 2025',
      'location': 'Central Stage',
      'icon': Icons.female,
      'color': Colors.purple,
    },
    {
      'name': 'Spring Coding Challenge',
      'date': 'March 12, 2025',
      'location': 'Lab Block 2',
      'icon': Icons.terminal,
      'color': Colors.indigo,
    },
    {
      'name': 'Design Thinking Workshop',
      'date': 'March 16, 2025',
      'location': 'Studio Lab',
      'icon': Icons.design_services,
      'color': Colors.cyan,
    },
    {
      'name': 'E-Summit 2025',
      'date': 'March 20, 2025',
      'location': 'Convention Centre',
      'icon': Icons.trending_up,
      'color': Colors.orangeAccent,
    },
    {
      'name': 'Holika Dahan',
      'date': 'March 24, 2025',
      'location': 'Campus Ground',
      'icon': Icons.local_fire_department,
      'color': Colors.redAccent,
    },
    {
      'name': 'World Water Day Talk',
      'date': 'March 22, 2025',
      'location': 'Seminar Hall',
      'icon': Icons.water_drop,
      'color': Colors.blueAccent,
    },
    {
      'name': 'Alumni Interaction',
      'date': 'March 26, 2025',
      'location': 'Conference Hall',
      'icon': Icons.people,
      'color': Colors.teal,
    },
    {
      'name': 'Photography Walk',
      'date': 'March 28, 2025',
      'location': 'Campus Trails',
      'icon': Icons.camera_alt,
      'color': Colors.deepOrange,
    },
    {
      'name': 'Farewell 2025',
      'date': 'March 30, 2025',
      'location': 'Campus Main Hall',
      'icon': Icons.sentiment_satisfied,
      'color': Colors.lime,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.red.shade50,
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _EventSearchDelegate(
                  allEvents: [..._upcomingEvents, ..._pastEvents],
                  isDarkMode: isDarkMode,
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black45,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(_upcomingEvents, context, isDarkMode, theme),
          _buildEventList(_pastEvents, context, isDarkMode, theme),
        ],
      ),
    );
  }

  Widget _buildEventList(
      List<Map<String, dynamic>> events,
      BuildContext context,
      bool isDarkMode,
      ThemeData theme,
      ) {
    return Container(
      color: isDarkMode ? Colors.black : Colors.red.shade50,
      child: ListView.builder(
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
            color: isDarkMode ? Colors.red.shade900 : Colors.red.shade100,
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
                        color: event['color'].withOpacity(isDarkMode ? 0.3 : 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        event['icon'],
                        color: isDarkMode ? event['color'].withOpacity(0.8) : event['color'],
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
      ),
    );
  }
}

class _EventSearchDelegate extends SearchDelegate<Map<String, dynamic>> {
  final List<Map<String, dynamic>> allEvents;
  final bool isDarkMode;

  _EventSearchDelegate({required this.allEvents, required this.isDarkMode});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black87),
        titleTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey),
        border: InputBorder.none,
      ),
    );
  }


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
    onPressed: () => close(context, {}),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final filteredEvents = allEvents
        .where((event) =>
        event['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.red.shade100,
            child: ListTile(
              leading: Icon(event['icon'], color: event['color']),
              title: Text(event['name']),
              subtitle: Text('${event['date']} • ${event['location']}'),
              onTap: () => close(context, event),
            ),
          );
        },
      ),
    );
  }
}

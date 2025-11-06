import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/schedule_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/kiit_logo_widget.dart';

class FullScheduleScreen extends StatefulWidget {
  const FullScheduleScreen({super.key});

  @override
  State<FullScheduleScreen> createState() => _FullScheduleScreenState();
}

class _FullScheduleScreenState extends State<FullScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
    final now = DateTime.now();
    final dayIndex = now.weekday - 1;
    if (dayIndex >= 0 && dayIndex < _days.length) {
      _tabController.index = dayIndex;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Scaffold(
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    Colors.black,
                    Colors.black,
                  ]
                : [
                    const Color(0xFFe3f2fd),
                    const Color(0xFFbbdefb),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom header
              _buildCustomHeader(context, isDarkMode),
              
              // Tab bar
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16, 
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: isDarkMode 
                      ? Colors.white70 
                      : Colors.black54,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                  tabs: _days.map((day) => 
                    Tab(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(day.substring(0, 3)),
                      ),
                    )
                  ).toList(),
                ),
              ),
              
              // Content
              Expanded(
                child: FutureBuilder<List<ScheduleItem>>(
                  future: context.read<ApiService>().getFullSchedule(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.blue.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading schedule...',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return _buildErrorState(isDarkMode, snapshot.error.toString());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState(isDarkMode);
                    }

                    final scheduleByDay = <String, List<ScheduleItem>>{};
                    for (final day in _days) {
                      scheduleByDay[day] = [];
                    }
                    for (final item in snapshot.data!) {
                      if (scheduleByDay.containsKey(item.day)) {
                        scheduleByDay[item.day]!.add(item);
                      }
                    }

                    return TabBarView(
                      controller: _tabController,
                      children: _days.map((day) {
                        final classes = scheduleByDay[day] ?? [];
                        if (classes.isEmpty) {
                          return _buildNoDayClasses(day, isDarkMode);
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: isDarkMode 
                                ? Colors.black.withOpacity(0.2)
                                : Colors.white.withOpacity(0.3),
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                            itemCount: classes.length,
                            itemBuilder: (context, index) {
                              return TweenAnimationBuilder(
                                duration: Duration(milliseconds: 400 + (index * 100)),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, double value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 30 * (1 - value)),
                                      child: _buildClassCard(
                                        classes[index], 
                                        isDarkMode,
                                        context,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16, 
        vertical: isSmallScreen ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.calendar_month, 
              color: Colors.white, 
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Schedule',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                if (!isSmallScreen)
                  Text(
                    'Your class timetable',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          KiitLogoWidget(height: isSmallScreen ? 28 : 35),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.event_busy,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No schedule available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for your class schedule',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDarkMode, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade400, Colors.orange.shade400],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Error loading schedule',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDayClasses(String day, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.beach_access,
            size: 60,
            color: Colors.blue.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No classes on $day',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enjoy your free day!',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(ScheduleItem item, bool isDarkMode, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  Colors.blue.shade900.withOpacity(0.6),
                  Colors.purple.shade900.withOpacity(0.6),
                ]
              : [
                  Colors.white,
                  Colors.blue.shade50,
                ],
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.blue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 14 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course name and code
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.courseName,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 15 : 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12, 
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    item.courseCode,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Time
            _buildInfoRow(
              Icons.access_time_rounded,
              '${item.formattedStartTime} - ${item.formattedEndTime}',
              Colors.green,
              isDarkMode,
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 8 : 10),
            
            // Room
            _buildInfoRow(
              Icons.room_rounded,
              item.roomNumber,
              Colors.orange,
              isDarkMode,
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 8 : 10),
            
            // Teacher
            _buildInfoRow(
              Icons.person_rounded,
              item.teacherName,
              Colors.purple,
              isDarkMode,
              isSmallScreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon, 
    String text, 
    Color color, 
    bool isDarkMode, 
    bool isSmallScreen,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
          ),
          child: Icon(
            icon,
            size: isSmallScreen ? 16 : 18,
            color: color,
          ),
        ),
        SizedBox(width: isSmallScreen ? 10 : 12),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 15,
              color: isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/api_service.dart';
import '../../models/schedule_model.dart'; // We need this model

/// TeacherAttendanceScreen: Generate QR codes for attendance
class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  // NEW: This future will hold the teacher's schedule
  late Future<List<ScheduleItem>> _scheduleFuture;

  String? _sessionId;
  bool _isLoading = false;

  // NEW: We get the ApiService in initState
  @override
  void initState() {
    super.initState();
    // Fetch the schedule when the screen loads
    _scheduleFuture = context.read<ApiService>().getTodaySchedule();
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  // MODIFIED: This now takes the class details as parameters
  Future<void> _createAttendanceSession(
      String courseId, String sectionId, ApiService apiService) async {
    setState(() => _isLoading = true);

    try {
      // Get current location
      final position = await _getCurrentLocation();

      // Use the IDs from the class they tapped
      final sessionId = await apiService.createAttendanceSession(
        courseId: courseId,
        sectionId: sectionId,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() {
        _sessionId = sessionId;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create session: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  // NEW: Helper to build the list of classes
  Widget _buildScheduleList(
      List<ScheduleItem> schedule, ApiService apiService) {
    if (schedule.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No Classes Today',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You have no classes scheduled for today.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Display the list of classes
    return ListView.builder(
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final item = schedule[index];
        // Using the formatted getters from our ScheduleItem model
        final timeString =
            '${item.formattedStartTime} - ${item.formattedEndTime}';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              child: const Icon(Icons.class_),
            ),
            title: Text(
              item.course.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('$timeString\nSection: ${item.section.sectionName}'),
            trailing: _isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.qr_code_scanner, color: Colors.blue),
            onTap: _isLoading
                ? null // Disable tap while loading
                : () => _createAttendanceSession(
                    item.course.id, item.section.id, apiService),
          ),
        );
      },
    );
  }

  // NEW: Helper to build the QR display (copied from your original code)
  Widget _buildQrDisplay() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Attendance QR Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: PrettyQrView.data(
                      data: _sessionId!,
                      decoration: const PrettyQrDecoration(
                        shape: PrettyQrSmoothSymbol(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Session ID: $_sessionId',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 24),
                  // "End Session" button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _sessionId = null);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Class List'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Students can scan this QR code to mark their attendance',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiService = context.read<ApiService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Attendance Session'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      // MODIFIED: The body now shows one of two states
      body: _sessionId == null
          ? FutureBuilder<List<ScheduleItem>>(
              future: _scheduleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                // We have the schedule, build the list
                return _buildScheduleList(snapshot.data ?? [], apiService);
              },
            )
          // Otherwise, show the QR code
          : _buildQrDisplay(),
    );
  }
}

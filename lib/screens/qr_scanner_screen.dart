import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;
  String? scannedData;
  bool attendanceMarked = false;
  DateTime? scanTime;
  bool isProcessing = false;
  String? errorMessage;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (!isScanning || isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          isScanning = false;
          isProcessing = true;
          scannedData = barcode.rawValue;
          scanTime = DateTime.now();
          errorMessage = null;
        });

        // Mark attendance through API
        _markAttendance(barcode.rawValue!);
        break;
      }
    }
  }

  Future<void> _markAttendance(String token) async {
    try {
      // Get user's current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
            'Location services are disabled. Please enable location services.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Call API to mark attendance
      if (!mounted) return;
      final apiService = context.read<ApiService>();
      final result = await apiService.scanAttendance(
        token: token,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (mounted) {
        setState(() {
          attendanceMarked = result['success'] ?? true;
          isProcessing = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    result['message'] ?? 'Attendance marked successfully!',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorText = e.toString().replaceAll('Exception: ', '');

        // Parse specific errors
        IconData errorIcon;
        Color errorColor;
        String userFriendlyMessage;

        if (errorText.toLowerCase().contains('already marked')) {
          errorIcon = Icons.check_circle_outline;
          errorColor = Colors.orange;
          userFriendlyMessage = 'Attendance already marked for this session';
        } else if (errorText.toLowerCase().contains('too far')) {
          errorIcon = Icons.location_off;
          errorColor = Colors.red;
          userFriendlyMessage = 'You are too far from the classroom';
        } else if (errorText.toLowerCase().contains('token expired') ||
            errorText.toLowerCase().contains('session expired')) {
          errorIcon = Icons.timer_off;
          errorColor = Colors.red;
          userFriendlyMessage = 'QR code has expired. Ask teacher for new code';
        } else {
          errorIcon = Icons.error;
          errorColor = Colors.red;
          userFriendlyMessage =
              errorText.isEmpty ? 'Failed to mark attendance' : errorText;
        }

        setState(() {
          attendanceMarked = false;
          isProcessing = false;
          errorMessage = userFriendlyMessage;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(errorIcon, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    userFriendlyMessage,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: errorColor,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _resetScanner() {
    setState(() {
      isScanning = true;
      scannedData = null;
      attendanceMarked = false;
      scanTime = null;
      isProcessing = false;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: Stack(
        children: [
          // Camera View
          if (isScanning)
            MobileScanner(
              controller: cameraController,
              onDetect: _handleBarcode,
            )
          else
            Container(
              color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
            ),

          // Overlay with scanning frame
          if (isScanning) _buildScanningOverlay(isDarkMode),

          // Success View
          if (!isScanning && attendanceMarked) _buildSuccessView(isDarkMode),

          // Error View
          if (!isScanning && !attendanceMarked && errorMessage != null)
            _buildErrorView(isDarkMode),

          // Top Info Bar
          _buildTopBar(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isDarkMode) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final rollNumber = user?.rollNo ?? 'N/A';

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          bottom: 16,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey[900]!.withOpacity(0.9), Colors.transparent]
                : [Colors.white.withOpacity(0.9), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.blue[700],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QR Attendance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'Roll: $rollNumber',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isScanning)
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.blue[700],
                    ),
                    onPressed: _resetScanner,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningOverlay(bool isDarkMode) {
    return Stack(
      children: [
        // Dark overlay
        Container(
          color: Colors.black.withOpacity(0.5),
        ),

        // Scanning frame
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Corner decorations
                ...List.generate(4, (index) {
                  return Positioned(
                    top: index < 2 ? 0 : null,
                    bottom: index >= 2 ? 0 : null,
                    left: index % 2 == 0 ? 0 : null,
                    right: index % 2 != 0 ? 0 : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: index < 2
                              ? const BorderSide(color: Colors.blue, width: 4)
                              : BorderSide.none,
                          bottom: index >= 2
                              ? const BorderSide(color: Colors.blue, width: 4)
                              : BorderSide.none,
                          left: index % 2 == 0
                              ? const BorderSide(color: Colors.blue, width: 4)
                              : BorderSide.none,
                          right: index % 2 != 0
                              ? const BorderSide(color: Colors.blue, width: 4)
                              : BorderSide.none,
                        ),
                      ),
                    ),
                  );
                }),

                // Scanning line animation
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, double value, child) {
                    return Positioned(
                      top: value * 240 + 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.blue,
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  onEnd: () {
                    if (isScanning && mounted) {
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        // Instructions
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_2, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Align QR code within frame',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () {
                  cameraController.toggleTorch();
                },
                icon: const Icon(Icons.flash_on, color: Colors.white),
                label: const Text(
                  'Toggle Flash',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView(bool isDarkMode) {
    final timeFormat = DateFormat('h:mm a');
    final dateFormat = DateFormat('MMM dd, yyyy');
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final rollNumber = user?.rollNo ?? 'N/A';

    return Container(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success Animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          Text(
            'Attendance Marked!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.person,
                  'Roll Number',
                  rollNumber,
                  isDarkMode,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  Icons.access_time,
                  'Time',
                  scanTime != null ? timeFormat.format(scanTime!) : '--',
                  isDarkMode,
                ),
                const Divider(height: 24),
                _buildInfoRow(
                  Icons.calendar_today,
                  'Date',
                  scanTime != null ? dateFormat.format(scanTime!) : '--',
                  isDarkMode,
                ),
                if (scannedData != null) ...[
                  const Divider(height: 24),
                  _buildInfoRow(
                    Icons.qr_code,
                    'QR Data',
                    scannedData!.length > 20
                        ? '${scannedData!.substring(0, 20)}...'
                        : scannedData!,
                    isDarkMode,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: _resetScanner,
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue[700],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(bool isDarkMode) {
    // Determine icon and color based on error type
    IconData errorIcon = Icons.error;
    Color errorColor = Colors.red;
    String errorTitle = 'Attendance Failed';

    final errorLower = errorMessage?.toLowerCase() ?? '';
    if (errorLower.contains('already marked')) {
      errorIcon = Icons.check_circle_outline;
      errorColor = Colors.orange;
      errorTitle = 'Already Marked';
    } else if (errorLower.contains('too far')) {
      errorIcon = Icons.location_off;
      errorColor = Colors.red;
      errorTitle = 'Out of Range';
    } else if (errorLower.contains('expired')) {
      errorIcon = Icons.timer_off;
      errorColor = Colors.red;
      errorTitle = 'QR Code Expired';
    }

    return Container(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error Animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    errorIcon,
                    color: errorColor,
                    size: 80,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          Text(
            errorTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange[700],
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage ?? 'An error occurred',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: _resetScanner,
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MonitoringScreen extends StatefulWidget {
  @override
  _MonitoringScreenState createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  String _baseUrl = '192.168.18.93';
  String? _base64Image;
  String? _previousBase64Image;
  bool _isLoading = true;
  String _errorMessage = '';
  Timer? _frameTimer;

  @override
  void initState() {
    super.initState();
    _startFrameFetching();
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    super.dispose();
  }

  void _startFrameFetching() {
    _fetchLatestFrame();
    _frameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _fetchLatestFrame();
    });
  }

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  Future<void> _fetchLatestFrame() async {
    try {
      // final timestamp = DateTime.now().millisecondsSinceEpoch;
      final response = await http.get(
        Uri.parse('http:://$_baseUrl:5000/latest_frame'),
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache',
        },
      ).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String newBase64Image = data['image'];

        if (newBase64Image != _previousBase64Image) {
          setState(() {
            _base64Image = newBase64Image;
            _previousBase64Image = newBase64Image;
            _isLoading = false;
            _errorMessage = '';
          });
        }
      } else {
        _handleError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Connection error: $e');
    }
  }

  void _handleError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
      _base64Image = null;
    });
    print(message);
  }

  Future<void> _updateBaseUrl(BuildContext context) async {
    final TextEditingController urlController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Atur Ulang Base URL'),
          content: TextField(
            controller: urlController,
            decoration: InputDecoration(
              hintText: 'Masukkan URL baru',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                final String newUrl = urlController.text.trim();
                if (_isValidUrl(newUrl)) {
                  setState(() {
                    _baseUrl = newUrl;
                    _isLoading = true;
                  });
                  _startFrameFetching();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('URL tidak valid, silakan coba lagi.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageView() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _startFrameFetching();
            },
            child: Text('Refresh'),
          ),
        ],
      );
    }

    if (_base64Image == null) {
      return Text('No image available');
    }

    return Image.memory(
      base64Decode(_base64Image!),
      fit: BoxFit.cover,
      width: double.infinity,
      height: 300,
      errorBuilder: (context, error, stackTrace) {
        return Text('Failed to load image');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _updateBaseUrl(context),
          ),
        ],
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          _startFrameFetching();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Anda dapat memonitor kamera melalui layar ini dengan mudah dan secara real-time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      child: _buildImageView(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

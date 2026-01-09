import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/master_sheet_info.dart';
import '../models/sheet_version_info.dart';
import '../repository/event_validation_repository.dart';
import 'event_validation_results_screen.dart';

/// Dashboard screen for event validation
/// Allows users to sign in, select version, and start validation
class EventValidationDashboardScreen extends StatefulWidget {
  final String packageName;
  final EventValidationConfig? config;

  const EventValidationDashboardScreen({
    super.key,
    required this.packageName,
    this.config,
  });

  @override
  State<EventValidationDashboardScreen> createState() =>
      _EventValidationDashboardScreenState();
}

class _EventValidationDashboardScreenState
    extends State<EventValidationDashboardScreen> {
  final EventValidationRepository _repository = EventValidationRepository();
  
  bool _isLoading = false;
  bool _isSignedIn = false;
  String? _errorMessage;
  
  MasterSheetInfo? _sheetConfig;
  List<SheetVersionInfo> _versions = [];
  SheetVersionInfo? _selectedVersion;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  void _checkSignInStatus() {
    setState(() {
      _isSignedIn = _repository.isSignedIn;
    });
    
    if (_isSignedIn) {
      _loadSheetConfiguration();
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _repository.signIn();
      if (success) {
        setState(() {
          _isSignedIn = true;
        });
        await _loadSheetConfiguration();
      } else {
        setState(() {
          _errorMessage = 'Failed to sign in. Please try again.';
        });
      }
    } on PlatformException catch (e) {
      String errorMsg = 'Sign-in failed';
      
      // Handle specific error codes
      if (e.code == 'sign_in_failed') {
        if (e.message?.contains('10') == true) {
          errorMsg = 'Configuration Error (Code 10):\n\n'
              'Google Sign-In is not properly configured.\n\n'
              'Please check:\n'
              '• SHA-1 fingerprint added to Firebase Console\n'
              '• OAuth client ID configured correctly\n'
              '• Package name matches Firebase project\n'
              '• google-services.json file is present\n\n'
              'See GOOGLE_SIGN_IN_SETUP.md for detailed instructions.';
        } else {
          errorMsg = 'Sign-in failed: ${e.message ?? "Unknown error"}';
        }
      } else {
        errorMsg = 'Error: ${e.message ?? e.toString()}';
      }
      
      setState(() {
        _errorMessage = errorMsg;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    await _repository.signOut();
    setState(() {
      _isSignedIn = false;
      _sheetConfig = null;
      _versions = [];
      _selectedVersion = null;
    });
  }

  Future<void> _loadSheetConfiguration() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get master sheet info
      final masterSheets = await _repository.getMasterSheetInfo();
      
      // Find configuration for this package
      final config = _repository.findSheetForPackage(
        masterSheets: masterSheets,
        packageName: widget.packageName,
      );

      if (config == null) {
        setState(() {
          _errorMessage = 'No sheet configuration found for ${widget.packageName}';
        });
        return;
      }

      setState(() {
        _sheetConfig = config;
      });

      // Load versions
      await _loadVersions();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading configuration: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadVersions() async {
    if (_sheetConfig?.sheetId == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final versions = await _repository.getSheetVersions(
        sheetId: _sheetConfig!.sheetId!,
      );

      setState(() {
        _versions = versions;
        _selectedVersion = versions.isNotEmpty ? versions.first : null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading versions: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _startValidation() async {
    if (_sheetConfig == null || _selectedVersion == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get sheet event data
      final sheetEvents = await _repository.getSheetEventData(
        sheetId: _sheetConfig!.sheetId!,
        versionName: _selectedVersion!.title!,
        range: _sheetConfig!.range ?? '!A2:I',
      );

      // Validate events
      final validatedEvents = await _repository.validateEvents(
        sheetEvents: sheetEvents,
      );

      // Navigate to results screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventValidationResultsScreen(
              results: validatedEvents,
              versionName: _selectedVersion!.title!,
              config: widget.config,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error validating events: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = widget.config?.mainColor ?? Colors.blue;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Validation'),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        actions: [
          if (_isSignedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _signOut,
              tooltip: 'Sign Out',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_isSignedIn) {
      return _buildSignInView();
    }

    if (_errorMessage != null) {
      return _buildErrorView();
    }

    if (_sheetConfig == null) {
      return _buildNoConfigView();
    }

    return _buildValidationView();
  }

  Widget _buildSignInView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_outlined,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sign in to access Google Sheets for event validation',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _signIn,
              icon: const Icon(Icons.login),
              label: const Text('Sign In with Google'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadSheetConfiguration,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoConfigView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              'No configuration found for\n${widget.packageName}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please add your app configuration to the master sheet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 16),
          _buildVersionSelector(),
          const SizedBox(height: 24),
          _buildValidateButton(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildInfoRow('Package', widget.packageName),
            _buildInfoRow('Sheet ID', _sheetConfig?.sheetId ?? 'N/A'),
            _buildInfoRow('Range', _sheetConfig?.range ?? 'N/A'),
            if (_repository.currentUserEmail != null)
              _buildInfoRow('Signed in as', _repository.currentUserEmail!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionSelector() {
    if (_versions.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No versions available'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Version',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            DropdownButtonFormField<SheetVersionInfo>(
              initialValue: _selectedVersion,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _versions.map((version) {
                return DropdownMenuItem(
                  value: version,
                  child: Text(version.title ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVersion = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidateButton() {
    final canValidate = _selectedVersion != null && !_isLoading;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canValidate ? _startValidation : null,
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Validate Events'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

/// Placeholder for EventValidationConfig if not available
class EventValidationConfig {
  final Color? mainColor;
  
  const EventValidationConfig({this.mainColor});
}


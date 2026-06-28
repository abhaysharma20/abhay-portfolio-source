import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../services/firebase_service.dart';

class ContactProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  
  bool _isSending = false;
  bool get isSending => _isSending;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await prefs.setString('device_id', deviceId);
    }
    return deviceId;
  }

  Future<bool> _checkRateLimit() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    List<String> timestamps = prefs.getStringList('submission_timestamps') ?? [];

    timestamps = timestamps.where((t) {
      final dt = DateTime.parse(t);
      return now.difference(dt).inHours < 1;
    }).toList();

    if (timestamps.length >= 2) return false;

    timestamps.add(now.toIso8601String());
    await prefs.setStringList('submission_timestamps', timestamps);
    return true;
  }

  Future<void> submitForm(GlobalKey<FormState> formKey, BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _isSending = true;
    notifyListeners();

    try {
      final canSubmit = await _checkRateLimit();
      if (!canSubmit) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Rate Limit: Please wait an hour before sending another message."),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final deviceId = await _getDeviceId();
      await FirebaseService.instance.saveResponse(
        name: nameController.text,
        email: emailController.text,
        message: messageController.text,
        deviceId: deviceId,
      );

      nameController.clear();
      emailController.clear();
      messageController.clear();

      if (context.mounted) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Message sent successfully!",
              style: TextStyle(color: isDark ? Colors.black : Colors.white),
            ),
            backgroundColor: isDark ? const Color(0xFF00E5FF) : const Color(0xFF7C4DFF),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: Something went wrong. ${e.toString()}"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}

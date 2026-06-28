import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:abhay_portfolio/core/constants/api_end_points.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io' show Directory;

class JournalTagsListData {
  final String? sId;
  final String? name;

  JournalTagsListData({this.sId, this.name});
}

class JournalingProvider extends ChangeNotifier {
  Database? _db;
  bool isLoading = false;

  // Selected tag reactive fields
  final ValueNotifier<String> selectedTag = ValueNotifier<String>('Tags');
  final ValueNotifier<String> selectedTagVisible =
      ValueNotifier<String>('Tags');
  final ValueNotifier<int> selectedVisibilityId = ValueNotifier<int>(0);
  final ValueNotifier<String> selectedVisibility =
      ValueNotifier<String>('Public');
  final ValueNotifier<String> selectedThumbnailURL = ValueNotifier<String>('');

  // Password visibility for private/partially private journals
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isShowPassword = ValueNotifier<bool>(false);

  // Controllers
  final ValueNotifier<TextEditingController> journalTitleController =
      ValueNotifier<TextEditingController>(TextEditingController());
  final ValueNotifier<TextEditingController> passwordTextController =
      ValueNotifier<TextEditingController>(TextEditingController());
  late HtmlEditorController htmlEditorController;
  final ImagePicker picker = ImagePicker();

  final ValueNotifier<bool> isEditorLoaded = ValueNotifier<bool>(false);

  List<JournalTagsListData> journalTagsList = [
    JournalTagsListData(sId: "1", name: "Personal"),
    JournalTagsListData(sId: "2", name: "Work"),
    JournalTagsListData(sId: "3", name: "Idea"),
    JournalTagsListData(sId: "4", name: "Travel"),
  ];

  final List<dynamic> journalHistoryList = [];
  List<Map<String, dynamic>> savedJournals = [];

  JournalingProvider() {
    htmlEditorController = HtmlEditorController();
  }

  void update() {
    notifyListeners();
  }

  void setSelectedTag({required String tagName, required String tagID}) {
    selectedTag.value = tagID;
    selectedTagVisible.value = tagName;
    notifyListeners();
  }

  void setSelectedVisibility(String visibility) {
    selectedVisibility.value = visibility;
    notifyListeners();
  }

  void setSelectedVisibilityId(int id) {
    selectedVisibilityId.value = id;
    notifyListeners();
  }

  Future<void> _initDb() async {
    if (kIsWeb) return;
    final databasesPath = await getDatabasesPath();
    await Directory(databasesPath).create(recursive: true);
    final path = p.join(databasesPath, 'journaling.db');
    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS tags(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS journals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            thumbnail TEXT,
            visibility INTEGER,
            tag TEXT,
            date TEXT,
            password TEXT
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS journals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            thumbnail TEXT,
            visibility INTEGER,
            tag TEXT,
            date TEXT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<void> loadSavedJournals() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final rawJson = prefs.getString('saved_journals') ?? '[]';
        final List<dynamic> decoded = jsonDecode(rawJson);
        savedJournals =
            decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        if (_db == null) await _initDb();
        if (_db != null) {
          final List<Map<String, dynamic>> maps =
              await _db!.query('journals', orderBy: 'id DESC');
          savedJournals = List<Map<String, dynamic>>.from(maps);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading journals: $e");
    }
  }

  Future<void> deleteJournal(dynamic id) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final rawJson = prefs.getString('saved_journals') ?? '[]';
        final List<dynamic> decoded = jsonDecode(rawJson);
        final List<Map<String, dynamic>> currentList =
            decoded.map((e) => Map<String, dynamic>.from(e)).toList();

        currentList.removeWhere((element) => element['id'] == id);
        await prefs.setString('saved_journals', jsonEncode(currentList));
      } else {
        if (_db == null) await _initDb();
        if (_db != null) {
          await _db!.delete('journals', where: 'id = ?', whereArgs: [id]);
        }
      }
      await loadSavedJournals();
    } catch (e) {
      debugPrint("Error deleting journal: $e");
    }
  }

  Future<void> getJournalTagsList() async {
    // Keep local defaults, but try to fetch online or load from local DB
    notifyListeners();
  }

  Future<void> getJournalHistoryList({required String journalId}) async {
    // Dummy implementation
  }

  Future<dynamic> updateJournal(
      {required Map<String, dynamic> map, required String? journalID}) async {
    // Dummy implementation
    return null;
  }

  Future<void> saveAndPostJournalContent(BuildContext context,
      {required Map<String, dynamic> payload}) async {
    try {
      isLoading = true;
      notifyListeners();

      // 1. Save to local database (or SharedPreferences on Web)
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final rawJson = prefs.getString('saved_journals') ?? '[]';
        final List<dynamic> decoded = jsonDecode(rawJson);
        final List<Map<String, dynamic>> currentList =
            decoded.map((e) => Map<String, dynamic>.from(e)).toList();

        currentList.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch,
          'title': payload['title'],
          'description': payload['description'],
          'thumbnail': payload['thumbnail'],
          'visibility':
              int.tryParse(payload['visibility']?.toString() ?? '0') ?? 0,
          'tag': payload['tags'],
          'date': payload['date'],
          'password': payload['password'],
        });

        await prefs.setString('saved_journals', jsonEncode(currentList));
        debugPrint("Saved locally to SharedPreferences.");
      } else {
        if (_db == null) await _initDb();
        await _db!.insert('journals', {
          'title': payload['title'],
          'description': payload['description'],
          'thumbnail': payload['thumbnail'],
          'visibility':
              int.tryParse(payload['visibility']?.toString() ?? '0') ?? 0,
          'tag': payload['tags'],
          'date': payload['date'],
          'password': payload['password'],
        });
      }

      // 2. Try to post via Dio (remote API)
      try {
        await Dio().post(
          '${ApiEndPoints.baseUrl}/api/journal/create',
          data: payload,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      } catch (e) {
        debugPrint("Remote sync failed: $e. Saved locally.");
      }

      // Reload journals list
      await loadSavedJournals();

      isLoading = false;
      notifyListeners();

      // Show success feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Journal Saved Successfully to Local DB!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Clear title and description after save
        journalTitleController.value.text = "";
        htmlEditorController.setText("");
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error publishing journal: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save journal: $e"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<String?> uploadImageDio(XFile image) async {
    try {
      final fileName = image.name;
      FormData formData;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        formData = FormData.fromMap({
          'image': MultipartFile.fromBytes(bytes, filename: fileName),
        });
      } else {
        formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(image.path, filename: fileName),
        });
      }
      final response = await Dio().post(
        '${ApiEndPoints.baseUrl}/api/user/upload-image',
        data: formData,
      );
      if (response.statusCode == 200) {
        return response.data['imageUrl'] ?? response.data['url'];
      }
    } catch (e) {
      debugPrint("Image upload failed: $e");
    }
    return null;
  }
}

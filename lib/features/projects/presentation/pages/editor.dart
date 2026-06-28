import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:abhay_portfolio/providers/journaling_provider.dart';

class ReusableWidgets {
  static Widget customButton({
    double radius = 8,
    required String text,
    double textSize = 14,
    required Color buttonColor,
    required Color borderColor,
    double height = 45,
    double elevation = 0,
    required VoidCallback onPressed,
    double bottomPadding = 0,
    double? width,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: borderColor),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: textSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  static Widget customTextField({
    required String hintText,
    int maxLength = 100,
    EdgeInsets contentPadding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    FormFieldValidator<String>? validator,
    required TextEditingController controller,
    TextStyle? hintStyle,
    TextStyle? style,
    Widget? suffixIcon,
    bool isObscure = false,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLength: maxLength,
      obscureText: isObscure,
      onChanged: onChanged,
      style: style,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: contentPadding,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        counterText: "",
      ),
    );
  }

  static void showErrorSnackBar({
    required String title,
    required String message,
  }) {
    debugPrint("SnackBar Error: $title - $message");
  }
}

class CustomHTMLEditorScreen extends StatefulWidget {
  const CustomHTMLEditorScreen({
    super.key,
  });

  @override
  CustomHTMLEditorScreenState createState() => CustomHTMLEditorScreenState();
}

class CustomHTMLEditorScreenState extends State<CustomHTMLEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final journalController =
          Provider.of<JournalingProvider>(context, listen: false);
      journalController.getJournalTagsList();
      journalController.loadSavedJournals();

      // Reset values
      journalController.selectedTag.value = "Tags";
      journalController.selectedTagVisible.value = "Tags";
      journalController.journalTitleController.value.text = "";
      journalController.selectedThumbnailURL.value = "";
      journalController.selectedVisibilityId.value = 0;
      journalController.selectedVisibility.value = "Public";
      journalController.passwordTextController.value.text = "";
      journalController.isPasswordVisible.value = false;
      journalController.isShowPassword.value = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> insertHtmlSnippet(
      String snippet, HtmlEditorController htmlEditorController) async {
    String currentHtml = await htmlEditorController.getText();
    String newHtml = currentHtml + snippet;
    htmlEditorController.setText(newHtml);
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _showInsertMenu(HtmlEditorController htmlEditorController) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              context: context,
              icon: Icons.check_box,
              text: 'Insert Checkbox',
              onTap: () {
                FocusScope.of(context).unfocus();
                context.pop();
                insertHtmlSnippet(
                  '<label><input type="checkbox" /> Checkbox Title 1</label><br>',
                  htmlEditorController,
                );
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.radio_button_checked,
              text: 'Insert Radio Button',
              onTap: () {
                FocusScope.of(context).unfocus();
                context.pop();
                insertHtmlSnippet(
                  '<label><input type="radio" name="group1" /> Radio Title 1</label><br>',
                  htmlEditorController,
                );
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.text_snippet_sharp,
              text: 'Insert Text Area',
              onTap: () {
                FocusScope.of(context).unfocus();
                context.pop();
                insertHtmlSnippet(
                  '<textarea rows="4" cols="30"></textarea><br><br>',
                  htmlEditorController,
                );
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.short_text,
              text: 'Insert Input Field',
              onTap: () {
                FocusScope.of(context).unfocus();
                context.pop();
                insertHtmlSnippet(
                  '<input type="text" placeholder="Input Field" /><br>',
                  htmlEditorController,
                );
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Icons.videocam_outlined,
              text: 'Insert YouTube video',
              onTap: () {
                FocusScope.of(context).unfocus();
                context.pop();
                _promptForYoutubeVideo(htmlEditorController);
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  void _promptForYoutubeVideo(HtmlEditorController htmlEditorController) {
    final videoFormKey = GlobalKey<FormState>();
    String videoUrl = '';
    String aspectRatio = '16:9';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Insert YouTube Video'),
          content: Form(
            key: videoFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onChanged: (value) => videoUrl = value.trim(),
                  decoration: const InputDecoration(
                    labelText: 'YouTube URL',
                    hintText: 'https://www.youtube.com/watch?v=VIDEO_ID',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a YouTube URL';
                    }
                    final url = value.trim();
                    final isValid = Uri.tryParse(url)
                                ?.host
                                .contains('youtube.com') ==
                            true ||
                        Uri.tryParse(url)?.host.contains('youtu.be') == true;
                    if (!isValid) {
                      return 'Please enter a valid YouTube URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) => aspectRatio = value.trim(),
                  decoration: const InputDecoration(
                    labelText: 'Aspect Ratio',
                    hintText: 'e.g., 16:9 or 4:3',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (videoFormKey.currentState?.validate() != true) return;

                Navigator.pop(context);
                final videoId = _extractYoutubeVideoId(videoUrl);
                if (videoId != null) {
                  final embedUrl = 'https://www.youtube.com/embed/$videoId';

                  final parts = aspectRatio.split(':');
                  final width = double.tryParse(parts.first) ?? 16;
                  final height = double.tryParse(parts.last) ?? 9;
                  final ratioPercent = (height / width) * 100;

                  final iframeHtml = '''
<div style="position: relative; width: 100%; padding-bottom: ${ratioPercent.toStringAsFixed(2)}%;">
  <iframe 
    src="$embedUrl"
    style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen
    title="YouTube video player">
  </iframe>
</div><br>
''';

                  insertHtmlSnippet(iframeHtml, htmlEditorController);
                }
              },
              child: const Text('Insert'),
            ),
          ],
        );
      },
    );
  }

  String? _extractYoutubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.host.contains('youtube.com') && uri.path == '/watch') {
      return uri.queryParameters['v'];
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    } else {
      return null;
    }
  }

  Future<void> _uploadAndInsertImage(HtmlEditorController htmlEditorController,
      JournalingProvider journalController) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageUrl = await journalController.uploadImageDio(image);
      if (imageUrl != null) {
        htmlEditorController.insertHtml(
          '<img src="$imageUrl" alt="uploaded image" style="max-width:25%; height:auto;" />',
        );
      } else {
        debugPrint('Image upload returned null URL');
      }
    }
  }

  void applyBlurStyling(HtmlEditorController controller) {
    controller.editorController?.evaluateJavascript(
      source: """
    (function() {
      var style = document.createElement('style');
      style.innerHTML = `
        blurred {
          filter: blur(6px);
          background: rgba(200,200,200,0.3);
          padding: 2px 6px;
          border-radius: 4px;
          cursor: pointer;
          display: inline-block;
        }
      `;
      document.head.appendChild(style);
    })();
  """,
    );
  }

  String _stripHtml(String htmlString) {
    final regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(regExp, '');
  }

  @override
  Widget build(BuildContext context) {
    final journalController = Provider.of<JournalingProvider>(context);

    return SafeArea(
      bottom: false,
      top: false,
      left: true,
      right: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lightweight Header Row with Back/Close button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Create Journal",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title Input Field
                  ValueListenableBuilder<TextEditingController>(
                    valueListenable: journalController.journalTitleController,
                    builder: (context, titleController, _) {
                      return TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Title is required";
                          }
                          return null;
                        },
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: "Title",
                          hintStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // HTML Editor
                  Container(
                    height: 380,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: HtmlEditor(
                      controller: journalController.htmlEditorController,
                      htmlEditorOptions: const HtmlEditorOptions(
                        spellCheck: true,
                        autoAdjustHeight: false,
                        inputType: HtmlInputType.text,
                        hint: 'Write your thoughts here...',
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.belowEditor,
                        toolbarItemHeight: 36,
                        toolbarType: ToolbarType.nativeScrollable,
                        buttonColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                        buttonSelectedColor: Theme.of(context).primaryColor,
                        buttonBorderRadius: BorderRadius.circular(6),
                        customToolbarButtons: [
                          IconButton(
                            icon: const Icon(Icons.add_box_outlined),
                            tooltip: 'Insert Custom Snippets',
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              _showInsertMenu(
                                  journalController.htmlEditorController);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.image_outlined),
                            tooltip: 'Insert Gallery Image',
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              _uploadAndInsertImage(
                                  journalController.htmlEditorController,
                                  journalController);
                            },
                          ),
                        ],
                      ),
                      callbacks: Callbacks(
                        onInit: () {
                          applyBlurStyling(
                              journalController.htmlEditorController);
                        },
                        onFocus: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onChangeContent: (content) {
                          // Stub to avoid Unexpected null value crash on web
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Save to DB Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final contentHtml = await journalController
                            .htmlEditorController
                            .getText();
                        if (!context.mounted) return;
                        if (contentHtml.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Journal content cannot be empty")),
                          );
                          return;
                        }

                        final payload = {
                          "date": DateTime.now().toIso8601String(),
                          "visibility": 0, // Default to Public
                          "password": "",
                          "status": "published",
                          "tags": "General", // Default tag
                          "thumbnail": "",
                          "title": journalController
                              .journalTitleController.value.text,
                          "description": contentHtml,
                        };
                        await journalController.saveAndPostJournalContent(
                            context,
                            payload: payload);
                      }
                    },
                    icon: const Icon(Icons.save_rounded, color: Colors.white),
                    label: const Text(
                      "Save to Local DB",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),

                  Text(
                    "Saved Journals",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  // Saved Journals List
                  journalController.savedJournals.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: Text(
                              "No saved journals found in Local DB.",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: journalController.savedJournals.length,
                          itemBuilder: (context, index) {
                            final journal =
                                journalController.savedJournals[index];
                            final id = journal['id'];
                            final title = journal['title'] ?? 'Untitled';
                            final description = journal['description'] ?? '';
                            final previewText = _stripHtml(description);
                            final date = journal['date'] ?? '';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              elevation: 0,
                              color: Theme.of(context).cardColor,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Text(
                                  title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      date.isNotEmpty && date.contains('T')
                                          ? date.split('T').first
                                          : date,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      previewText,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Delete Journal"),
                                          content: const Text(
                                              "Are you sure you want to delete this journal entry?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await journalController
                                                    .deleteJournal(id);
                                              },
                                              child: const Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

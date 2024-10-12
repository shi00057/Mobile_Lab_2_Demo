import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DocumentUploader(),
    );
  }
}

class DocumentUploader extends StatefulWidget {
  @override
  _DocumentUploaderState createState() => _DocumentUploaderState();
}

class _DocumentUploaderState extends State<DocumentUploader> {
  String? document1Path;
  String? document2Path;
  TextEditingController _textController = TextEditingController();
  List<String> items = [];

  Future<void> pickDocument(int documentNumber) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        if (documentNumber == 1) {
          document1Path = result.files.single.path;
        } else if (documentNumber == 2) {
          document2Path = result.files.single.path;
        }
      });
    }
  }

  void addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        items.add(_textController.text);
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: addItem,
                  child: Text('Add'),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter a search term',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index:'),
                    trailing: Text(items[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => pickDocument(1),
              child: Text(document1Path == null ? 'Upload Lab_work.pdf' : 'Lab_work.pdf Uploaded'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => pickDocument(2),
              child: Text(document2Path == null ? 'Upload ListView.pdf' : 'ListView.pdf Uploaded'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: document1Path != null && document2Path != null
                  ? () {
                // Handle document submission logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Documents uploaded successfully!'),
                  ),
                );
              }
                  : null,
              child: Text('Submit Documents'),
            ),
          ],
        ),
      ),
    );
  }
}

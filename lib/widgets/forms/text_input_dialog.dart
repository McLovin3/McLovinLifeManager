import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final Function onSubmit;
  final int maxLines;

  const TextInputDialog(
      {required this.title,
      super.key,
      required this.maxLines,
      required this.hintText,
      required this.onSubmit});

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(child: Text(widget.title)),
      contentPadding: const EdgeInsets.all(15),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const Key("text"),
                maxLines: widget.maxLines,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                ),
                controller: _textController,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please fill in this field";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onSubmit(_textController.text);
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

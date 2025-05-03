import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  final String title;
  final String entryLabel;
  final Future<void> Function() future;

  const InputScreen({
    super.key,
    required this.title,
    required this.entryLabel,
    required this.future,
  });

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _key = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300, maxWidth: 300),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.entryLabel),
                        TextFormField(
                          controller: _textController,
                          validator: (value) {
                            if (value == null) {
                              return 'Entre com um valor válido';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            widget.future;
                          }
                        },
                        child: const Text('enviar')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final editorProvider = StateNotifierProvider((_) => TextEditor());

class TextEditor extends StateNotifier<String> {
  TextEditor() : super('');
  void onEdit(String str) => state = str;
  void toUpperCase() => state = state.toUpperCase();
  void toLowerCase() => state = state.toLowerCase();
}

class EditTextPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(editorProvider.state);
    final editor = useProvider(editorProvider);
    final controller = TextEditingController(text: state);
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditTextPage'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(state),
            TextField(
              controller: controller,
              onChanged: editor.onEdit,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.more_vert),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return Column(
                children: [
                  ListTile(
                    title: const Text('To Upper Case'),
                    onTap: editor.toUpperCase,
                  ),
                  ListTile(
                    title: const Text('To Lower Case'),
                    onTap: editor.toLowerCase,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

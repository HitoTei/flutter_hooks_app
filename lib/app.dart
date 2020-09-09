import 'package:flutter/material.dart';
import 'package:flutter_hooks_app/pages/edit_text_page.dart';
import 'package:flutter_hooks_app/pages/increment_page.dart';
import 'package:flutter_hooks_app/pages/list_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice Flutter Hooks',
      theme: ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        '/increment': (_) => IncrementPage(),
        '/edit_text': (_) => ProviderScope(
              child: EditTextPage(),
            ),
        '/list': (_) => ProviderScope(
              child: ListPage(),
            ),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Flutter Hooks'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('increment page'),
            onTap: () => Navigator.pushNamed(context, '/increment'),
          ),
          ListTile(
            title: const Text('edit text page'),
            onTap: () => Navigator.pushNamed(context, '/edit_text'),
          ),
          ListTile(
            title: const Text('list page'),
            onTap: () => Navigator.pushNamed(context, '/list'),
          )
        ],
      ),
    );
  }
}

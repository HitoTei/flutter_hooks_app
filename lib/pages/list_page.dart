import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final counterProvider = StateNotifierProvider((_) => Counter());

class Counter extends StateNotifier<List<int>> {
  Counter() : super([]);
  var _max = 0;
  void add() {
    state.add(_max++);
    state = state;
  }

  void remove(index) {
    state.removeAt(index);
    state = state;
  }
}

class ListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(counterProvider.state);
    final counter = useProvider(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ListPage length: ${state.length}'),
      ),
      body: ListView.separated(
        itemCount: state.length,
        itemBuilder: (_, index) => Dismissible(
          key: UniqueKey(),
          child: ListTile(
            title: Text(state[index].toString()),
          ),
          onDismissed: (_) => counter.remove(index),
        ),
        separatorBuilder: (_, index) => const Divider(
          height: 0,
          color: Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: counter.add,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final itemList = StateProvider.autoDispose<List<int>>((_) => []);
final addedItemCount = StateProvider((_) => 0);
final order = StateProvider((ref) => true);
final sortedItemList = StateProvider.autoDispose<List<int>>((ref) {
  final isAsc = ref.watch(order).state;
  final list = ref.watch(itemList).state;

  if (list != null) {
    if (isAsc)
      list.sort((a, b) => a - b);
    else
      list.sort((a, b) => b - a);
  }
  return list;
});

final itemViewController =
    Provider.autoDispose((ref) => ItemViewController(ref.read));

class ItemViewController {
  ItemViewController(this.read);
  final Reader read;
  void dispose() {
    read(addedItemCount).state = 0;
    read(itemList).state.clear();
  }

  void add() {
    final list = read(itemList).state;
    final count = read(addedItemCount).state + 1;
    list.add(count);
    read(itemList).state = list;
    read(addedItemCount).state = count;
  }

  void addItem(int item) {
    final list = read(itemList).state;
    list.add(item);
    read(itemList).state = list;
  }

  void removeAt(int index) {
    final list = read(itemList).state;
    list.removeAt(index);
    read(itemList).state = list;
  }

  void changeSortOrder() => read(order).state = !read(order).state;
}

class ListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      return context.read(itemViewController).dispose;
    }, []);

    final state = useProvider(sortedItemList).state;
    return Scaffold(
      appBar: AppBar(
        title: Text('ListPage length: ${state?.length}'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: context.read(itemViewController).changeSortOrder,
          ),
        ],
      ),
      body: (state != null)
          ? ListView.separated(
              itemCount: state.length,
              itemBuilder: (_, index) => Dismissible(
                key: UniqueKey(),
                child: ItemListTile(index, context.read(itemViewController)),
                onDismissed: (_) {
                  context.read(itemViewController).removeAt(index);
                },
              ),
              separatorBuilder: (_, index) => const Divider(
                height: 0,
                color: Colors.black,
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: context.read(itemViewController).add,
      ),
    );
  }
}

class ItemListTile extends HookWidget {
  ItemListTile(this.index, this.controller);
  final int index;
  final ItemViewController controller;
  @override
  Widget build(BuildContext context) {
    final state = useProvider(sortedItemList).state;
    return Dismissible(
      key: UniqueKey(),
      child: ListTile(
        title: Text(state[index].toString()),
      ),
      onDismissed: (_) async {
        final item = state[index];
        controller.removeAt(index);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: const Text('削除しました'),
            action: SnackBarAction(
              label: '元に戻す',
              onPressed: () => controller.addItem(item),
            ),
          ),
        );
      },
    );
  }
}

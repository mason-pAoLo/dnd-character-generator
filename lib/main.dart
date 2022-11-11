// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Item To Add'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _inputController,
                decoration:
                    const InputDecoration(hintText: "type something here"),
              ),
              actions: <Widget>[
                ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _inputController,
                    builder: (context, value, child) {
                      return ElevatedButton(
                        key: const Key("OkButton"),
                        style: yesStyle,
                        onPressed: value.text.isNotEmpty
                            ? () {
                                setState(() {
                                  _handleNewItem(valueText);
                                  Navigator.pop(context);
                                });
                              }
                            : null,
                        child: const Text('OK'),
                      );
                    }),

                // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
                ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    child: const Text('Cancel'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    })
              ]);
        });
  }

  String valueText = "";

  List<Item> items = [const Item(name: "test")];
  final _unmarkedItems = <Item>{const Item(name: "test")};
  final _completedItems = <Item>{};
  final _favoritedItems = <Item>{};

  @override
  void initState() {
    super.initState();
  }

  void _handleListChanged(
      Item item, bool completed, bool favorited, String action) {
    setState(() {
      List<Item> newItemList = [];
      _unmarkedItems.remove(item);

      if (action == "completed") {
        if (!completed) {
          _completedItems.add(item);
          _unmarkedItems.remove(item);
        } else {
          _completedItems.remove(item);
          _unmarkedItems.add(item);
        }
        if (favorited) {
          _favoritedItems.remove(item);
        }
      }

      if (action == "favorited") {
        if (!completed) {
          if (!favorited) {
            _favoritedItems.add(item);
            _unmarkedItems.remove(item);
          } else {
            _favoritedItems.remove(item);
            _unmarkedItems.add(item);
          }
        }
      }

      newItemList.addAll(_favoritedItems);
      newItemList.addAll(_unmarkedItems);
      newItemList.addAll(_completedItems);

      items = newItemList;
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      //print("Deleting item");
      items.remove(item);
      _completedItems.remove(item);
    });
  }

  void _handleNewItem(String itemText) {
    setState(() {
      //print("Adding new item");
      Item item = Item(name: itemText);
      items.add(item);
      _unmarkedItems.add(item);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _completedItems.contains(item),
              favorited: _favoritedItems.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_item.dart';

class DatabaseService {

  final databaseReference = Firestore.instance;

  void addNewTodoItem(text, currentUser) async {
    await databaseReference.collection("users").document(currentUser.email).collection("items")
        .add({
          'text': text,
          "isDone": false
        });
  }

  void deleteTodoItem(todoItem, currentUser) async {
    try {
      await databaseReference.collection("users").document(currentUser.email).collection("items")
        .document(todoItem.id)
          .delete();
    } 
    catch (e) {
      print(e.toString());
    }
  }

  void toogleTodoItemIsDone(todoItem, currentUser) async {
    try {
      await databaseReference.collection("users").document(currentUser.email).collection("items")
        .document(todoItem.id)
          .updateData({
          'text': todoItem.text,
          "isDone": !todoItem.isDone
        });
    } 
    catch (e) {
      print(e.toString());
    }
  }

  void subscribeOnTodoItems(currentUser, callback) async {
    List<TodoItem> _todoItems = [];
    databaseReference
        .collection("users").document(currentUser.email).collection("items").getDocuments()
        .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) => {
            _todoItems.add(new TodoItem(f.documentID, f.data["text"], f.data["isDone"]))
          });
          callback(_todoItems);
      });
  }
}


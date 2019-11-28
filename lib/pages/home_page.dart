import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter/material.dart';
import "../services/database_service.dart";
import '../services/auth_service.dart';
import '../models/todo_item.dart';


class HomePage extends StatefulWidget {
  final AuthService auth;

  HomePage({Key key, @required this.auth}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService db = new DatabaseService();
  List<TodoItem> _todoItems = [];
  double percent = 0.0;

  @override
  Widget build(BuildContext context) {
    db.subscribeOnTodoItems(widget.auth.currentUser, (result) => {
      this.setState(() => {
        this._todoItems = result,
        updateProgressBar()
      }),
    });

    return Scaffold(

      // navbar
      appBar: AppBar(
        title: Text('Todo List'),
        actions: <Widget>[
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(
                widget.auth.currentUser.photoUrl,
              ),
              radius: 60,
              backgroundColor: Colors.transparent,
            ),
            onPressed: () => {}
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
                PopupMenuItem(
                  value: "Logout",
                  child: Text("Logout"),
                ),
              ],
              onSelected: (value) {
                Navigator.of(context).pushReplacementNamed('/login');
              },
          ),
        ],
      ),
      
      body: Column(children: <Widget>[

        // progress bar
        RoundedProgressBar(
          childCenter: Text("$percent%",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )
          ),
          borderRadius: BorderRadius.circular(24),
          theme: RoundedProgressBarTheme.blue, 
          height: 40,
          percent: percent,
        ),

        // todo list
        Expanded(child: _buildTodoList()),
      ]),

      // add button
      floatingActionButton: new FloatingActionButton(
        onPressed: _navigateToAddNewItemPage,
        tooltip: 'Add task',
        child: new Icon(Icons.add)
      ),
    );
  }

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if(index < _todoItems.length) {

          // list row
          var todoItem = _todoItems[index];
          var rowColor = todoItem.isDone ? Colors.green[100] : null;
          var doneIcon = todoItem.isDone ? Icons.undo : Icons.done;
          
          return new Container (
            decoration: new BoxDecoration (
                color: rowColor
            ),

            child: new ListTile(
              title: new Text(todoItem.text),
              trailing: Row(    
                mainAxisSize: MainAxisSize.min,      
                children: <Widget>[

                  // Done Icon
                  IconButton(
                    icon: new Icon(
                        doneIcon,
                        color: Colors.green,
                      ), 
                    onPressed: () { 
                      db.toogleTodoItemIsDone(todoItem, widget.auth.currentUser);
                    },
                  ),

                  // Delete Icon
                  IconButton(
                    icon: new Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),  
                    onPressed: () { 
                      db.deleteTodoItem(todoItem, widget.auth.currentUser);
                    },
                  ),
              ]),
            
            
          )
        );
        }
      },
    );
  }

  void _navigateToAddNewItemPage() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Add a New Task')
            ),
            body: new TextField(
              autofocus: true,
              onSubmitted: (text) {
                if(text.length > 0) {
                  db.addNewTodoItem(text, widget.auth.currentUser);
                }
                Navigator.pop(context); // Navigate back after submit
              },
              decoration: new InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)
              ),
            )
          );
        }
      )
    );
  }

  void updateProgressBar() {
    var nrOfDoneItems = 0;
      this.setState(() => {
        _todoItems.forEach((todoItem) => {
          if(todoItem.isDone) {
            nrOfDoneItems++
          }
        }),
        if(nrOfDoneItems > 0) {
          percent = double.parse((nrOfDoneItems / _todoItems.length * 100).toStringAsFixed(2))
        }
        else {
          percent = 0
        }
      });
  }
}


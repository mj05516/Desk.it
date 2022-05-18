// import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskit/helpers/database_helper.dart';
import 'package:taskit/models/task_model.dart';
import 'package:taskit/screens/add_task_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Future<List<Task>>? _taskList;
  late String filter = "All";
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy hh:mm');
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('ToDo').snapshots();
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _updateTaskList("All");
    // add 5 seconds delay to simulate network call
    // Future.delayed(Duration(seconds: 5), () {
    //   _updateTaskList("All");
    // });
  }

  _updateTaskList(String filter) {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList(filter);
    });
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          SizedBox(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snapshot) {
                _count = snapshot.data!.docs.length;
                return ListView.builder(
                  itemCount: _count,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> document = snapshot.data?.docs[index]
                        .data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                        document['Title'],
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            decoration: document['status'] == 0
                                ? TextDecoration.none
                                : TextDecoration.lineThrough),
                      ),
                      subtitle: Text(
                        // convert type Timestamp to DateTime
                        '${_dateFormatter.format(document['Date'].toDate())} * ${document['Priority']}',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            decoration: document['status'] == 0
                                ? TextDecoration.none
                                : TextDecoration.lineThrough),
                      ),
                      trailing: Checkbox(
                        onChanged: (value) {
                          document['status'] = value! ? 1 : 0;
                          // DatabaseHelper.instance.updateTask(task);
                          // _updateTaskList("All");
                        },
                        activeColor: Theme.of(context).primaryColor,
                        value: document['status'] == 1 ? true : false,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTaskScreen(
                              updateTaskList: _updateTaskList, task: task),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DESK.It',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            )),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(updateTaskList: _updateTaskList),
            ),
          )
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final int? completedTaskCount = (snapshot.data as List<Task>)
              .where((Task task) => task.status == 1)
              .toList()
              .length;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 60.0),
            itemCount: 1 + (snapshot.data as List<Task>).length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your ToDos',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                              onPressed: () {
                                _updateTaskList("All");
                              },
                              child: Text(
                                'All',
                                style: TextStyle(color: Colors.deepPurple),
                              )),
                          MaterialButton(
                            onPressed: () {
                              _updateTaskList("Active");
                            },
                            child: Text(
                              'Active',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                          MaterialButton(
                              onPressed: () {
                                _updateTaskList("Completed");
                              },
                              child: Text(
                                'Completed',
                                style: TextStyle(color: Colors.deepPurple),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '$completedTaskCount of $_count tasks have been completed',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                );
              }
              return _buildTask((snapshot.data as List<Task>)[index - 1]);
            },
          );
        },
      ),
    );
  }
}

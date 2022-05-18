import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskit/helpers/database_helper.dart';
import 'package:taskit/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Function? updateTaskList;
  final Task? task;

  AddTaskScreen({this.updateTaskList, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _title = "";
  String? _priority = "Low";
  DateTime? _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy hh:mm');
  final List<String> _priorities = ["Low", "Medium", "High"];

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date!,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      // _dateController.text = _dateFormatter.format(date);
    }
    // ask for time
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _date!.hour, minute: _date!.minute)
    );
    if (time != null) {
      setState(() {
        _date = DateTime(_date!.year, _date!.month, _date!.day, time.hour,
            time.minute);
      });
      _dateController.text = _dateFormatter.format(_date!);
    }
    
  }

  _submit() {
    print("object");
    FirebaseFirestore.instance.collection('ToDo').add({
      'title': _title,
      'priority': _priority,
      'date': _date,
      'status': 0,
    });
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    //   print('$_title, $_priority, $_date');

    //   // Insert Task to Users Database
    //   Task task = Task(title: _title, date: _date, priority: _priority);
    //   if (widget.task == null) {
    //     task.status = 0;
    //     DatabaseHelper.instance.insertTask(task);
    //   } else {
    //     // Update Task to Users Database
    //     task.id = widget.task!.id;
    //     task.status = widget.task!.status;
    //     DatabaseHelper.instance.updateTask(task);
    //   }

    //   widget.updateTaskList!("All");
    //   Navigator.pop(context);
    // }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task!.id);
    widget.updateTaskList!("All");
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = _dateFormatter.format(_date!);

    if (widget.task != null) {
      _title = widget.task!.title;
      _priority = widget.task!.priority;
      _date = widget.task!.date;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  widget.task == null ? 'Add Your To Do' : 'Update Your To Do',
                  style: TextStyle(
                      fontFamily: 'ProximaNova',
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 40.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Task',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProximaNova',
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (input) => input!.trim().isEmpty
                              ? 'Please Enter a Task Title'
                              : null,
                          onSaved: (input) => _title = input,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: TextStyle(fontSize: 18),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProximaNova',
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22.0,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Priority',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: 'ProximaNova',
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          validator: (dynamic input) =>
                              input.toString().trim().isEmpty
                                  ? 'Please Select a Priority Level'
                                  : null,
                          // onSaved: (input) => _priority = input.toString(),
                          items: _priorities.map((String priority) {
                            return DropdownMenuItem(
                                value: priority,
                                child: new Text(
                                  priority,
                                  style: TextStyle(
                                      fontFamily: 'ProximaNova',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0),
                                ));
                          }).toList(),
                          onChanged: (dynamic newValue) {
                            print(newValue.runtimeType);
                            setState(() {
                              _priority = newValue.toString();
                            });
                          },
                          // value : _priority
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: TextButton(
                          onPressed: () => {
                            print("Add Task"),
                            FirebaseFirestore.instance.collection('ToDo').add({
                              'title': _title,
                              'priority': _priority,
                              'date': _date,
                              'status': 0,
                            })
                          },
                          child: Text(
                            widget.task == null ? 'Add' : 'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'ProximaNova',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      widget.task != null
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 20.0),
                              height: 60.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: TextButton(
                                onPressed: _delete,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'ProximaNova',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

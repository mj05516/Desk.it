import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskit/helpers/database_helper.dart';
import 'package:taskit/models/task_model.dart';
import 'package:taskit/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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
  String? _category = "Personal";
  DateTime? _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy hh:mm a');
  final List<String> _priorities = ["Low", "Medium", "High"];
  final List<String> _categories = ["Work", "Personal", "Miscellaneous"];

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
        initialTime: TimeOfDay(hour: _date!.hour, minute: _date!.minute));
    if (time != null) {
      setState(() {
        _date = DateTime(
            _date!.year, _date!.month, _date!.day, time.hour, time.minute);
      });
      _dateController.text = _dateFormatter.format(_date!);
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_priority, $_date, $_category');

      // Insert Task to Users Database
      Task task = Task(
          title: _title, date: _date, priority: _priority, category: _category);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        // Update Task to Users Database
        task.id = widget.task!.id;
        task.status = widget.task!.status;
        DatabaseHelper.instance.updateTask(task);
      }
      // var zone = tz.getLocation('Africa/Algiers');
      tz.TZDateTime tzDateTime = tz.TZDateTime.from(
        _date!,
        tz.getLocation('Asia/Karachi'),
      );
      // get current time in seconds
      double now = DateTime.now().millisecondsSinceEpoch / 1000;
      // get time in seconds
      double rem = _date!.millisecondsSinceEpoch / 1000 - now;
      // convert rem to int
      int remInt = rem.toInt();

      // NotificationService().showNotification(1, _title!, _category!, 60);
      NotificationService().showNotification(1, _title!, _category!, remInt);
      widget.updateTaskList!("All");
      Navigator.pop(context);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task!.id);
    widget.updateTaskList!("All");
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
    _dateController.text = _dateFormatter.format(_date!);

    if (widget.task != null) {
      _title = widget.task!.title;
      _priority = widget.task!.priority;
      _category = widget.task!.category;
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
                                      color: Colors.white,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22.0,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              labelText: 'Category',
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
                                  ? 'Please Select a Category'
                                  : null,
                          // onSaved: (input) => _priority = input.toString(),
                          items: _categories.map((String category) {
                            return DropdownMenuItem(
                                value: category,
                                child: new Text(
                                  category,
                                  style: TextStyle(
                                      fontFamily: 'ProximaNova',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.0),
                                ));
                          }).toList(),
                          onChanged: (dynamic newValue) {
                            print(newValue.runtimeType);
                            setState(() {
                              _category = newValue.toString();
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
                          onPressed: _submit,
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

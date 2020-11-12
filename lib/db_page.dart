import 'package:flutter/material.dart';
import 'employee.dart';
import 'dart:async';
import 'db_helper.dart';

class DBTestPage extends StatefulWidget {
  final String title;
  DBTestPage({Key key, this.title}) : super(key:key);

  @override
  State<StatefulWidget> createState(){
    return _DBTestPageState();
  }

}

class _DBTestPageState extends State<DBTestPage> {

  Future<List<Employee>> employees;
  TextEditingController controller = TextEditingController();
  String name;
  int curuserid;
  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool isupdating;

  @override
  void initState(){
    super.initState();
    dbHelper = DBHelper();
    isupdating=false;
    refreshlist();
  }

  refreshlist(){
    setState((){
      employees = dbHelper.getEmployees();
    });
  }

  clearName(){
    controller.text = '';
  }

  validate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isupdating) {
        Employee e = Employee(curuserid, name);
        dbHelper.update(e);
        setState(() {
          isupdating = false;
        });

      } else {
        Employee e = Employee(null, name);
        dbHelper.save(e);
      }
      clearName();
      refreshlist();
    }
  }
  form(){
    return Form(
      key:formkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller : controller,
              keyboardType: TextInputType.text,
              cursorColor: Colors.deepOrangeAccent[200],
              decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(
                color: Colors.deepOrangeAccent[200],
                letterSpacing: 2.0,
                fontSize: 16,
              )),
              validator: (val) => val.length == 0? 'Enter Name': null,
              onSaved: (val) => name =val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                FlatButton(
                  onPressed: validate,
                  child:Text(isupdating ? 'Update' : 'Add'),
                ),
                FlatButton(
                  onPressed: (){
                    setState((){
                      isupdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                ),
              ],
            )
          ],
        ),
      ),
    );

  }

 SingleChildScrollView dataTable(List<Employee> employees){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('NAME')),
          DataColumn(label: Text('DELETE')),
        ],
        rows: employees.map((employee) => DataRow(
          cells: [
            DataCell(
              Text(employee.name),
              onTap: (){
              setState((){
                isupdating = true;
                curuserid = employee.id;
              });
              controller.text = employee.name;
              },
            ),
            DataCell(
              IconButton(
                icon:Icon(Icons.delete),
                onPressed: (){
                  dbHelper.delete(employee.id);
                  refreshlist();
                }
              )
            ),
          ]
        ),).toList(),)
      );
  }

list() {

  return Expanded(
    child: FutureBuilder(
      future: employees,
      builder: (context, snapshot){
      if(snapshot.hasData){
        return dataTable(snapshot.data);
      }
      if(null == snapshot.data || snapshot.data.length == 0){
        return Text("No data found");
      }
      return CircularProgressIndicator();
      }

    )
  );
}


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.deepOrangeAccent[200],
        title: new Text("Employee DataBase"),
      ),

      body: new Container(

        child:new Column(
        mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            form(),
            list(),

          ],
        ),

      ),


    );
  }
}

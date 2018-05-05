
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'listtimes.dart';
import '../databases/todos.dart';
class Homepage extends StatefulWidget{
  @override
State createState() => new Homepages();
}

class Homepages extends State<Homepage> {
  String Greating = " ";
  String en=  "Tap to start!";
  String ar= "!اضغط لي تبدا";
  TodoProvider _db = new TodoProvider();
  int number;
  @override
     void initState() {
       super.initState();
       createdb();
     }
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.lightGreen,
      child: new InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ListGrocery())),
        child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Container(child: new CircleAvatar(radius: 100.0,child: new Icon(Icons.shopping_cart,size: 80.0,
            color: Colors.lightGreen,),backgroundColor:Colors.blueAccent,)),
            new Row(mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
            new RaisedButton(color: Colors.blueAccent,onPressed:(){lang('ar_SA');},child: new Text("عربي"),),
            new RaisedButton(color: Colors.blueAccent,onPressed:(){lang ('en_US');},child:new Text("English"),),]),
            new Text(Greating , style: new TextStyle(color: Colors.black, fontSize: 60.0, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
  lang(String lang) async {

    setState(() {
      if (lang =='ar_SA' ) {
        Greating = ar;
        Intl.defaultLocale = 'ar_SA';
      }
      else {
        Greating = en;
      Intl.defaultLocale = 'en_US';}
    });
  }
  List listCategory;
  createdb() async {
    await _db.open().then(
            (data) {
          _db.countCategory().then((list) {
            number = list[0][0]['COUNT(*)']; //3
            listCategory = list[1];
          });
        }
    );
  }
}

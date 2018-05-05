import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../databases/todos.dart';
import '../pages/listtimes.dart';

class itemDetail extends StatefulWidget{
  @override
  State createState() => new ItemDetails();
}
class ItemDetails extends State<itemDetail> {
  @override
  Widget build(BuildContext context) {
    var filesaved;
    filesaved = new File("/storage/emulated/0/Grcerylist/" +TodoProvider.list[itemNumber]['title']+ TodoProvider.list[itemNumber]['quantity'].toString()+ "image.png");
    String image = TodoProvider.list[itemNumber]['picture'];
    var bs =BASE64.decode(image);
    filesaved.writeAsBytesSync(bs);
    return new Scaffold(
      appBar: new AppBar(title: new Text(Intl.defaultLocale == 'ar_SA'?"الغرض":"Item"), centerTitle: true,),
      body: new Column(
        children: <Widget>[
          new Text((Intl.defaultLocale == 'ar_SA'?"الغرض: ":"Item: ")+TodoProvider.list[itemNumber]['title'],style:(
              new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.black))),
          new Text((Intl.defaultLocale == 'ar_SA'?"المقياس: " : "Quntity: ")+TodoProvider.list[itemNumber]['quantity'].toString() + " " +   TodoProvider.list[itemNumber]['type'], style:(
              new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(1.0),wordSpacing: 5.0 ))),
          new Expanded(child:
          new Center(child:image == "null"
              ? new Text(Intl.defaultLocale == 'ar_SA'?"لا يوجد صوره مضافه":'No image added.')
              : new Image.file(filesaved, width: 500.0,height: 500.0,))
          )
        ]
      ),
    );
  }
}

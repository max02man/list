import 'dart:convert';
import 'dart:io';
import 'listtimes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class outsideList extends StatefulWidget{
  @override
  State createState() => new OutsideList();
}

class OutsideList extends State<outsideList> {
  String json = dataRecived;

  @override
  Widget build(BuildContext context) {
    List<Map> list = JSON.decode(json);


    return new Scaffold(
      appBar: new AppBar(title: new Text ("Outside List"), centerTitle: true,),
      body: new Material(
          color: Colors.white,
          child:
          new ListView.builder(
              itemCount: list.length == null ? 0 : list.length,
              itemBuilder: (BuildContext context, int index) {
                int _itemNumber = index + 1;
                return new ListTile(
                  title: new Text(_itemNumber.toString() + ". " +
                      list[index]['title'] + ": ",
                      style: (new TextStyle(fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(1.0),
                          wordSpacing: 5.0))),
                  trailing: list[index]['picture'] == "null" ?new Row(
                      children: <Widget>[ new Text(
                      list[index]['quantity'].toString() + " " +
                          list[index]['type'], style: (
                      new TextStyle(fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(1.0),
                          wordSpacing: 5.0))),
                 ]) :
                  new Row (children: <Widget>[
                    new Icon(Icons.panorama),
                    new Text(" "+list[index]['quantity'].toString() + " " +
                        list[index]['type'], style: (
                        new TextStyle(fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(1.0),
                            wordSpacing: 5.0))),

                  ]),
                  onLongPress: () {
                    _itemNumber = index;
                    var filesaved;
                    filesaved = new File("/storage/emulated/0/Grcerylist/" +
                        list[_itemNumber]['title'] +
                        list[_itemNumber]['quantity'].toString() + "image.png");
                    String image = list[_itemNumber]['picture'];
                    var bs = BASE64.decode(image);
                    filesaved.writeAsBytesSync(bs);
                    showDialog(
                        context: context,
                        child: new SimpleDialog(
                            title: new Text(
                              Intl.defaultLocale == 'ar_SA' ? "صوره" : "Image",
                              textAlign: TextAlign.center,),
                            children: <Widget>[
                              new Center(
                                  child: list[_itemNumber]['picture'] == "null"
                                      ? new Text(Intl.defaultLocale == 'ar_SA'
                                      ? "لا يوجد صوره مضافه"
                                      : 'No image added.')
                                      : new Image.file(
                                    filesaved, width: 200.0, height: 200.0,)),
                              new RaisedButton(onPressed: () {
                                Navigator.pop(context);
                              }, child: new Text("Okay"),),
                            ]
                        ));
                  },
                onTap: (){

                },);
              }
          )),
    );
  }
}


//intanal save /data/user/0/com.example.list/cache/
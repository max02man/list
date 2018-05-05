import 'dart:async';
import 'dart:io';
import 'package:list/pages/itemDetail.dart';
import 'package:flutter/material.dart';
import 'package:list/pages/outsideList.dart';
import 'dart:convert';
import '../databases/todos.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../plugin1/import_file.dart';




class ListGrocery extends StatefulWidget{
  @override
  State createState() => new ListGrocerys();
}

class Measure {
  const Measure(this.name);

  final String name;
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}
int itemNumber;
File imageFile= null;
String dataRecived = "";

class ListGrocerys extends State<ListGrocery> {
  TodoProvider _db =new TodoProvider();
  String _savedencode;
  double quantity = 0.0;
  Measure selectedUser;
  List<Measure> usersEng = <Measure>[const Measure('Kg'), const Measure('Bag'),const Measure('Peice'),const Measure("Ryail")];
  List<Measure> usersArb = <Measure>[const Measure('ك.ج'), const Measure('كيس'),const Measure("قطعه"),const Measure("ريال ")];
  final TextEditingController _controller = new TextEditingController();

//  static const platform = const MethodChannel('app.channel.shared.data');
//  String dataShared = "No data";
  @override
  void initState() {
    super.initState();

//    getSharedText();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: new AppBar(),
      drawer: new ListView(
        children: <Widget> [
          new Container(child: new DrawerHeader(child: new CircleAvatar()),color: Colors.lightGreen,),
    new Container (
    color: Colors.blueAccent,
    child:new Column(
    children: <Widget>[
          new ListTile(
            title: new Text(Intl.defaultLocale == 'ar_SA'? "حول":'About'),
            onTap: () {  showDialog(
    context: context,
    child: new SimpleDialog(
    title: new Text(Intl.defaultLocale == 'ar_SA'? "هذا التطبيق في مرحلة تجريبية إذا كانت لديك أي فكرة لتحسين التطبيق أرسله إلينا نحن نقدر دعمك :D "
        " \n شكرًا لك على استخدام تطبيقنا" :
    "This app is in beta if you have any idea to improve the app send it to us "
        "we appreciate your support :D"
        "\nThank you for you using our app"),
    children:<Widget>[
    new RaisedButton(onPressed: () { Navigator.pop(context);}
    , child: new Text(Intl.defaultLocale == 'ar_SA'? "أوكي":"OKAY"), ),
    ],
    ));},
          ),
          new Divider(),
          new ListTile(
            title: new Text(Intl.defaultLocale == 'ar_SA'? 'حفظ الملف':'Share'),
            onTap: () {
             var _count = TodoProvider.list.length;
             _db.getJson(_count);
             showDialog(
                 context: context,
                 child:
                 new SimpleDialog(
                     title: new Text(Intl.defaultLocale == 'ar_SA'? "تم حفظ الملف في ملف التحميل. اذهب هنا وارسله" :"File saved in Download file. \n Go there and "
                         "send it")));
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text(Intl.defaultLocale == 'ar_SA'? 'الطلبات الخارجيه':'Outside List'),
            onTap: () {importCallback();},
    )]
    )
          ),
        ],
      ),
        body: new Column (
            children: <Widget>[
//              new Text(dataShared),
              new Text(Intl.defaultLocale == 'ar_SA'? "أدخل الاغراض التي تود طلبها " :"Enter the Items you want to order",
                  style: new TextStyle(color: Colors.black, fontSize: 25.0)),
              new TextField(style: new TextStyle(fontSize: 30.0,color: Colors.black),
                controller: _controller,
                decoration:Intl.defaultLocale == 'ar_SA'? const InputDecoration(helperText:"أسم الغرض") :const InputDecoration(helperText:"The name"),
              ),
              new Row(
                  children: <Widget>[
              new IconButton(
                icon:new Icon (Icons.remove_circle ),color: Colors.blueAccent,
                iconSize: 60.0, onPressed: decrase, ),
              new Text(quantity.toString(),style:
              new TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(1.0),wordSpacing: 5.0 )),
              new IconButton(
                  icon:new Icon (Icons.add_circle ),color: Colors.blueAccent,
                  iconSize: 60.0, onPressed: incrase,
                   ),
              new DropdownButton (
                      hint: new Text(Intl.defaultLocale == 'ar_SA'?"المقياس":"Measure!"),
                      iconSize:30.0,
                      value: selectedUser,
                      items: Intl.defaultLocale == 'ar_SA'? usersArb.map((Measure user){// arabic list of measure
                        return new DropdownMenuItem(value: user,
                            child: new Text(user.name,style: new TextStyle(color: Colors.black, fontWeight:FontWeight.bold,), ));
                      }).toList()
                      :usersEng.map((Measure user) { //engligh list of measure
                        return new DropdownMenuItem(value: user,
                        child: new Text(user.name,style: new TextStyle(color: Colors.black, fontWeight:FontWeight.bold,), ));
                        }).toList(),
                onChanged: (Measure newValue) {
                        setState(() {
                          selectedUser = newValue;
                        });
                      },
                    ),
              new RaisedButton(onPressed:() {
                if (_savedencode == null) {
                  showDialog(
                      context: context,
                      child: new SimpleDialog(
                        title: new Text(Intl.defaultLocale == 'ar_SA'?" هل انت متاكد من عدم رغبتك لي اضافه صوره؟" :"Are you sure you don't want add an Image"),
                        children:<Widget>[
                          new RaisedButton(onPressed:(){getImage();
                          Navigator.pop(context);},child: new Text(Intl.defaultLocale == 'ar_SA'?"أضف صوره":"Add Image"),),
                          new RaisedButton(onPressed: (){Navigator.pop(context);
                          information(_controller.text, quantity, selectedUser.name, _savedencode);}
                            , child: new Text(Intl.defaultLocale == 'ar_SA'? "نعم, بدون صوره":"Yes, No Image"), ),
                        ],
                      ));}
                else
                  information(_controller.text, quantity, selectedUser.name, _savedencode);
              },

                child: new Text(Intl.defaultLocale == 'ar_SA'? "أدخل":"Enter"),
                color: Colors.blueAccent,
              ),
                  ]
              ),
              new Center(
                child: imageFile == null
                    ? new Text(Intl.defaultLocale == 'ar_SA'?"لا يوجد صوره مختاره.":'No image selected.')
                    : new Image.file(imageFile, width: 100.0,height: 100.0,),
              ),
              new Divider(height: 16.0, color: Colors.red,),
              // the list >>
              new Expanded(child:  new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    shrinkWrap: true,
                itemCount: TodoProvider.list.length == null ? 0 : TodoProvider.list.length,
                addAutomaticKeepAlives:true,
                itemBuilder: (BuildContext context, int index) {
                      int _itemNumber= index+1;
                        return new ListTile(title: new Text(_itemNumber.toString() +". "+
                            TodoProvider.list[index]['title'] +": ",
                            style:(new TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(1.0),
                                wordSpacing: 5.0 ))),
                          trailing: TodoProvider.list[index]['picture'] == "null" ?new Text( TodoProvider.list[index]['quantity'].toString() + " " +   TodoProvider.list[index]['type'], style:(
                              new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(1.0),wordSpacing: 5.0 ))):
                         new Row (children: <Widget>[new Icon(Icons.panorama), new  Text(TodoProvider.list[index]['quantity'].toString() + " " +   TodoProvider.list[index]['type'], style:(
                              new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(1.0),wordSpacing: 5.0 )))]),
                          onTap:() {
                          itemNumber=index;
                            Navigator.of(context).push(new MaterialPageRoute(
                              builder: (
                                  BuildContext context) => new itemDetail(),));
                          },
                          onLongPress: (){
                            _db.delete(TodoProvider.list[index]['title'] );
                            showDialog(context: context,
                                child: new SimpleDialog(
                                  title: new Text(Intl.defaultLocale == 'ar_SA'?"!تم حذف الغرض ":"Item have been deleted successfully"),
                                  children:<Widget>[
                                    new RaisedButton(onPressed: (){Navigator.pop(context);}, child: new Text("Okay"), ),
                                  ],) );
                          },
                          );
                       },
                //                   children: <Widget>[
              )),
        ],),

      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  void information (String _name, double _q, String _type, String _picture){
  _db.insert(_name, _q, _type, _picture);

  _controller.clear();
  selectedUser = null;
  quantity=0.0;
  imageFile=null;
  _savedencode=null;
}

  getImage() async {
    var _fileName = await ImagePicker.pickImage(maxHeight: 500.0,maxWidth: 500.0);
    var _imageEncode = _fileName.readAsBytesSync();
    setState(() {
      _savedencode = BASE64.encode(_imageEncode);
      imageFile = _fileName;
    });
  }

  void incrase () {
   setState(() { quantity = quantity +0.5;
           });}

  void decrase () {
   setState(() {
     if (quantity == 0.0)
       quantity=0.0;
     else
     quantity = quantity - 0.5;
   });



  }

  String _uri = '';
//  getSharedText() async {
//    var sharedData = await platform.invokeMethod("getSharedText");
//    if (sharedData != null) {
//      setState(() {
//        dataShared = sharedData;
//      });
//    }
//  }

  void importCallback() async {
    String uri ="";
    String data = "";
    try {
      uri = await ImportFile.importFile('text/*');
      data = await new File(uri).readAsString();
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) =>new outsideList()));
    } on PlatformException {
      uri = 'Failed to get file.';
    }
    setState(() {
      _uri = uri;
      dataRecived = data;});
  }
}

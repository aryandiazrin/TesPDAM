import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './ambilgambar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TKD PDAM TEST',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) { return MyHomePage();},
        '/camera': (BuildContext context) { return CameraExample();}
      },
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  HomeScreen createState(){
    return HomeScreen();
  }
}

class HomeScreen extends State<MyHomePage>{
  
  final String url = "https://jsonplaceholder.typicode.com/users";
  List data;
  File imageFile;

  Future<List<User>> getData() async{
    var data = await http.get(url);
    var jsonData = json.decode(data.body);

    List<User> users = [];

    for(var u in jsonData){
      User user = User(u["id"] ,u["name"], u["username"], u["email"]);

      users.add(user);
    }

    print(users.length);

    return users;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('TKD ITPDAMGM'),
      ),
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print(snapshot.data);
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading . . . ")
                )
              );
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data[index].name,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            snapshot.data[index].username,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            snapshot.data[index].email,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          RaisedButton(
                            child: Text(
                              'ambil gambar',
                              style: TextStyle(
                                fontSize: 8.0,
                                color: Colors.white
                              ),),
                            onPressed: (){
                              Navigator.pushNamed(context, '/camera');
                          },)
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        )
      ),
    );
  }
    
}

class User{
  final int id;
  final String name;
  final String username;
  final String email;

  User(this.id, this.name, this.username, this.email);
}
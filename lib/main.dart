import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future <List<Data>> fetchData() async {
  final response =
  await http.get(Uri.https('jsonplaceholder.typicode.com','todos'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final int id;
  final String title;
  late final bool completed;


  Data({ required this.id,required this.title,required this.completed});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      title:json['title'],
      completed: json['completed'],
    );
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter(bool completed) {
    setState(() {
      completed=false;
    });
  }
  late Future <List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
      child: FutureBuilder <List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data>? data = snapshot.data;
                return
                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: data?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6),
                      itemBuilder: (BuildContext context, int index) {
                        if(data![index].completed==true) {
                          return Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.all(10.0),
                            //
                            child:ElevatedButton(
                            style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.purple,),
                              child: Text(data![index].title),
                              onPressed: () {
                                _incrementCounter(data![index].completed);
                              },

                            )
                          );
                        }
                        else{
                          return Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.all(10.0),
                              child:ElevatedButton(
                                style: ElevatedButton.styleFrom(

                                  backgroundColor: Colors.blue,),
                                child: Text(data![index].title),
                                onPressed: () {
                                  _incrementCounter(data![index].completed);
                                },

                              )

                          );
                        }
                      }
                  );
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
                return const Center(
                  child:CircularProgressIndicator(),
                );
            },
         )
      )
      );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shimmer'),
      ),
      body: Center(
        child: SizedBox(
          width: 210.0,
          height: 240.0,
          child: Shimmer(
            child: Column(
              children: [
                _PlaceHolder(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: _PlaceHolder(),
                ),
                Expanded(
                    child: Text(
                  'Awesome',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.0,
                height: 16.0,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: 50.0,
                  height: 16.0,
                  color: Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Input(),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 20, top: 10),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [Text("text1")],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            Text("Text 2"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 2"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 2"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 2"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                            Text("Text 3"),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Input extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(5),
                  topLeft: const Radius.circular(5),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: Container(
            color: Colors.transparent,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    bottomRight: const Radius.circular(5),
                    topRight: const Radius.circular(5),
                  )),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

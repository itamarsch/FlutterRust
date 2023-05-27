import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WebSocketChannel? channel;
  String text = "";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: Center(
        child: Column(
          children: [
            StreamBuilder(
              stream: channel?.stream,
              builder: (final BuildContext context, final snaphot) =>
                  Text(snaphot.data.toString()),
            ),
            SizedBox(width: 200, child: TextField(onChanged: (s) => text = s)),
            ElevatedButton(
                child: const Text("Send"),
                onPressed: () {
                  channel?.sink.add(text);
                }),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  channel = WebSocketChannel.connect(
                      Uri.parse("ws://localhost:9991"));
                });
              },
              child: const Text(
                "Connect",
              ),
            ),
          ],
        ),
      )),
    );
  }
}

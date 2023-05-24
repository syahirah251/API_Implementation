import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String API_URL = 'https://api.quotable.io/random';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Future<Map<String, dynamic>> fetchQuote() async {
    final response = await http.get(Uri.parse(API_URL));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote App'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchQuote(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final quote = snapshot.data!['content'];
              final author = snapshot.data!['author'];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    quote,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '- $author -',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

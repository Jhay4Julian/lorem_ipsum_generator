import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _paragraphs = [];

  Future<void> fetchLoremText(int paragraphs) async {
    final response = await http.get(
      Uri.parse(
          'https://api.api-ninjas.com/v1/loremipsum?paragraphs=$paragraphs'),
      headers: {'X-Api-Key': '/ekZbgdfd23YEUx+1IpSUA==dtbKieg0Fc9rtAdg'},
    );
    if (response.statusCode == 200) {
      setState(() {
        _paragraphs =
            (json.decode(response.body)['text'] as String).split('\n');
      });
    } else {
      setState(() {
        _paragraphs = ['Error fetching text'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loren Ipsum Generator'),
        centerTitle: true,
      ),
    );
  }
}

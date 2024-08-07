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
  final TextEditingController _controller = TextEditingController();

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

  // generate text function
  void _generateLoremText() {
    int paragraphs = int.tryParse(_controller.text) ?? 0;
    if (paragraphs > 0) {
      fetchLoremText(paragraphs);
      FocusScope.of(context).unfocus();
    } else {
      setState(() {
        _paragraphs = ['Enter a valid number.'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: GestureDetector(
            // close text field/ remove keyboard
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                const Text(
                  'Loren Ipsum Generator',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                Text(
                  'Tired of boring Lorem Ipsum?'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Paragraphs:',
                      style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                    ),
                    // paragraph input
                    SizedBox(
                      height: 35,
                      width: 70,
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // generate button
                    MaterialButton(
                      color: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 9),
                      onPressed: _generateLoremText,
                      child: const Text(
                        'Generate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: _paragraphs.map((paragraph) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          paragraph.substring(0),
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            cursorColor: Colors.white,
            controller: _searchController,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              focusColor: Colors.white,
              labelText: 'Search',
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  _searchRepositories();
                },
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: _searchResults
                .map((result) => ListTile(
                        title: Text(
                      result,
                      style: TextStyle(color: Colors.white),
                    )))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _searchRepositories() async {
    if (_searchController.text.isEmpty) {
      _searchResults.clear();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var response = await http.get(Uri.parse(
      'https://api.github.com/search/repositories?q=${_searchController.text}',
    ));
    print("response is:" + response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> items = jsonResponse['items'];
      setState(() {
        _searchResults =
            items.map((item) => item['full_name'].toString()).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _searchResults.clear();
        _isLoading = false;
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

import 'Data/post_jeson.dart';
import 'fetch_operation.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = ScrollController();
  List<Post> _posts = [];
  int _currentPage = 0;
  int _totalPages = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      if (_currentPage < _totalPages) {
        _fetchPosts();
      }
    }
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedPosts = await FetchOperation.fetchPosts(_currentPage, 2);

      setState(() {
        _posts.addAll(fetchedPosts);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to fetch posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagination Example'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < _posts.length) {
            final post = _posts[index];
            final number = index + 1; // Calculate the number
            return ListTile(
              leading: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(post.title),
              subtitle: Text(post.body),
            );
          }

          if (_currentPage < _totalPages) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}

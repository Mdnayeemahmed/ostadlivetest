import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Data/post_jeson.dart';

class FetchOperation {
  static Future<List<Post>> fetchPosts(int currentPage, int limit) async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_start=$currentPage&_limit=$limit'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Post> fetchedPosts = [];
      for (var post in jsonData) {
        fetchedPosts.add(Post.fromJson(post));
      }

      return fetchedPosts;
    } else {
      throw Exception('Failed to fetch posts');
    }
  }
}

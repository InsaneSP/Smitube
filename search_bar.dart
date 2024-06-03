import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'video_list.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final Function(List<VideoInfo>) onSearchResults;

  CustomSearchDelegate({required this.onSearchResults});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close with an empty string instead of null
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _searchVideos(query),
      builder: (context, AsyncSnapshot<List<VideoInfo>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found.'));
        } else {
          var videos = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onSearchResults(videos); // Schedule state update
            close(context, query); // Close the search and pass the query
          });
          return Container(); // This can be an empty container or a loading widget
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(); // Return an empty container if the query is empty
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('videos')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + 'z') // Ensures that it's a prefix search
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<DocumentSnapshot> suggestions = snapshot.data!.docs;

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final String title = suggestions[index]['title'] ?? '';
            return ListTile(
              title: Text(title),
              onTap: () {
                query = title;
              },
            );
          },
        );
      },
    );
  }

  Future<List<VideoInfo>> _searchVideos(String query) async {
    List<VideoInfo> videos = [];

    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('videos')
        .where('title', isEqualTo: query)
        .get();

    if (result.docs.isEmpty) {
      result = await FirebaseFirestore.instance
          .collection('videos')
          .where('genre', isEqualTo: query)
          .get();
    }

    for (var doc in result.docs) {
      videos.add(VideoInfo(
        title: doc['title'],
        videoPath: doc['url'],
      ));
    }

    return videos;
  }
}

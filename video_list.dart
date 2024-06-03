import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoInfo {
  String title;
  String videoPath;
  VideoPlayerController? videoController;

  VideoInfo({
    required this.title,
    required this.videoPath,
    this.videoController,
  });

  Future<void> initializeVideoController() async {
    videoController = VideoPlayerController.network(videoPath);
    await videoController!.initialize();
  }

  void disposeVideoController() {
    videoController?.dispose();
  }

  static Future<List<VideoInfo>> fetchVideosByGenre(String genre) async {
    List<VideoInfo> videos = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('videos')
        .where('genre', isEqualTo: genre)
        .get();

    for (var doc in snapshot.docs) {
      videos.add(VideoInfo(
        title: doc['title'],
        videoPath: doc['url'],
      ));
    }
    return videos;
  }

  static Future<List<VideoInfo>> fetchAllVideos() async {
    List<VideoInfo> videos = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('videos')
        .get();

    for (var doc in snapshot.docs) {
      if (doc['genre'] != 'shorts') {
        videos.add(VideoInfo(
          title: doc['title'],
          videoPath: doc['url'],
        ));
      }
    }
    return videos;
  }
}
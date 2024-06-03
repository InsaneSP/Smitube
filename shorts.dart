import 'package:flutter/material.dart';
import 'video_list.dart';
import 'package:video_player/video_player.dart';
import 'main.dart';
import 'add.dart';
import 'subscriptions.dart';
import 'profile.dart';

class ShortsPage extends StatefulWidget {
  const ShortsPage({Key? key}) : super(key: key);

  @override
  _ShortsPageState createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  int currentIndex = 1;
  List<VideoInfo> videos = [];

  @override
  void initState() {
    super.initState();
    fetchVerticalVideos();
  }

  Future<void> fetchVerticalVideos() async {
    List<VideoInfo> allVideos = await VideoInfo.fetchVideosByGenre('Shorts');
    for (var video in allVideos) {
      await video.initializeVideoController();
      if (video.videoController!.value.size.height >
          video.videoController!.value.size.width) {
        videos.add(video);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    for (var video in videos) {
      video.disposeVideoController();
    }
  }

  void toggleVideoPlayback(VideoInfo video) {
    if (video.videoController != null) {
      if (video.videoController!.value.isPlaying) {
        video.videoController!.pause();
      } else {
        video.videoController!.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xffEBF2FA),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: videos.map((video) {
              return video.videoController != null
                  ? Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio:
                                video.videoController!.value.aspectRatio,
                            child: GestureDetector(
                              onTap: () => toggleVideoPlayback(video),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  VideoPlayer(video.videoController!),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () => toggleVideoPlayback(video),
                              ),
                              IconButton(
                                icon: const Icon(Icons.pause),
                                onPressed: () => video.videoController?.pause(),
                              ),
                            ],
                          ),
                          Text(video.title),
                        ],
                      ),
                    )
                  : Container();
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xffE5E4E2),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home, color: Colors.black, size: 25.0),
          ),
          BottomNavigationBarItem(
            label: 'Shorts',
            icon: Icon(Icons.video_collection_rounded,
                color: Colors.black, size: 25.0),
          ),
          BottomNavigationBarItem(
            label: 'Add',
            icon: Icon(Icons.add_circle_outline_rounded,
                color: Colors.black, size: 25.0),
          ),
          BottomNavigationBarItem(
            label: 'Subscriptions',
            icon: Icon(Icons.subscriptions_rounded,
                color: Colors.black, size: 25.0),
          ),
          BottomNavigationBarItem(
            label: 'You',
            icon: Icon(Icons.person, color: Colors.black, size: 25.0),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });

          if (currentIndex == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const MainPage();
            }));
          } else if (currentIndex == 1) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const ShortsPage();
            }));
          } else if (currentIndex == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const AddPage();
            }));
          } else if (currentIndex == 3) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const SubscriptionsPage();
            }));
          } else if (currentIndex == 4) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const ProfilePage();
            }));
          }
        },
      ),
    );
  }
}

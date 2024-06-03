import 'package:flutter/material.dart';
import 'video_list.dart';
import 'package:video_player/video_player.dart';
import 'search_bar.dart';
import 'shorts.dart';
import 'add.dart';
import 'subscriptions.dart';
import 'profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List<VideoInfo> videos = [];

  @override
  void initState() {
    super.initState();
    fetchAllVideos();
  }

  Future<void> fetchAllVideos() async {
    videos = await VideoInfo.fetchAllVideos();
    for (var video in videos) {
      await video.initializeVideoController();
    }
    setState(() {}); // Update the state to trigger a rebuild
  }

  Future<void> fetchVideosByGenre(String genre) async {
    videos = await VideoInfo.fetchVideosByGenre(genre);
    for (var video in videos) {
      await video.initializeVideoController();
    }
    setState(() {}); // Update the state to trigger a rebuild
  }

  void updateVideos(List<VideoInfo> newVideos) async {
    videos = newVideos;
    for (var video in videos) {
      await video.initializeVideoController();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Image.asset('image/LogoBG.png'),
          leadingWidth: 150,
          backgroundColor: const Color(0xffE5E4E2),
          title: const Text(
            'Smitube',
            style: TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          toolbarHeight: 65,
          actions: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.cast, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.notifications, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(onSearchResults: (results) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      updateVideos(results);
                    });
                  }),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.search, color: Colors.black),
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xffEBF2FA),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xffE5E4E2),
                      ),
                      onPressed: () {
                        fetchAllVideos();
                      },
                      child: const Text('All'),
                    ),
                    buildGenreButton('Nature', 'Nature'),
                    buildGenreButton('Gaming', 'Gaming'),
                    buildGenreButton('Dance', 'Dance'),
                    buildGenreButton('Kids', 'Kids'),
                    buildGenreButton('Animal', 'Animal'),
                  ],
                ),
              ),
              Expanded(
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
                              aspectRatio: video.videoController!.value.aspectRatio,
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
            ],
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
              icon: Icon(Icons.video_collection_rounded, color: Colors.black, size: 25.0),
            ),
            BottomNavigationBarItem(
              label: 'Add',
              icon: Icon(Icons.add_circle_outline_rounded, color: Colors.black, size: 25.0),
            ),
            BottomNavigationBarItem(
              label: 'Subscriptions',
              icon: Icon(Icons.subscriptions_rounded, color: Colors.black, size: 25.0),
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
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const MainPage();
              }));
            } else if (currentIndex == 1) {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const ShortsPage();
              }));
            } else if (currentIndex == 2) {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const AddPage();
              }));
            } else if (currentIndex == 3) {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const SubscriptionsPage();
              }));
            } else if (currentIndex == 4) {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const ProfilePage();
              }));
            }
          },
        ),
      ),
    );
  }

  Widget buildGenreButton(String label, String genre) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topLeft,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xffE5E4E2),
          ),
          onPressed: () {
            setState(() {
              fetchVideosByGenre(genre);
            });
          },
          child: Text(label),
        ),
      ),
    );
  }
}
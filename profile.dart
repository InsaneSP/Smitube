import 'package:flutter/material.dart';
import 'video_list.dart';
import 'package:video_player/video_player.dart';
import 'auth_service.dart';
import 'main.dart';
import 'add.dart';
import 'shorts.dart';
import 'subscriptions.dart';
import 'opening.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentIndex = 4;
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
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    for (var video in videos) {
      video.disposeVideoController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xffEBF2FA),
            actions: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  Icons.cast,
                  color: Colors.black,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
                onTap: () async {
                  await AuthService().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const OpeningPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xffEBF2FA),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'image/Me.png',
                      height: 130,
                      width: 150,
                    ),
                    const SizedBox(width: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Smit Potkar',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '@SmitPotkar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inika',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Watch History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayer(videos[index].videoController!),
                        ),
                      );
                    },
                  ),
                ),
                const Text(
                  'Playlists',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',
                  ),
                ),
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset('image/Playlist1.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset('image/Playlist2.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset('image/Playlist3.png'),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Icon(
                      Icons.video_collection_rounded,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Your Videos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Icon(
                      Icons.download,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Your Downloads',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Image.asset(
                      'image/LogoBG.png',
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Get Premium',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Icon(
                      Icons.bar_chart,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Time Watched',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 25),
                    Icon(
                      Icons.question_mark_outlined,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'FAQ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
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
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 25.0,
                  )),
              BottomNavigationBarItem(
                  label: 'Shorts',
                  icon: Icon(
                    Icons.video_collection_rounded,
                    color: Colors.black,
                    size: 25.0,
                  )),
              BottomNavigationBarItem(
                  label: 'Add',
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.black,
                    size: 25.0,
                  )),
              BottomNavigationBarItem(
                  label: 'Subscriptions',
                  icon: Icon(
                    Icons.subscriptions_rounded,
                    color: Colors.black,
                    size: 25.0,
                  )),
              BottomNavigationBarItem(
                  label: 'You',
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 25.0,
                  )),
            ],
            currentIndex: currentIndex,
            onTap: (int index) {
              setState(() {
                currentIndex = index;
              });

              if (currentIndex == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const MainPage();
                  }),
                );
              } else if (currentIndex == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const ShortsPage();
                  }),
                );
              } else if (currentIndex == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const AddPage();
                  }),
                );
              } else if (currentIndex == 3) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const SubscriptionsPage();
                  }),
                );
              } else if (currentIndex == 4) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const ProfilePage();
                  }),
                );
              }
            },
          ),
        ));
  }
}

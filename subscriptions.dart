import 'package:flutter/material.dart';
import 'main.dart';
import 'add.dart';
import 'shorts.dart';
import 'profile.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  int currentIndex = 3;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: Image.asset('image/LogoBG.png'),
            leadingWidth: 150,
            backgroundColor: const Color(0xffE5E4E2),
            title: const Text('Smitube',
                style: TextStyle(
                    fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
            centerTitle: true,
            toolbarHeight: 65,
            actions: const [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.cast,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xffEBF2FA),
            child: const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  CustomCard(
                    imageAsset: 'image/TanmayBhat.png',
                    title: 'Tanmay Bhat',
                    subtitle: '@TanmayBhatYT',
                    subscribers: '4.69M subscribers',
                    videos: '989 videos',
                  ),
                  CustomCard(
                    imageAsset: 'image/GateSmashers.png',
                    title: 'Gate Smashers',
                    subtitle: '@GateSmashers',
                    subscribers: '1.81M subscribers',
                    videos: '1.5k videos',
                  ),
                  CustomCard(
                    imageAsset: 'image/CodeWithHarry.png',
                    title: 'CodeWithHarry',
                    subtitle: '@CodeWithHarry',
                    subscribers: '5.71M subscribers',
                    videos: '2.3K videos',
                  ),
                  CustomCard(
                    imageAsset: 'image/OfflineTV.png',
                    title: 'OfflineTV',
                    subtitle: '@OfflineTV',
                    subscribers: '3.17M subscribers',
                    videos: '230 videos',
                  ),
                  CustomCard(
                    imageAsset: 'image/TSeries.png',
                    title: 'T-Series',
                    subtitle: '@tseries',
                    subscribers: '261M subscribers',
                    videos: '20K videos',
                  ),
                  CustomCard(
                    imageAsset: 'image/MrBeast.png',
                    title: 'MrBeast',
                    subtitle: '@MrBeast',
                    subscribers: '243M subscribers',
                    videos: '780 videos',
                  ),
                  CustomCard(
                    imageAsset: 'image/DinoJames.png',
                    title: 'Dino James',
                    subtitle: '@DinoJames',
                    subscribers: '6.15M subscribers',
                    videos: '82 videos',
                  ),
                ],
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

class CustomCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final String subscribers;
  final String videos;


  const CustomCard({
    Key? key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.subscribers,
    required this.videos,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 30, left: 25),
        child: Container(
          alignment: Alignment.topRight,
          width: 450,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xffE5E4E2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        imageAsset,
                        height: 130,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inika',
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Subscribers: $subscribers',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            '$videos',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
        )
    );
  }
}
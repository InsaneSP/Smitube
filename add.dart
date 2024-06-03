import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'shorts.dart';
import 'subscriptions.dart';
import 'profile.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int currentIndex = 2;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final logger = Logger();
  String? selectedGenre;
  String? title;
  bool isUploading = false;
  final List<String> genres = [
    'Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi', 'Documentary', 'Nature',
    'Gaming', 'Dance', 'Kids', 'Animal', 'Shorts', 'Others'
  ];

  VideoPlayerController? _videoPlayerController;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) return;
    pickedFile = result.files.first;
  }

  Future<void> uploadFile() async {
    if (pickedFile == null || selectedGenre == null || title == null || title!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video, enter a title, and select a genre.')),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final path = 'videos/${pickedFile!.name}';
      final ref = FirebaseStorage.instance.ref().child(path);

      if (kIsWeb) {
        final bytes = pickedFile!.bytes!;
        uploadTask = ref.putData(bytes);
      } else {
        final file = File(pickedFile!.path!);
        uploadTask = ref.putFile(file);
      }

      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to upload a video.')),
        );
        return;
      }

      final channelRef = FirebaseFirestore.instance.collection('channels').doc(currentUser.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final channelSnapshot = await transaction.get(channelRef);

        if (!channelSnapshot.exists) {
          // If channel doesn't exist, create it
          transaction.set(channelRef, {
            'username': currentUser.email, // Replace with desired username field
            'totalVideos': 1,
            'subscribers': 0,
            'createdAt': Timestamp.now(),
          });
        } else {
          // If channel exists, update totalVideos
          transaction.update(channelRef, {
            'totalVideos': FieldValue.increment(1),
          });
        }

        // Add video to the channel's videos sub-collection
        final newVideoRef = channelRef.collection('videos').doc();
        transaction.set(newVideoRef, {
          'title': title,
          'url': urlDownload,
          'genre': selectedGenre,
          'uploadedAt': Timestamp.now(),
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video uploaded successfully!')),
      );
    } catch (e) {
      logger.e("Failed to upload video: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload video: $e')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Widget buildProgress() {
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return LinearProgressIndicator(value: progress);
        } else {
          return const SizedBox(height: 50);
        }
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
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
          actions: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.cast, color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.notifications, color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.search, color: Colors.black),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xffEBF2FA),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: selectFile,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xffE5E4E2),
                ),
                child: const Text('Select Video'),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Select Genre',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      value: selectedGenre,
                      items: genres.map((String genre) {
                        return DropdownMenuItem<String>(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGenre = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isUploading ? null : uploadFile,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xffE5E4E2),
                ),
                child: const Text('Upload Video'),
              ),
              const SizedBox(height: 30),
              buildProgress(),
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
      ),
    );
  }
}

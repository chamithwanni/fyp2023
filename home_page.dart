import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:project_final23/user_account/login_screen.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key? key,
      required this.favoriteArtist,
      required this.favoriteGenre,
      required this.userMood,
      required this.data})
      : super(key: key);

  final String favoriteArtist;
  final String favoriteGenre;
  final String userMood;
  final Map<String, dynamic> data;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      MainPage(
        data: widget.data,
      ),
      SavePlaylist(),
      ProfilePage(
        favoriteArtist: widget.favoriteArtist,
        favoriteGenre: widget.favoriteGenre,
      ),
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final String apiUrl = "http://10.0.2.2:8000/playlist";

  Future<Map<String, dynamic>> sendApiRequest(
      String param1, String param2, String param3) async {
    final url = Uri.parse('$apiUrl?name=$param1&genres=$param2&mood=$param3');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data);
    } else {
      throw Exception(
          'Request failed with status: ${response.statusCode}.${response.reasonPhrase}');
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> savePlaylistData(Map<String, dynamic> data) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final email = currentUser.email;
      if (email != null) {
        final encodedEmail = base64Encode(email.codeUnits);
        final playlistRef = ref.child('playlists').child(encodedEmail);
        try {
          await playlistRef.set(data);
          print('Playlist data saved successfully');
        } catch (e) {
          print('Error saving playlist data: $e');
        }
      } else {
        print('Current user email is null');
      }
    } else {
      print('User is not logged in');
    }
  }

  Future<Map<String, dynamic>?> getPlaylistData() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final email = currentUser.email;
      if (email != null) {
        final encodedEmail = base64Encode(email.codeUnits);
        final playlistRef = ref.child('playlists').child(encodedEmail);
        DataSnapshot snapshot =
            await playlistRef.once().then((event) => event.snapshot);
        if (snapshot.value != null) {
          return Map<String, dynamic>.from(
              snapshot.value as Map<dynamic, dynamic>);
        } else {
          return null;
        }
      } else {
        print('Current user email is null');
        return null;
      }
    } else {
      print('User is not logged in');
      return null;
    }
  }

  Map<String, dynamic> new_data = {};

  @override
  Widget build(BuildContext context) {
    new_data = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Box'),
        actions: [
          IconButton(
              onPressed: () async {
                Map<String, dynamic> playlist_dt = await sendApiRequest(
                    widget.favoriteArtist,
                    widget.favoriteGenre,
                    widget.userMood);
                setState(() {
                  new_data = playlist_dt;
                  _children[0] = MainPage(data: playlist_dt);
                });
              },
              icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              Map<String, dynamic>? old_data = await getPlaylistData();

              List<dynamic> old_tracks_list =
                  old_data != null ? old_data['tracks_list'] : [];
              List<dynamic> new_tracks_list = new_data['tracks_list'];
              List<dynamic> combined_tracks_list = [
                ...old_tracks_list,
                ...new_tracks_list
              ];
              Map<String, dynamic> all_data = {
                'tracks_list': combined_tracks_list,
                'image_url': new_data['image_url']
              };

              // Check if the playlist is already saved in the database
              if (old_data != null &&
                  ListEquality()
                      .equals(old_tracks_list, combined_tracks_list)) {
                // Playlist already saved
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Playlist already saved')),
                );
              } else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Text('Saving playlist data...'),
                          ],
                        ),
                      ),
                    );
                  },
                );
                await savePlaylistData(all_data);
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.download),
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Saved Playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SavePlaylist extends StatelessWidget {
  Future<Map<String, dynamic>?> getPlaylistData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    if (currentUser != null) {
      final email = currentUser.email;
      if (email != null) {
        final encodedEmail = base64Encode(email.codeUnits);
        final playlistRef = ref.child('playlists').child(encodedEmail);
        DataSnapshot snapshot =
            await playlistRef.once().then((event) => event.snapshot);
        if (snapshot.value != null) {
          return Map<String, dynamic>.from(
              snapshot.value as Map<dynamic, dynamic>);
        } else {
          return null;
        }
      } else {
        print('Current user email is null');
        return null;
      }
    } else {
      print('User is not logged in');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getPlaylistData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Playlist data is still loading
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error occurred while loading playlist data
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          // No playlist data found
          return Center(child: Text('No playlist data found'));
        } else {
          // Playlist data is available
          Map<String, dynamic> playlistData = snapshot.data!;
          List<dynamic> tracksList = playlistData['tracks_list'];
          List<Widget> trackWidgets = [];

          for (var track in tracksList) {
            String title = track;
            trackWidgets.add(Text(title));
          }
          return Card(
            child: ListView(children: trackWidgets)
          );
        }
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String favoriteArtist;
  final String favoriteGenre;

  ProfilePage({
    required this.favoriteArtist,
    required this.favoriteGenre,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userEmail = currentUser?.email ?? '';

    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 16, top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            child: Image.asset(
              'assets/images/user_image.png',
              height: 60,
              width: 60,
              alignment: Alignment.center,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Email:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Favorite Artist:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            favoriteArtist,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Favorite Genres:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            favoriteGenre,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LogInScreen()))
                  });
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final Map<String, dynamic> data;

  MainPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your Playlist:',
            style: TextStyle(fontSize: 15),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  data['tracks_list'] != null ? data['tracks_list'].length : 0,
              itemBuilder: (context, index) {
                String trackName = data['tracks_list'][index];
                int dashIndex = trackName.indexOf('-');
                String songName =
                    trackName.substring(dashIndex + 2).toUpperCase();
                String artistName =
                    trackName.substring(0, dashIndex).toLowerCase();

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        data['image_url'],
                      ),
                      radius: 30,
                    ),
                    title: Text(
                      songName,
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      artistName,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

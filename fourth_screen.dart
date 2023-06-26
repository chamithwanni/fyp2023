import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_final23/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FourthScreen extends StatefulWidget {
  FourthScreen({Key? key, required this.imgEmotion, required this.qusEmotion})
      : super(key: key);

  String imgEmotion;
  final String qusEmotion;

  @override
  _FourthScreenState createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  String _favoriteArtist = '';
  String userMood = '';
  String _dropdownValue = '';
  List<String> _suggestions = [];
  List<String> _genresList = [];

  void _submit() async {
    _finalEmotion();
    Map<String, dynamic> playlist_data =
        await sendApiRequest(_favoriteArtist, _dropdownValue, userMood);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
            favoriteArtist: _favoriteArtist,
            favoriteGenre: _dropdownValue,
            userMood: userMood,
            data: playlist_data),
      ),
    );
  }

  String _finalEmotion() {
    String final_emotion = '';
    if (widget.qusEmotion == 'Happy' && widget.imgEmotion == 'Happy') {
      final_emotion = 'Happy';
    } else if (widget.qusEmotion == 'Happy' &&
        (widget.imgEmotion == 'Sad' ||
            widget.imgEmotion == 'Angry' ||
            widget.imgEmotion == 'Fearful' ||
            widget.imgEmotion == 'Disgust' ||
            widget.imgEmotion == 'Surprised' ||
            widget.imgEmotion == 'Natural')) {
      final_emotion = widget.imgEmotion;
    } else if (widget.qusEmotion == 'Natural' &&
        widget.imgEmotion == 'Natural') {
      final_emotion = 'Natural';
    } else if (widget.qusEmotion == 'Natural' &&
        (widget.imgEmotion == 'Sad' ||
            widget.imgEmotion == 'Angry' ||
            widget.imgEmotion == 'Fearful' ||
            widget.imgEmotion == 'Disgust' ||
            widget.imgEmotion == 'Surprised' ||
            widget.imgEmotion == 'Happy')) {
      final_emotion = widget.imgEmotion;
    } else if (widget.qusEmotion == 'Sad' && widget.imgEmotion == 'Sad') {
      final_emotion = 'Sad';
    } else if (widget.qusEmotion == 'Sad' &&
        (widget.imgEmotion == 'Happy' ||
            widget.imgEmotion == 'Angry' ||
            widget.imgEmotion == 'Fearful' ||
            widget.imgEmotion == 'Disgust' ||
            widget.imgEmotion == 'Surprised' ||
            widget.imgEmotion == 'Natural')) {
      final_emotion = widget.imgEmotion;
    } else if (widget.qusEmotion == "" && widget.imgEmotion == "Angry") {
      final_emotion = "Angry";
    } else if (widget.qusEmotion == "" && widget.imgEmotion == "Disgust") {
      final_emotion = "Disgust";
    } else if (widget.qusEmotion == "" && widget.imgEmotion == "Fearful") {
      final_emotion = "Fearful";
    } else if (widget.qusEmotion == "" && widget.imgEmotion == "Surprised") {
      final_emotion = "Surprised";
    } else if (widget.qusEmotion == "" && widget.imgEmotion == "Natural") {
      final_emotion = "Natural";
    } else if (widget.qusEmotion == "" && widget.imgEmotion == "Happy") {
      final_emotion = "Happy";
    } else if (widget.qusEmotion == "" && widget.imgEmotion == "Sad") {
      final_emotion = "Sad";
    } else {
      print('something went wrong emotion!');
    }
    print("Final Emotion:${final_emotion}");
    if (final_emotion == "Happy") {
      userMood = 'clam';
    } else if (final_emotion == 'Natural') {
      userMood = 'relaxing';
    } else if (final_emotion == 'Sad') {
      userMood = 'soothing';
    } else if (final_emotion == 'Angry') {
      userMood = 'peaceful';
    } else if (final_emotion == 'Disgusted') {
      userMood = 'tranquil';
    } else if (final_emotion == 'Fearful') {
      userMood = 'comforting';
    } else if (final_emotion == 'Surprised') {
      userMood = 'gentle';
    } else {
      print('something went wrong mood!');
    }
    print("User Mood: ${userMood}");
    return userMood;
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

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Box'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: Image.asset(
                  'assets/images/logo_project.png',
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Tell us Your Music Preference',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 15),
                    TextField(
                      controller: _searchController,
                      onChanged: _updateSuggestions,
                      decoration: InputDecoration(
                        hintText: 'Search for an artist',
                        icon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(_suggestions[index]),
                            onTap: () => _selectArtist(_suggestions[index]),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Select Your Genres",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    PopupMenuButton<String>(
                        onSelected: (String value) {
                          setState(() {
                            _dropdownValue = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return _genresList.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child:
                                  Text(value.isEmpty ? 'Select Genres' : value),
                            );
                          }).toList();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _dropdownValue ?? 'Select Genres',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down),
                              ],
                            )))
                  ],
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getSpotifyToken() async {
    final clientId = 'd394d2eb5ad14357976ea46406f915f8';
    final clientSecret = '6b692be0cf984932b58d5885fed59094';
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret'));
    final tokenUrl = 'https://accounts.spotify.com/api/token';

    final response = await http.post(Uri.parse(tokenUrl), headers: {
      'Authorization': basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: {
      'grant_type': 'client_credentials',
    });

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final tokenType = jsonBody['token_type'];
      final accessToken = jsonBody['access_token'];
      return '$tokenType $accessToken';
    } else {
      throw Exception('Failed to get Spotify token');
    }
  }

  void _updateSuggestions(String query) async {
    // Call the Spotify API to search for artists
    final token = await getSpotifyToken();
    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/search?q=$query&type=artist&limit=10'),
      headers: {'Authorization': token},
    );
    // Parse the response to extract the artist names
    final data = json.decode(response.body);
    if (data != null &&
        data['artists'] != null &&
        data['artists']['items'] != null) {
      final artists = data['artists']['items'];
      final names = artists
          .map((artist) => artist['name'].toString())
          .toList(); // Convert to List<String>
      setState(() {
        _suggestions = List<String>.from(names); // Convert to List<String>
      });
    } else {
      setState(() {
        _suggestions = []; // Clear the suggestions list
      });
    }
  }

  void _selectArtist(String artistName) async {
    // Call the Spotify API to search for the artist
    final token = await getSpotifyToken();
    var response = await http.get(
      Uri.parse(
        'https://api.spotify.com/v1/search?q=$artistName&type=artist&limit=1',
      ),
      headers: {'Authorization': token},
    );

    // Parse the response to extract the artist ID
    var data = json.decode(response.body);
    var artistId = data['artists']['items'][0]['id'];

    // Call the Spotify API to retrieve the artist's genres
    response = await http.get(
      Uri.parse('https://api.spotify.com/v1/artists/$artistId'),
      headers: {'Authorization': token},
    );

    // Parse the response to extract the artist's genres
    data = json.decode(response.body);
    var genres = data['genres'];

    // Update the dropdown items with the artist's genres
    setState(() {
      _searchController.text = artistName; 
      _genresList = genres.cast<String>();
      _suggestions.clear(); 
      _favoriteArtist = artistName;
    });
  }
}

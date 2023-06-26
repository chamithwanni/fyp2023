import base64
import json
import requests
import spotipy
from spotipy.oauth2 import SpotifyOAuth
import random
import string

SPOTIFY_TOKEN_ENDPOINT = 'https://accounts.spotify.com/api/token'
# Your Spotify API client ID and client secret
CLIENT_ID = 'd394d2eb5ad14357976ea46406f915f8'
CLIENT_SECRET = '6b692be0cf984932b58d5885fed59094'
REDIRECT_URL = 'http://localhost:8888/callback'

letters = string.ascii_lowercase
first = ''.join(random.choice(letters) for i in range(6))
second = ''.join(random.choice(letters) for i in range(6))


def get_artist_id(artist_name, token):
    response = requests.get(
        f'https://api.spotify.com/v1/search?type=artist&q={artist_name}',
        headers={
            'Authorization': f'Bearer {token}',
        },
    )

    artist_id = json.loads(response.content)['artists']['items'][0]['id']
    return artist_id


def get_top_tracks(artist_id, token):
    response = requests.get(
        f'https://api.spotify.com/v1/artists/{artist_id}/top-tracks?market=US',
        headers={
            'Authorization': f'Bearer {token}',
        },
    )

    tracks = json.loads(response.content)['tracks']
    track_ids = [track['id'] for track in tracks]
    return (track_ids)


def getArtistGenres(artistId, token):
    url = f'https://api.spotify.com/v1/artists/{artistId}'
    headers = {'Authorization': f'Bearer {token}'}
    response = requests.get(url, headers=headers)
    response_json = response.json()
    genres = response_json['genres']
    return genres

def get_mood_tracks(artist_id, genres, mood, token):
    url = 'https://api.spotify.com/v1/recommendations'
    params = {
        'seed_genres': ','.join(genres),
        'min_popularity': 50,
        'valence': mood,
        'seed_artists': artist_id,
        'market': 'US',
        'limit': 20,
        'offset': 0,
        'sort': artist_id,
        'order': 'asc'
    }
    headers = {'Authorization': f'Bearer {token}'}
    response = requests.get(url, params=params, headers=headers)
    if response.status_code == 200:
        response_json = response.json()
        tracks = response_json.get('tracks', [])
        track_ids = [track['id'] for track in tracks]
        return track_ids
    if response.status_code == 400:
        params_new = {
            'seed_genres': 'pop',
            'min_popularity': 50,
            'valence': mood,
            'seed_artists': artist_id,
            'market': 'US',
            'limit': 20,
            'offset': 0,
            'sort': artist_id,
            'order': 'asc'
        }
        response_new = requests.get(url, params=params_new, headers=headers)
        response_json = response_new.json()
        tracks = response_json.get('tracks', [])
        track_ids = [track['id'] for track in tracks]
        return track_ids
    else:
        print(f"Failed to get tracks with error {response.status_code}: {response.text}")
        return []


def create_playlist(playlist_name, track_ids):
    sp = spotipy.Spotify(auth_manager=SpotifyOAuth(
        client_id=CLIENT_ID, client_secret=CLIENT_SECRET, redirect_uri=REDIRECT_URL, scope="playlist-modify-private"))
    response = sp.user_playlist_create(
        user=sp.current_user()["id"], name=playlist_name, public=False)
    playlist_id = response['id']
    sp.playlist_add_items(playlist_id, track_ids)
    return playlist_id


def get_playlist_details(playlist_id):
    sp = spotipy.Spotify(
        auth_manager=SpotifyOAuth(client_id=CLIENT_ID, client_secret=CLIENT_SECRET, redirect_uri=REDIRECT_URL,
                                  scope="playlist-modify-private"))
    playlist = sp.user_playlist(user=sp.current_user()['id'], playlist_id=playlist_id)

    tracks_list = [f"{track['track']['name']} - {' & '.join([artist['name'] for artist in track['track']['artists']])}"
                   for track in playlist["tracks"]["items"]]
    return {
        "tracks": playlist["tracks"]["total"],
        "owner": playlist["owner"]["display_name"],
        "image_url": playlist["images"][0]["url"],
        "tracks_list": tracks_list
    }


def get_create_playlist(artist_name, genres, mood):
    AUTH_STRING = base64.b64encode((CLIENT_ID + ':' + CLIENT_SECRET).encode('utf-8')).decode('utf-8')
    headers = {'Authorization': f'Basic {AUTH_STRING}'}
    data = {'grant_type': 'client_credentials'}
    response = requests.post(SPOTIFY_TOKEN_ENDPOINT, headers=headers, data=data)
    access_token = response.json()['access_token']

    ar_id = get_artist_id(artist_name, access_token)
    tracks_ids = get_mood_tracks(ar_id, genres, mood, access_token)
    # print(tracks_ft)
    # playlist_id = create_playlist("Test Martin_6", tracks_ft)
    # print(playlist_id)
    playlist_id = create_playlist(f'{first}{second}', tracks_ids)
    return get_playlist_details(playlist_id)


if __name__ == "__main__":
   get_create_playlist()

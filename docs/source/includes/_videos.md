# Videos

## List Videos
```http
GET v1/videos HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
```
```http
HTTP/1.1 200 OK
Content-Length: 4567
{
  "videos": [
      {
        "id": 7,
        "title": "hhh",
        "description": "ohjoh",
        "confidentiality": "public",
        "thumb": "/system/videos/files/000/000/007/thumb/clydesdales_stock.mp4.jpg?1433964475",
        "mp4": "/system/videos/files/000/000/007/original/clydesdales_stock.mp4.mp4?1433964475",
        "file": "/system/videos/files/000/000/007/original/clydesdales_stock.mp4.mp4?1433964475",
        "file_meta": {
          "length": "0:00:19.47",
          "duration": 19.47,
          "fps": 29,
          "size": "1280x720",
          "width": 1280,
          "height": 720,
          "aspect": 1.7777777777777777,
          "audio_encode": "aac",
          "audio_bitrate": "48000 Hz",
          "audio_channels": "stereo"
        },
        "created_at": "2015-06-10T19:27:52Z",
        "updated_at": "2015-06-10T19:28:36Z",
        "tag_list": [
          "haha",
          "hello",
          "nature"
        ],
        "ogg": "/system/videos/files/000/000/007/ogg/clydesdales_stock.mp4.ogg?1433964475",
        "webm": "/system/videos/files/000/000/007/webm/clydesdales_stock.mp4.webm?1433964475",
        "view_count": 0,
        "slug": "hhh-e7e6fd49-01d4-4bfb-975d-475f170741c0",
        "small": "/system/videos/files/000/000/007/small/clydesdales_stock.mp4.jpg?1433964475",
        "poster": "/system/videos/files/000/000/007/poster/clydesdales_stock.mp4.mp4?1433964475",
        "page_views": 0,
        "user": {
          "id": 1,
          "email": "blabla@msn.com",
          "firstname": "chedli",
          "lastname": "bourguiba",
          "admin": false,
          "created_at": "2015-06-10T18:17:09Z",
          "updated_at": "2015-06-12T00:38:53Z",
          "avatar": "/system/users/avatars/000/000/001/original/Emna.jpg?1434042041",
          "username": null,
          "identity_url": null
        }
      },
      {
        "id": 6,
        "title": "hhh",
        "description": "ohjoh",
        "confidentiality": "public",
        "thumb": "/system/videos/files/000/000/006/thumb/clydesdales_stock.mp4.jpg?1433964366",
        "mp4": "/system/videos/files/000/000/006/original/clydesdales_stock.mp4.mp4?1433964366",
        "file": "/system/videos/files/000/000/006/original/clydesdales_stock.mp4.mp4?1433964366",
        "file_meta": {
          "length": "0:00:19.47",
          "duration": 19.47,
          "fps": 29,
          "size": "1280x720",
          "width": 1280,
          "height": 720,
          "aspect": 1.7777777777777777,
          "audio_encode": "aac",
          "audio_bitrate": "48000 Hz",
          "audio_channels": "stereo"
        },
        "created_at": "2015-06-10T19:26:03Z",
        "updated_at": "2015-06-10T19:26:47Z",
        "tag_list": [
          "haha",
          "hello",
          "nature"
        ],
        "ogg": "/system/videos/files/000/000/006/ogg/clydesdales_stock.mp4.ogg?1433964366",
        "webm": "/system/videos/files/000/000/006/webm/clydesdales_stock.mp4.webm?1433964366",
        "view_count": 0,
        "slug": "hhh-eb912da2-561b-4222-a2f2-4a921c4d4269",
        "small": "/system/videos/files/000/000/006/small/clydesdales_stock.mp4.jpg?1433964366",
        "poster": "/system/videos/files/000/000/006/poster/clydesdales_stock.mp4.mp4?1433964366",
        "page_views": 0,
        "user": {
          "id": 1,
          "email": "blabla@msn.com",
          "firstname": "chedli",
          "lastname": "bourguiba",
          "admin": false,
          "created_at": "2015-06-10T18:17:09Z",
          "updated_at": "2015-06-12T00:38:53Z",
          "avatar": "/system/users/avatars/000/000/001/original/Emna.jpg?1434042041",
          "username": null,
          "identity_url": null
        }
      }],
  "meta":{
    "current_page":1,
    "next_page":2,
    "prev_page":null,
    "total_pages":10,
    "total_count":300
  }
}
```

Vous pouvez GET les videos publiques dans /videos.
Vous pouvez filtrer par n'importe quel attribut.
Pour plus d'infos sur la micro API qui gere cela: cliquez: [ici](https://github.com/kollegorna/active_hash_relation).


## Upload une video
```http
POST v1/videos/upload HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1

{
  "video": {
    "title": "jjj",
    "description": null,
    "confidentiality": "public",
    "file": "CONTENT ENCODED"
  }
}
```
```http
HTTP/1.1 201 CREATED
Content-Length: 4567
{
  "video": {
    "title": "jjj",
    "description": null,
    "confidentiality": "public",
    "file": "/system/videos/files/000/000/017/original/2010-07-06_01.33.10.mp4?1434154489"
  }
},
```
Vous pouvez creer une video avec ces parametreS.
You can create a new user sending a POST to `v1/videos` with the necessary attributes.
A user object should at least include, an email, a password
Ceci requiert l authentification.


## Show a video
```http
GET v1/videos/1 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
```
```http
HTTP/1.1 200 OK
Content-Length: 4567
{
  "video": {
    "id": 1
    "title": "jjj",
    "description": null,
    "confidentiality": "public",
    "file": "/system/videos/files/000/000/017/original/2010-07-06_01.33.10.mp4?1434154489"
  }
},
```
You can retrieve a video's info by sending a GET request to `v1/videos/{id}`.


## Update a video
```http
PUT v1/videos/1 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
{
  "video": {
    "id": "12"
    "title": "jjj",
    "description": null,
    "confidentiality": "public",
    "file": "/system/videos/files/000/000/017/original/2010-07-06_01.33.10.mp4?1434154489"
  }
}
```
```http
HTTP/1.1 200 OK
Content-Length: 4567
{
  "video": {
    "id": 12
    "title": "jjj",
    "description": null,
    "confidentiality": "public",
    "file": "/system/videos/files/000/000/017/original/2010-07-06_01.33.10.mp4?1434154489"
  }
},
```
You can update a video's attributes by sending a PUT request to `v1/videos/{id}` with the necessary attributes.


## Destroy une video
```http
DELETE v1/videos/1 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
```
```http
HTTP/1.1 204 NO CONTENT

```

You get back a 204 no Content.

# Users

## List Users
```http
GET v1/users HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
```
```http
HTTP/1.1 200 OK
Content-Length: 4567
{
  "users":[
    {
      "id":1,
      "email":"example-88@railstutorial.org",
      "nickname":"Kenna Ondricka",

      "created_at":"2015-01-13T20:35:47Z",
      "updated_at":"2015-02-02T22:09:50Z"
    },
    {
      "id":1,
      "email":"example-89@railstutorial.org",
      "nickname":"Della Oberbrunner PhD",

      "created_at":"2015-01-13T20:35:47Z",
      "updated_at":"2015-02-02T22:09:50Z"
    }
  ],
  "meta":{
    "current_page":1,
    "next_page":2,
    "prev_page":null,
    "total_pages":10,
    "total_count":300
  }
}
```

You can GET all users in v1/users.
Vous pouvez filtrer par n'importe quel attribut.
Pour plus d'infos sur la micro API qui gere cela: cliquez: [ic](https://github.com/kollegorna/active_hash_relation).


## Creer un Utilisateur
```http
POST v1/users HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1

{
  "user": {
    "email":"example-88@railstutorial.org",
    "nickname":"Kenna Ondricka",
  }
}
```
```http
HTTP/1.1 200 OK
Content-Length: 4567
{
  "user": {
    "id":1,
    "email":"example-88@railstutorial.org",
    "nickname":"Kenna Ondricka",

    "created_at":"2015-01-13T20:35:47Z",
    "updated_at":"2015-02-02T22:09:50Z"
  }
},
```

You can create a new user sending a POST to `v1/users` with the necessary attributes.
A user object should at least include, an email, a password
It doesn't require authentication.


## Show a User
```http
GET v1/users/1 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
```
```http
HTTP/1.1 200 OK
Content-Length: 4567
{
  "user": {
    "id":1,
    "email":"example-88@railstutorial.org",
    "nickname":"An updated name",

    "created_at":"2015-01-13T20:35:47Z",
    "updated_at":"2015-02-02T22:09:50Z"
  }
},
```
You can retrieve a user's info by sending a GET request to `v1/users/{id}`.


## Update a User
```http
PUT v1/users/1 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
{
  "user": {
    "nickname":"An updated name",
  }
}
```
```http
HTTP/1.1 200 OK
Content-Length: 4567
{
  "user": {
    "id":1,
    "email":"example-88@railstutorial.org",
    "nickname":"An updated name",

    "created_at":"2015-01-13T20:35:47Z",
    "updated_at":"2015-02-02T22:09:50Z"
  }
},
```
You can update a user's attributes by sending a PUT request to `v1/users/{id}` with the necessary attributes.


## Destroy a User
```http
DELETE v1/users/1 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
```
```http
HTTP/1.1 204 NO CONTENT

```

You get back a 204 no Content.

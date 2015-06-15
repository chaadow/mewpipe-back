# Vue d'ensemble de l'API

## Notes générales
Il est conseillé de fournir un `user-agent` valide.

## Version Actuelle

La version actuelle de l'API est la V1. La version est définie soit dans le 'Accept header' soit au niveau de l'url.

- L'API est servie sous un sous domaine: `api.mewpipe.com`
  - Ceci permet au traffic d'etre **load balanced** au niveau  **DNS**
    - Cela veut dire que si l'API est sous une charge importante, on peut pointer le DNS de l'API a un autre ensemble de serveur et la "scale" independamment de l'application principale.

 - Pour des raison de simplicite et de facilite d'utilisation, et grace a l'implementation de la gem "versionist" gem nous allons implementer DEUX strategies:

   - La strategie du chemin (path strategy): La plus simple et la plus controverse, bien qu'elle soit utilisee par des gros acteurs du marche, qui permet de faire des requete sans des header specifiques, en specifiant le nom de la version dans l'url. Example: `api.mewpipe.com/v1/users/31342`
   -  La strategie Content negotiation via le Accept header:
      - C'est la solution la plus *restful*. Mais pas tres facile pour les clients. Parcequ'ils doivent specifier le header sur chaque requete.Neanmoins, c'est la solution la plus concise a implementer.
      - Cette strategie utilise un header HTTP pour demander une version speicifique de l'API
`Accept: application/vnd.mycompany.com; version=1,application/json`


Egalement, en pensant aux developpeurs qui vont utiliser notre API, cette derniere est configuree de sorte que la premiere version est celle par defaut.
Donc : `http://api.mewpipe.com/videos/123123` est  equivalent a `http://api.mewpipe.com/v1/videos/123123` pour les clients qui preferent utiliser la version par chemin.

```http
GET v1/resource HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
Host: api.mewpipe.com
```
```http
GET resource HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
Host: api.mewpipe.com
```
```http
GET resource HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
Host: api.mewpipe.com
```

## Generation du token
Le processus de generation du token est delege A `SecureRandom.uuid`. Cette methode fait partie de la bibliotheque standard et retourne un UUID(Universally Unique Identifier) qui est garanti d'etre unique sur un namespace global.
 Egalement nous enleve les '-' pour rendre le token plus 'user-friendly'.

De plus, nous faisons en sorte que l unicite du token se fasse au niveau DE LA BASE DE DONNEE en ajoutant un index unique au champ correspondant au token.
## Representations des dates time


Toutes les representations date/time sont au format ISO 8601.
```
YYYY-MM-DDTHH:MM:SSZ
```
Le timezone retourné est en UTC.

## Erreurs clients.
```http
HTTP/1.1 400 Bad Request
Content-Length: 35
{
  "message":"Problems parsing JSON"
}
```
```http
HTTP/1.1 422 Unprocessable Entity
Content-Length: 149
{
  "errors": [
    {
      "field": "title",
      "message": "title cannot be blank"
    },
    {
      "field": "description",
      "message": "description must be less than 1000 characters"
    },
  ]
}
```
```http
HTTP/1.1 401 Unauthorized
Content-Length: 149
{
  "message": "Authentication Failed",
}
```
```http
HTTP/1.1 403 Forbidden
Content-Length: 149
{
  "message": "Not authorized action for that resource",
}
```
```http
HTTP/1.1 500 Internal server error
Content-Length: 149
{
  "message": "Something went terribly wrong here.",
}
```

The client errors are pretty basic, yet helpful.

Error Code | Meaning
---------- | -------
400 | Bad Request -- You have a critical error on your request, like bad JSON representation
401 | Unauthorized -- You try to access a protected resource without providing authentication credentials or with wrong credentials
403 | Forbidden -- You try to access or act on a protected resource but your credentials that you provide do not authorize your action for that resource.
404 | Not Found -- The specified kitten could not be found
405 | Method Not Allowed -- You tried to access a kitten with an invalid method
406 | Not Acceptable -- You requested a format that isn't json
422 | lalala -- Your request is understood but you miss a required param, or part of your json is in wrong format (like sending an date object in an integer param)
429 | Too Many Requests -- Slown down! Follow the rate limits!
500 | Internal Server Error -- Something went terribly wrong, open a gihub issue :)


## Authentication

```http
POST v1/login HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
Host: api.mewpipe.com
{
  "user": {
    "email": "example@railstutorial.org",
    "password": "123123123"
  }
}
```
```http
HTTP/1.1 200 OK
Content-Type: application/vnd.mewpipe.com; version=1
{
  "auth_token": "TnQfBY1S/aMdO46sUfXx8mkPa4yxawqgaqVlD2YNzj19QlGI02eFIpoj9YaBtXm3efQZt5oXIQ6DpBw9gvuVGA",
  "email": "example@railstutorial.org",
  "id": 1
}
```

Pour pouvoir faire des requetes authentifiées, il faut d'abord recuperer le token, via le point de terminaison des sessions.


## Autorisation
```http
GET v1/resource HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
Host: api.mewpipe.com
Authorization: Token token="TnQfBY1S/aMdO46sUfXx8mkPa4yxawqgaqVlD2YNzj19QlGI02eFIpoj9YaBtXm3efQZt5oXIQ6DpBw9gvuVGA==", user_email="example@railstutorial.org"
```
```http
HTTP/1.1 200 OK
Content-Type: application/vnd.mewpipe.com; version=1
{
  "user":{
    "id":1,
    "email":"example@railstutorial.org",
    "nickname":"Example Use",
    "created_at":"2015-01-13T20:35:24Z",
    "updated_at":"2015-02-09T19:47:36Z"
  }
}
```
Vous pouvez vous authentifier à l'API en fournissant le token et l'email du user.



## Pagination
```http
GET v1/resource?page=2&per_page=100 HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.travis-ci.2+json
Host: api.mewpipe.com
```

Par defaut, les requetes qui retournent beaucoup de ressources vont etre paginés à 30.
Vous pouvez specifier d'autres pages en specifiant le `?page` parametre. Vous pouvez egalement etablir une taille customisé alant juqu'a 100 avec le `?per_page` parametre.

## Quota de requetes.
```http
HTTP/1.1 200 OK
Date: Mon, 01 Jul 2013 17:27:06 GMT
Status: 200 OK
X-Ratelimit-Limit: 100000
X-Ratelimit-Remaining: 99994
```
Vous pouvez verifier les headers HTTP de chaque requete d'API pour voir l etat actuel des requetes restantes a faire.
Il devrait etre note que la limite du quota est variable, dependant de la charge du serveur, veuillez donc respecter les limites.

Si les limites ont été enfreintes, vous allez recevoir une erreur 429 comme decrit dans la section des erreurs client.


## Cross Origin Resource Sharing (CORS)
Cette API comprend Cross Origin Resource Sharing (CORS) pour les requetes AJAX requests venant de n'importe quelle origine.

## Meta Data
```http
GET v1/resources HTTP/1.1
User-Agent: MyClient/1.0.0
Accept: application/vnd.mewpipe.com; version=1
```
```http
HTTP/1.1 200 OK
Content-Length: 4567
{
  "resources": [
    {
      "attribute1":1,
      "attribute2":"test-attribute 1",
    },
    {
      "attribute1":2
      "attribute2":"test-attribute 2"
    }
  ],
  "meta":{
    "current_page":45,
    "next_page":46,
    "prev_page":44,
    "total_pages":53,
    "total_count":105
  }
}
```
Dans chaque requete GET sur les ressources `/videos` par exemple, il y a un champ en plus avec la racine "meta".
Ce dernier inclut nottament, la page actuelle demandee, l'indice de la page suivante, la page precedente, le nombre total de page et le nombre total de la ressource en question.


## Autres informations
Quand une liste de ressource est demandée, l'ordre par defaut est par la date de creation en decroissant.

Pour chaque collection (de videos et de users notamment), une couche d'orchestration a ete utilisee, ce qui donne de multitude de fonctionnalite en plus. telle que le filtrage, la recherche par tags, les collection avant une date precise etc..

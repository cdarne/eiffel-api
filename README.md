# Eiffel API

Eiffel API est une API servant à gérer, exposer et répondre à des sondages.

## Architecture

Cette API tourne sous rails-api, une version de Ruby on Rails orientée création d'API.

### Web server: passenger

Passenger est une version allégée de nginx qui sert ici de reverse-proxy. Il se charge de la compression GZIP, sert
les fichiers assets (répertoire public) et gère un ou plusieurs process ruby selon la charge. Il gère également très bien
les clients lents (mobile avec une connexion lente) qui n'épuisent pas les connexions disponibles.

### Reverse-proxy caching: rack-cache / varnish

Pour obtenir les meilleures performances il faut tirer parti au maximum de l'HTTP caching.
L'API gère les headers Etag et Last-Modified de manière à servir les contenus
depuis le cache du client ou le reverse-proxy de cache, sans avoir à le re-générer par l'API.


## Installation

Tout d'abord il va falloir installer un version récente de ruby (2.x.x) et sqlite 3.

Installer bundler:

```bash
$ gem install bundler
```

Cloner le projet:

```bash
$ git clone git@github.com:cdarne/eiffel-api.git
$ cd eiffel-api
```

Installer les dépdendances du projet:

```bash
$ bundle install
```

Créer la base de données et appliquer les migrations:

```bash
$ rake db:migrate
```

(Optionnel) Charger des données de test dans la base:

```bash
$ rake db:seed
```

Enfin démarrer le serveur web:

```bash
$ rails s
```

L'API est alors disponible à l'URL [http://localhost:3000](http://localhost:3000).


## Tests unitaires

La suite de tests RSpec est disponible dans le repertoire `/spec`. Pour lancer les tests:

```bash
$ rspec spec
```

## Tests manuels

Des jeux de données sont situés dans le répertoire `/spec/fixtures`. Ces fichiers JSON
représente la modélisation des sondages de l'énoncé, ainsi que des exemples de réponses.

Voici les actions possibles avec l'API:

| Verb   | URI                      | Action
|--------|--------------------------|----------------
| GET    | /surveys.json            | Listes des sondages
| POST   | /surveys.json            | Création d'un sondage
| GET    | /surveys/:id.json        | Récupérer les informations d'un sondage
| DELETE | /surveys/:id.json        | Détruire un sondage
| POST   | /surveys/:id/answer.json | Répondre à une sondage 


### Liste des sondages

```bash
$ curl -X GET http://eiffel-api.herokuapp.com/surveys.json
```
```json
{
    "surveys": [
        {
            "id": 1,
            "description": "Template de Questionnaire pour l'association française de réputation des parisiens émigrés dans le monde. Copyright NosQuestions, VosRéponses Inc.",
            "questions": [
                {
                    "description": "Selon votre perception, notez de 1 à 5 votre appréciation de la réputation des parisiens (en général)",
                    "dependent_question": 2,
                    "question_type": "select",
                    "select_value": {
                        "multiple": false,
                        "values": [
                            "très amical, fait partie de ma famille",
                            "amical",
                            "neutre",
                            "assez inamical",
                            "odieux la plupart du temps"
                        ]
                    }
                },
                {
                    "description": "Sur tous les autres parisiens que vous connaissez, notez chaque de 1 à 5 selon votre appréciation",
                    "dependent_question": 2,
                    "question_type": "select",
                    "select_value": {
                        "multiple": false,
                        "values": [
                            "très amical, fait partie de ma famille",
                            "amical",
                            "neutre",
                            "assez inamical",
                            "odieux la plupart du temps"
                        ]
                    }
                },
                {
                    "description": "Sur tous les parisiens que vous connaissez, pour les {{questions[3].values[responses[3]]}} personnes les plus amicales, notez chaque de 1 à 5 selon votre appréciation",
                    "dependent_question": 2,
                    "question_type": "select",
                    "select_value": {
                        "multiple": false,
                        "values": [
                            "très amical, fait partie de ma famille",
                            "amical",
                            "neutre",
                            "assez inamical",
                            "odieux la plupart du temps"
                        ]
                    }
                },
                {
                    "description": "Combien de parisiens connaissez-vous ?",
                    "dependent_question": 1,
                    "question_type": "select",
                    "select_value": {
                        "multiple": false,
                        "values": [
                            "de 1 à 5",
                            "de 6 à 10",
                            "de 11 à 50",
                            "plus de 50"
                        ]
                    }
                },
                {
                    "description": "Connaissez-vous des français résidant à Paris ?",
                    "dependent_question": 0,
                    "question_type": "boolean"
                },
                {
                    "description": "Connaissez-vous des français ?",
                    "question_type": "boolean"
                }
            ]
        },
        {
            "id": 2,
            "description": "Template de Questionnaire pour l'association française de réputation des parisiens émigrés dans le monde. Copyright ParisMonAmi Inc.",
            "questions": [
                {
                    "description": "Adopteriez vous un parisiens comme ami ?",
                    "question_type": "boolean"
                },
                {
                    "description": "Selon vos connaissances, notez votre appréciation des parisiens :",
                    "question_type": "rating",
                    "rating_value": {
                        "min": 1,
                        "max": 5,
                        "step": 1,
                        "values": [
                            "respect des autres",
                            "ponctualité",
                            "politesse",
                            "acueillant",
                            "indifférent",
                            "français"
                        ]
                    }
                },
                {
                    "description": "Combien de parisiens considérez-vous comme plus que de simples connaissance ?",
                    "question_type": "input"
                },
                {
                    "description": "Combien de parisiens avez-vous dans vos connaissances ?",
                    "question_type": "input"
                }
            ]
        },
        {
            "id": 3,
            "description": "Template de Questionnaire pour l'association française de réputation des parisiens émigrés dans le monde. Copyright SondageMieux Inc.",
            "questions": [
                {
                    "description": "Dans le camembert graphique suivant, saisissez la proportion de chaque défaut que vous associez à un parisien :",
                    "question_type": "ratio",
                    "ratio_value": {
                        "values": [
                            "bavard",
                            "ennuyeux",
                            "stressé",
                            "prétentieux"
                        ]
                    }
                },
                {
                    "description": "Dans le camembert graphique suivant, saisissez la proportion de chaque qualité que vous associez à un parisien :",
                    "question_type": "ratio",
                    "ratio_value": {
                        "values": [
                            "sympathique",
                            "joyeux",
                            "chaleureux",
                            "généreux"
                        ]
                    }
                }
            ]
        }
    ]
}
```

### Afficher un sondage

```bash
$ curl -X GET http://eiffel-api.herokuapp.com/surveys/3.json
```
```json
{
    "survey": {
        "id": 3,
        "description": "Template de Questionnaire pour l'association française de réputation des parisiens émigrés dans le monde. Copyright SondageMieux Inc.",
        "questions": [
            {
                "description": "Dans le camembert graphique suivant, saisissez la proportion de chaque défaut que vous associez à un parisien :",
                "question_type": "ratio",
                "ratio_value": {
                    "values": [
                        "bavard",
                        "ennuyeux",
                        "stressé",
                        "prétentieux"
                    ]
                }
            },
            {
                "description": "Dans le camembert graphique suivant, saisissez la proportion de chaque qualité que vous associez à un parisien :",
                "question_type": "ratio",
                "ratio_value": {
                    "values": [
                        "sympathique",
                        "joyeux",
                        "chaleureux",
                        "généreux"
                    ]
                }
            }
        ]
    }
}
```

### Créer un sondage (avec un jeu de données)

```bash
curl -X POST -H "Content-Type: application/json" -d @spec/fixtures/NosQuestionsVosReponses.json http://eiffel-api.herokuapp.com/surveys.json
```

### Détruire un sondage

```bash
curl -X DELETE http://eiffel-api.herokuapp.com/surveys/4.json
```

### Répondre à un sondage (avec un jeu de données)

```bash
curl -X POST -H "Content-Type: application/json" -d @spec/fixtures/NosQuestionsVosReponses_response.json http://eiffel-api.herokuapp.com/surveys/1/answer.json
```


## Organisation du code

Ce projet adopte l'organisation classique d'un projet rails. Le code métier/fonctionnel le plus important se
situe dans `/app`. On y retrouve:

 * `controllers` : le controller qui s'occupe de faire le lien entre modèles et request
 * `models` : classes gérant la persistance, les validations simple et les relations entre modèles
 * `serializers` : la partie 'vue' de l'API, ces classes décrivent comment les modèles doivent être transformés en JSON
 * `services`: classes contenant la logique métier de l'application. Le but est de séparer le plus possible le code gèrant
               la persistance (modèles) et le requêtage (controller). Cela permet une conception classique orientée objet
               et découplée du framework rails : plus facile à tester, à maintenir, à réutiliser le code
               dans d'autres projets.

Enfin concernant le modèle de données, il y a le répertoire `/db` qui contient:
 * `migrate` : les migrations nécessaire à la création du schema de la DB, elle sont exécutées dans l'ordre des noms de fichiers
 * `schema.rb` : ce fichier synthétise toute la structure de base
 * `seeds.rb` : des données d'exemple
 
 
## Evolutions (scoring)

Pour gérer en temps les résultats des sondages et du scoring, une possibilité serait d'incrémenter ces données au fur et
à mesure de la réceptions des réponses aux sondages. Ces données vont changer très souvent, memcached ou redis seraient
des infrastructures adaptés ce genre de besoin.

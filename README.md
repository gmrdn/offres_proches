# OffresProches

**Petite API pour récupérer les offres dans un rayon donné à partir d'un ensemble d'offres au format csv**

## Installation

Démarrer le serveur
```
mix run --no-halt
```

## Configuration

Le port du serveur se configure dans ./config/config.exs

## Données

Les données sont à placer dans le fichier ./data/technical-test-jobs.csv


## Exemple

Les offres dans un rayon de 20 km de Marseille
```
curl -X GET http://localhost:4000/offres_proches?lat=43.2805546&lon=5.2400687&rad=20
```

# Projet 1 - Olist E-commerce Analytics

### Dashboard Power BI & analyse SQL d’une marketplace e-commerce

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-Analyse-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![DuckDB](https://img.shields.io/badge/DuckDB-Local%20Analytics-FFF000?style=for-the-badge&logo=duckdb&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-KPI%20%26%20Measures-742774?style=for-the-badge)
![Portfolio](https://img.shields.io/badge/Projet-Portfolio%20Data%20Analyst-2E86C1?style=for-the-badge)


## Sommaire

- [Présentation du projet](#présentation-du-projet)
- [Objectifs business](#objectifs-business)
- [Dataset utilisé](#dataset-utilisé)
- [Outils utilisés](#outils-utilisés)
- [Structure du projet](#structure-du-projet)
- [Modèle de données](#modèle-de-données)
- [Dashboard Power BI](#dashboard-power-bi)
- [Analyse SQL](#analyse-sql)
- [KPI principaux](#kpi-principaux)
- [Insights principaux](#insights-principaux)
- [Recommandations business](#recommandations-business)
- [Compétences démontrées](#compétences-démontrées)
- [Limites et pistes d’amélioration](#limites-et-pistes-damélioration)


## Présentation du projet

Ce projet analyse les données d’une marketplace e-commerce afin d’identifier les principaux leviers de performance commerciale, opérationnelle et client.

L’objectif est de construire une analyse complète, allant de la compréhension des données jusqu’à la création d’un dashboard Power BI, en passant par des requêtes SQL permettant de contrôler et reproduire les indicateurs clés.

Le projet couvre notamment :

- les ventes et le chiffre d’affaires ;
- les commandes et les clients ;
- les produits et catégories ;
- les délais de livraison ;
- la satisfaction client ;
- la performance géographique ;
- la contribution des vendeurs.


## Objectifs business

L’analyse cherche à répondre à plusieurs questions concrètes :

| Question business | Objectif analytique |
|---|---|
| Quel est le chiffre d’affaires généré par la marketplace ? | Mesurer la performance globale |
| Quelles catégories de produits rapportent le plus ? | Identifier les segments à forte valeur |
| Quelles catégories se vendent le plus en volume ? | Comprendre la demande produit |
| Les retards de livraison influencent-ils les notes clients ? | Relier performance opérationnelle et satisfaction |
| Quels États clients concentrent les ventes ? | Identifier les zones géographiques stratégiques |
| Quels vendeurs génèrent le plus de chiffre d’affaires ? | Repérer les vendeurs les plus performants |


## Dataset utilisé

Le projet utilise le dataset public **Brazilian E-Commerce Public Dataset by Olist**, disponible sur Kaggle :

> https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Le dataset contient plusieurs fichiers CSV liés entre eux, représentant une activité e-commerce réelle et anonymisée.

| Table | Rôle dans l’analyse |
|---|---|
| `orders` | Informations principales sur les commandes |
| `order_items` | Articles vendus dans chaque commande |
| `customers` | Localisation et identifiants clients |
| `products` | Informations produits et catégories |
| `category_translation` | Traduction des catégories produits |
| `reviews` | Notes et avis clients |
| `order_payments` | Informations de paiement |
| `sellers` | Informations vendeurs et localisation |


## Outils utilisés

| Outil | Utilisation |
|---|---|
| **Power BI Desktop** | Création du dashboard et des visualisations |
| **DAX** | Création des mesures KPI |
| **DBeaver** | Écriture et exécution des requêtes SQL |
| **DuckDB** | Analyse locale des fichiers CSV avec SQL |
| **CSV** | Format source des données |
| **GitHub** | Présentation et documentation du projet |


## Structure du projet

```text
Projet_1_Olist_Ecommerce_Analytics
│
├── data_raw
│   └── fichiers CSV originaux
│
├── data_clean
│   └── fichiers nettoyés si besoin
│
├── sql
│   ├── 00_create_views.sql
│   ├── 01_exploration_donnees.sql
│   ├── 02_kpi_business.sql
│   ├── 03_analyse_produits_categories.sql
│   ├── 04_analyse_livraison_satisfaction.sql
│   └── 05_analyse_geographie_vendeurs.sql
│
├── powerbi
│   └── olist_ecommerce_dashboard.pbix
│
├── screenshots
│   ├── 01_vue_ensemble.png
│   ├── 02_produits_categories.png
│   ├── 03_livraison_satisfaction.png
│   └── 04_geographie_vendeurs.png
│
├── documentation
│   └── 01_schema_donnees.md
│
└── README.md
```


## Modèle de données

Le modèle repose sur une logique relationnelle autour des commandes.

```text
customers
    │ customer_id
    ▼
orders
    │ order_id
    ▼
order_items
    ├── product_id → products → category_translation
    └── seller_id  → sellers

orders
    ├── order_id → order_payments
    └── order_id → reviews
```

### Relations principales

| Table source | Clé | Table cible | Clé | Rôle |
|---|---|---|---|---|
| `customers` | `customer_id` | `orders` | `customer_id` | Relier les commandes aux clients |
| `orders` | `order_id` | `order_items` | `order_id` | Relier les commandes aux articles vendus |
| `orders` | `order_id` | `reviews` | `order_id` | Relier les commandes aux avis clients |
| `orders` | `order_id` | `order_payments` | `order_id` | Relier les commandes aux paiements |
| `order_items` | `product_id` | `products` | `product_id` | Relier les ventes aux produits |
| `products` | `product_category_name` | `category_translation` | `product_category_name` | Traduire les catégories |
| `order_items` | `seller_id` | `sellers` | `seller_id` | Relier les ventes aux vendeurs |


## Dashboard Power BI

Le dashboard est composé de 4 pages principales.

### 1. Vue d’ensemble

Objectif : obtenir une vision globale de la performance de la marketplace.

Indicateurs présents :

- chiffre d’affaires total ;
- nombre de commandes ;
- nombre de clients uniques ;
- panier moyen ;
- note moyenne client ;
- évolution du chiffre d’affaires ;
- répartition des commandes par statut ;
- top catégories par chiffre d’affaires.

![Vue d’ensemble](screenshots/01_vue_ensemble.png)


### 2. Produits & Catégories

Objectif : identifier les catégories les plus performantes en chiffre d’affaires et en volume de vente.

Indicateurs présents :

- chiffre d’affaires produits ;
- articles vendus ;
- produits distincts vendus ;
- nombre de catégories ;
- prix moyen article ;
- top catégories par chiffre d’affaires produits ;
- top catégories par volume vendu ;
- comparaison entre chiffre d’affaires produits et frais de livraison.

![Produits & Catégories](screenshots/02_produits_categories.png)


### 3. Livraison & Satisfaction client

Objectif : analyser l’impact des délais de livraison sur les notes clients.

Indicateurs présents :

- délai moyen de livraison ;
- taux de retard ;
- commandes en retard ;
- note moyenne client ;
- taux d’avis positifs ;
- taux d’avis négatifs ;
- note moyenne selon le statut de livraison ;
- répartition des notes clients ;
- évolution des commandes en retard.

![Livraison & Satisfaction](screenshots/03_livraison_satisfaction.png)


### 4. Géographie & Vendeurs

Objectif : analyser la répartition géographique des clients et la performance des vendeurs.

Indicateurs présents :

- chiffre d’affaires par État client ;
- commandes par État client ;
- vendeurs actifs ;
- chiffre d’affaires moyen par vendeur ;
- top vendeurs par chiffre d’affaires produits ;
- répartition des vendeurs par État.

![Géographie & Vendeurs](screenshots/04_geographie_vendeurs.png)


## Analyse SQL

Une partie SQL a été réalisée avec **DuckDB** et **DBeaver** afin de vérifier les données et de reproduire les principaux indicateurs du dashboard.

| Fichier SQL | Objectif |
|---|---|
| `00_create_views.sql` | Création des vues SQL à partir des fichiers CSV |
| `01_exploration_donnees.sql` | Exploration initiale des tables |
| `02_kpi_business.sql` | Calcul des KPI business principaux |
| `03_analyse_produits_categories.sql` | Analyse des produits et catégories |
| `04_analyse_livraison_satisfaction.sql` | Analyse livraison et satisfaction client |
| `05_analyse_geographie_vendeurs.sql` | Analyse géographie et vendeurs |

### Exemple de requête SQL

```sql
SELECT
    ROUND(SUM(price + freight_value), 2) AS ca_total,
    COUNT(DISTINCT order_id) AS nb_commandes,
    ROUND(
        SUM(price + freight_value) / COUNT(DISTINCT order_id),
        2
    ) AS panier_moyen
FROM order_items;
```

Cette requête calcule trois KPI importants : le chiffre d’affaires total, le nombre de commandes et le panier moyen.


## KPI principaux

| Indicateur | Résultat observé |
|---|---:|
| Chiffre d’affaires total | ≈ 15,84M |
| Chiffre d’affaires produits | ≈ 13,59M |
| Frais de livraison | ≈ 2,25M |
| Nombre de commandes | ≈ 99K |
| Nombre de clients uniques | ≈ 96K |
| Panier moyen | ≈ 160,58 |
| Note moyenne client | ≈ 4,09 / 5 |
| Délai moyen de livraison | ≈ 12,50 jours |
| Taux de retard | ≈ 8,11 % |
| Taux d’avis positifs | ≈ 77 % |
| Taux d’avis négatifs | ≈ 14,69 % |

> Les valeurs peuvent légèrement varier selon les filtres appliqués et les choix de calcul utilisés dans Power BI ou SQL.


## Insights principaux

### Vue d’ensemble

- La marketplace génère un volume important de commandes et un chiffre d’affaires global élevé.
- Le panier moyen donne une première indication de la valeur moyenne générée par commande.
- La note moyenne client est supérieure à 4/5, ce qui indique une satisfaction globale positive.
- La majorité des commandes sont livrées, ce qui suggère un processus opérationnel globalement fiable.

### Produits & Catégories

- Certaines catégories concentrent une part importante du chiffre d’affaires produits.
- Les catégories les plus vendues en volume ne sont pas toujours celles qui génèrent le plus de revenus.
- Les frais de livraison varient selon les catégories et peuvent influencer la rentabilité réelle.

### Livraison & Satisfaction client

- Les commandes livrées à temps ou en avance obtiennent une meilleure note moyenne que les commandes en retard.
- Les retards ne représentent qu’une partie des commandes, mais ils semblent associés à une satisfaction client plus faible.
- La majorité des avis clients sont positifs, mais les avis négatifs restent à surveiller.

### Géographie & Vendeurs

- Le chiffre d’affaires et le volume de commandes sont concentrés dans quelques États clients.
- Certains vendeurs génèrent une part importante du chiffre d’affaires produits.
- La répartition des vendeurs par État peut avoir un impact sur la couverture logistique et les délais de livraison.


## Recommandations business

À partir de l’analyse, plusieurs actions peuvent être proposées :

1. **Prioriser les catégories à fort chiffre d’affaires** pour concentrer les efforts marketing sur les segments les plus rentables.
2. **Surveiller les catégories à fort volume mais à panier moyen plus faible**, afin d’identifier des opportunités d’amélioration de marge.
3. **Réduire les retards de livraison**, car les commandes en retard semblent associées à de moins bonnes notes clients.
4. **Analyser les États clients les plus performants** afin d’adapter les actions commerciales et logistiques par zone géographique.
5. **Suivre les vendeurs les plus performants** pour comprendre leurs bonnes pratiques et détecter une éventuelle dépendance à certains vendeurs clés.
6. **Étudier les frais de livraison par catégorie**, car ils peuvent influencer la rentabilité réelle des ventes.


## Compétences démontrées

Ce projet met en avant plusieurs compétences attendues chez un Data Analyst junior :

| Compétence | Mise en pratique dans le projet |
|---|---|
| Analyse business | Définition de questions métier et recommandations |
| SQL | Exploration, agrégations, jointures, CTE, KPI |
| Power BI | Création d’un dashboard multi-pages |
| DAX | Mesures de chiffre d’affaires, panier moyen, taux de retard, satisfaction |
| Modélisation | Relations entre tables clients, commandes, produits, avis et vendeurs |
| Data visualization | Graphiques adaptés aux questions business |
| Communication | Insights synthétiques et lisibles |
| Esprit analytique | Croisement entre ventes, livraison, satisfaction et géographie |


## Limites et pistes d’amélioration

Ce projet peut être enrichi avec plusieurs améliorations :

- créer une table calendrier dédiée pour améliorer les analyses temporelles ;
- ajouter une analyse plus détaillée des paiements ;
- intégrer une analyse géographique avancée avec latitude et longitude ;
- analyser les commentaires clients avec du traitement de texte ;
- comparer la performance des vendeurs selon les délais de livraison ;
- calculer des indicateurs de réachat client ;
- publier le dashboard via Power BI Service si nécessaire.


## Conclusion

Ce projet montre comment exploiter un dataset e-commerce complet pour produire une analyse claire, structurée et orientée décision.

Il combine une approche technique avec SQL et DAX, une partie visuelle avec Power BI, et une lecture business à travers des insights et recommandations.

L’objectif final est de fournir un support d’aide à la décision permettant de mieux comprendre la performance commerciale, l’expérience client et la dynamique marketplace.


**Projet réalisé dans le cadre d’un portfolio Data Analyst**

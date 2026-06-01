-- 01 - Exploration des données
-- Projet : Olist E-commerce Analytics
-- Objectif : Comprendre rapidement le contenu des table CSV


-- 1. Vérifier le nombre de lignes dans le table CSV
SELECT
    COUNT(*) AS nb_lignes_orders
FROM read_csv_auto('../data_raw/olist_order_items-dataset.csv');

-- 2. Vérifier le nombre de lignes dans la table order_items
SELECT
    COUNT(*) AS nb_lignes_order_items
FROM read_csv_auto('../data_raw/olist_order_items_dataset.csv');

-- 3. Vérifier le nombre de lignes dans la table customers
SELECT
    COUNT(*) AS nb_ligne_customers
from read_csv_auto('../data_raw/olist_customers_dataset.cvs');

-- 4. Afficher les 10 premières commandes
SELECT *
FROM read_csv_auto('../data_raw/olist_orders_dataset.csv');
LIMIT 10;

-- 5. Afficher les diffèrents statuts de commande
SELECT
    COUNT(*) AS nb_commandes
FROM read_csv_auto('../data_raw/olist_orders_dataset.csv')
GROUP BY order_status
ORDER BY nb_commandes DESC;

-- 6. Vérifier les commandes sans date de livraison réelle
SELECT
    COUNT(*) AS nb_commande_sans_livraison
FROM read_csv_auto('../data_raw/olist_orders_dataset.csv')
WHERE order_delivered_customer_date IS NULL;

-- 7. Vérifier les premières lignes de order_items
SELECT *
FROM read_csv_auto('../data_raw/olist_orders_dataset.csv')
LIMIT 10;

-- 8. Vérifier les prix minimum, maximum et moyen des articles
SELECT
    MIN(price) AS prix_minimum
    MAX(price) AS prix_maximum
    AVG(price) AS prix_moyen
FROM read_csv_auto('../data_raw/olist_orders_dataset.csv')

-- 9. Vérifier les notes clients disponibles
SELECT review_score,
    COUNT(*) AS nb_avis
FROM read_csv_auto('../data_raw/olist_orders_dataset.csv')
GROUP BY review_score
ORDER BY review_score;

-- 10. Vérifier les Etats clients les plus présents
SELECT customer_state,
    COUNT(*) AS nb_clients
FROM read_csv_auto('../data_raw/olist_customers_dataset.csv')
GROUP by customer_state
ORDER BY nb_clients DESC;
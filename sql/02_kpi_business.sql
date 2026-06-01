-- 02 - KPI business principaux
-- Projet : Olist E-commerce Analystics
-- Objectif : Calculer les indicateurs clés de la vue d'ensemble

-- 1. Chiffre d'affaires produits
SELECT 
    ROUND(SUM(price), 2) AS ca_produits
FROM order_items;

-- 2. Total des frais de livraison
SELECT
    ROUND(SUM(freight_value), 2) AS frais_livraisonn
FROM order_items;

-- 3. Chiffre d'affaires total : produits + livraison
SELECT
    ROUND(SUM(price + freight_value), 2) AS ca_total
FROM order_items;

-- 4. Nombre de commandes avec au moins un article
SELECT
    COUNT(DISTINCT order_id) AS nb_commandes
FROM order_items;

-- 5. Nombre de clients uniques
SELECT
    COUNT(DISTINCT customer_unique_id) AS nb_clients_uniques
FROM customers;

-- 6. Panier moyen
SELECT
    ROUND(
        SUM(price + freight_value) / COUNT(DISTINCT order_id),
        2
    ) AS panier_moyen
FROM order_items;

-- 7. Note moyenne client
SELECT
    ROUND(AVG(review_score), 2) AS note_moyenne_client
FROM reviews;

-- 8. Tous les KPI principaux dans une seule requête
WITH ventes AS (
    SELECT
        ROUND(SUM(price), 2) AS ca_produits,
        ROUND(SUM(freight_value), 2) AS frais_livraison,
        ROUND(SUM(price + freight_value), 2) AS ca_total,
        COUNT(DISTINCT order_id) AS nb_commandes,
        ROUND(
            SUM(price + freight_value) / COUNT(DISTINCT order_id),
            2
        ) AS panier_moyen
    FROM order_items
),

clients AS (
    SELECT
        COUNT(DISTINCT customer_unique_id) AS nb_clients_uniques
    FROM customers
),

avis AS (
    SELECT
        ROUND(AVG(review_score), 2) AS note_moyenne_client
    FROM reviews
)

SELECT
    ventes.ca_total,
    ventes.ca_produits,
    ventes.frais_livraison,
    ventes.nb_commandes,
    clients.nb_clients_uniques,
    ventes.panier_moyen,
    avis.note_moyenne_client
FROM ventes
CROSS JOIN clients
CROSS JOIN avis;
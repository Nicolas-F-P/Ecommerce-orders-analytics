-- 05 - Analyse géographie et vendeurs
-- Projet : Olist E-commerce Analytics
-- Objectif : Analyser la répartition géographique des clients et la performance des vendeurs


-- 1. Nombre d'États clients couverts
SELECT
    COUNT(DISTINCT customer_state) AS nb_etats_clients
FROM customers;


-- 2. Nombre de villes clientes couvertes
SELECT
    COUNT(DISTINCT customer_city) AS nb_villes_clients
FROM customers;


-- 3. Nombre de vendeurs actifs
SELECT
    COUNT(DISTINCT seller_id) AS nb_vendeurs_actifs
FROM order_items;


-- 4. Nombre d'États vendeurs couverts
SELECT
    COUNT(DISTINCT seller_state) AS nb_etats_vendeurs
FROM sellers;


-- 5. CA moyen par vendeur actif
SELECT
    ROUND(
        SUM(price) / COUNT(DISTINCT seller_id),
        2
    ) AS ca_moyen_par_vendeur_actif
FROM order_items;


-- 6. Top 10 États clients par chiffre d'affaires total
SELECT
    c.customer_state AS etat_client,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS ca_total,
    COUNT(DISTINCT o.order_id) AS nb_commandes,
    COUNT(DISTINCT c.customer_unique_id) AS nb_clients_uniques
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY ca_total DESC
LIMIT 10;


-- 7. Top 10 États clients par nombre de commandes
SELECT
    c.customer_state AS etat_client,
    COUNT(DISTINCT o.order_id) AS nb_commandes,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS ca_total,
    COUNT(DISTINCT c.customer_unique_id) AS nb_clients_uniques
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY nb_commandes DESC
LIMIT 10;


-- 8. Top 10 vendeurs par chiffre d'affaires produits
SELECT
    s.seller_id,
    s.seller_state,
    s.seller_city,
    ROUND(SUM(oi.price), 2) AS ca_produits,
    COUNT(DISTINCT oi.order_id) AS nb_commandes,
    COUNT(*) AS nb_articles_vendus,
    ROUND(AVG(oi.price), 2) AS prix_moyen_article
FROM order_items AS oi
LEFT JOIN sellers AS s
    ON oi.seller_id = s.seller_id
GROUP BY
    s.seller_id,
    s.seller_state,
    s.seller_city
ORDER BY ca_produits DESC
LIMIT 10;


-- 9. Répartition des vendeurs par État
SELECT
    seller_state AS etat_vendeur,
    COUNT(DISTINCT seller_id) AS nb_vendeurs
FROM sellers
GROUP BY seller_state
ORDER BY nb_vendeurs DESC;


-- 10. Chiffre d'affaires produits par État vendeur
SELECT
    s.seller_state AS etat_vendeur,
    ROUND(SUM(oi.price), 2) AS ca_produits,
    COUNT(DISTINCT s.seller_id) AS nb_vendeurs_actifs,
    COUNT(DISTINCT oi.order_id) AS nb_commandes,
    COUNT(*) AS nb_articles_vendus
FROM order_items AS oi
LEFT JOIN sellers AS s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
ORDER BY ca_produits DESC;


-- 11. KPI géographie et vendeurs dans une seule requête
WITH clients_geo AS (
    SELECT
        COUNT(DISTINCT customer_state) AS nb_etats_clients,
        COUNT(DISTINCT customer_city) AS nb_villes_clients
    FROM customers
),

vendeurs AS (
    SELECT
        COUNT(DISTINCT seller_id) AS nb_vendeurs_total,
        COUNT(DISTINCT seller_state) AS nb_etats_vendeurs
    FROM sellers
),

vendeurs_actifs AS (
    SELECT
        COUNT(DISTINCT seller_id) AS nb_vendeurs_actifs,
        ROUND(
            SUM(price) / COUNT(DISTINCT seller_id),
            2
        ) AS ca_moyen_par_vendeur_actif
    FROM order_items
),

ventes AS (
    SELECT
        ROUND(SUM(price + freight_value), 2) AS ca_total,
        COUNT(DISTINCT order_id) AS nb_commandes
    FROM order_items
)

SELECT
    ventes.ca_total,
    ventes.nb_commandes,
    clients_geo.nb_etats_clients,
    clients_geo.nb_villes_clients,
    vendeurs.nb_vendeurs_total,
    vendeurs.nb_etats_vendeurs,
    vendeurs_actifs.nb_vendeurs_actifs,
    vendeurs_actifs.ca_moyen_par_vendeur_actif
FROM ventes
CROSS JOIN clients_geo
CROSS JOIN vendeurs
CROSS JOIN vendeurs_actifs;
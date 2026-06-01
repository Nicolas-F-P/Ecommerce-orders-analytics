-- 03 - Analyse produits et catégories
-- Projet : Olist E-commerce Analytics
-- Objectif : Analyser les ventes par produit et par catégorie


-- 1. Nombre total d'articles vendus
SELECT
    COUNT(*) AS nb_articles_vendus
FROM order_items;

-- 2. Nombre de produits distincts vendus
SELECT
    COUNT(DISTINCT product_id) AS nb_produits_distincts
FROM order_items;

-- 3. Nombre de catégories produits disponibles
SELECT
    COUNT(DISTINCT product_category_name_english) AS nb_categories
FROM category_translation;

-- 4. Prix moyen d'un article vendu
SELECT
    ROUND(AVG(price), 2) AS prix_moyen_article
FROM order_items;

-- 5. KPI produits dans une seule requête
SELECT
    ROUND(SUM(price), 2) AS ca_produits,
    COUNT(*) AS nb_articles_vendus,
    COUNT(DISTINCT product_id) AS nb_produits_distincts,
    ROUND(AVG(price), 2) AS prix_moyen_article,
    ROUND(AVG(freight_value), 2) AS frais_livraison_moyen
FROM order_items;

-- 6. Top 10 catégories par chiffre d'affaires produits
SELECT
    ct.product_category_name_english AS categorie,
    ROUND(SUM(oi.price), 2) AS ca_produits,
    COUNT(*) AS nb_articles_vendus,
    COUNT(DISTINCT oi.product_id) AS nb_produits_distincts,
    ROUND(AVG(oi.price), 2) AS prix_moyen_article
FROM order_items AS oi
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation AS ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY ca_produits DESC
LIMIT 10;

-- 7. Top 10 catégories par volume vendu
SELECT
    ct.product_category_name_english AS categorie,
    COUNT(*) AS nb_articles_vendus,
    ROUND(SUM(oi.price), 2) AS ca_produit,
    ROUND(AVG(oi.price), 2) AS prix_moyen_article,
FROM order_items AS oi
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation AS ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY nb_articles_vendus DESC
LIMIT 10;

-- 8. CA produits et frais de livraison par catégorie
SELECT
    ct.product_category_name_english AS catégorie,
    ROUND(SUM(oi.price), 2) AS ca_produits,
    ROUND(SUM(oi.freight_value), 2) AS frais_livraison,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS ca_total,
    ROUND(AVG(oi.freight_value), 2) AS frais_livraison_moyen
FROM order_items AS oi
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation AS ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY ca_produits DESC
LIMIT 10;

-- 9. Catégories avec le prix moyen article le plus élevé
SELECT
    ct.product_category_name_english AS categorie,
    ROUND(AVG(oi.price), 2) AS prix_moyen_article,
    COUNT(*) AS nb_articles_vendus,
    ROUND(SUM(oi.price), 2) AS ca_produits
FROM order_items AS oi
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation AS ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
HAVING COUNT(*) >= 50
ORDER BY prix_moyen_article DESC
LIMIT 10;


-- 10. Catégories avec les frais de livraison moyens les plus élevés
SELECT
    ct.product_category_name_english AS categorie,
    ROUND(AVG(oi.freight_value), 2) AS frais_livraison_moyen,
    ROUND(AVG(oi.price), 2) AS prix_moyen_article,
    COUNT(*) AS nb_articles_vendus
FROM order_items AS oi
LEFT JOIN products AS p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation AS ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
HAVING COUNT(*) >= 50
ORDER BY frais_livraison_moyen DESC
LIMIT 10;
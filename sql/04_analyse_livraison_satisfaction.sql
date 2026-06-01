-- 04 - Analyse livraison et satisfaction client
-- Projet : Olist E-commerce Analytics
-- Objectif : Analyser l'impact des délais de livraison sur les avis clients


-- 1. Délai moyen de livraison en jours
SELECT
    ROUND(
        AVG(date_diff('day', order_purchase_timestamp, order_delivered_customer_date)),
        2
    ) AS delai_moyen_livraison_jours
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- 2. Nombre de commandes livrées
SELECT
    COUNT(DISTINCT order_id) AS nb_commande_livrees
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- 3. Nombre de commandes en retard
SELECT
    COUNT(DISTINCT order_id) AS nb_commandes_en_retard
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
    AND order_delivered_customer_date > order_estimate_delivery_date;

-- 4. Taux de retard de livraison
SELECT
    ROUND(
        100.0 *
        COUNT(DISTINCT CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN order_id
        END)
        / COUNT(DISTINCT CASE
            WHEN order_delivered_customer_date IS NOT NULL
            THEN order_id
        END),
        2
    ) AS taux_retard_livraison_pourcentage
FROM orders;

-- 5. Répartition des commandes par statut de livraison
SELECT
    CASE
        WHEN order_delivered_customer_date IS NULL THEN 'Non livrée'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'En retard'
        ELSE 'A temps / en avance'
    END AS statut_livraison,
    COUNT(DISTINCT order_id) AS nb_commandes
FROM orders
GROUP BY statut_livraison
ORDER BY nb_commandes DESC;

-- 6. Note moyenne selon le statut de livraison
SELECT
    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN 'Non livrée'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'En retard'
        ELSE 'A temps / en avance'
    END AS statut_livraison,
    ROUND(AVG(r.review_score), 2) AS note_moyenne_client,
    COUNT(DISTINCT o.order_id) AS nb_commandes
FROM orders AS o
LEFT JOIN reviews AS r
    ON o.order_id = r.order_id
GROUP BY statut_livraison
ORDER BY note_moyenne_client DESC;

-- 7. Répartition des notes clients
SELECT
    review_score,
    COUNT(*) AS nb_avis
FROM reviews
GROUP BY reviews_score
ORDER BY reviews_score;

-- 8. Taux d'avis positifs et négatifs
SELECT
    COUNT(*) AS nb_avis_total,
    ROUND(
        100.0 * COUNT(CASE WHEN review_score >= 4 THEN 1 END) / COUNT(*),
        2
    ) AS taux_avis_positifs_pourcentage,
    ROUND(
        100.0 * COUNT(CASE WHEN review_score <= 2 THEN 1 END) / COUNT(*),
        2
    ) AS taux_avis_negatifs_pourcentage
FROM reviews;

-- 9. Evolution annuelle des commandes en reatrd
SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS annee,
    COUNT(DISTINCT CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date
        THEN order_id
    END) AS nb_commandes_en_retard
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY annee
ORDER BY annee;

-- 10. Evolution mensuelle des commandes en retard
SELECT
    strftime(order_purchase_timestamp, '%Y-%m') AS mois,
    COUNT(DISTINCT CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date
        THEN order_id
    END) AS nb_commandes_en_retard
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY mois
ORDER BY mois;

-- 11. KPI livraison et satisfaction dans une seule requête
WITH livraison AS (
    SELECT
        ROUND(
            AVG(date_diff('day', order_purchase_timestamp, order_delivered_customer_date)),
            2
        ) AS delai_moyen_livraison_jours,

        COUNT(DISTINCT CASE
            WHEN order_delivered_customer_date IS NOT NULL
            THEN order_id
        END) AS nb_commandes_livrees,

        COUNT(DISTINCT CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN order_id
        END) AS nb_commandes_en_retard,

        ROUND(
            100.0 *
            COUNT(DISTINCT CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN order_id
            END)
            / COUNT(DISTINCT CASE
                WHEN order_delivered_customer_date IS NOT NULL
                THEN order_id
            END),
            2
        ) AS taux_retard_livraison_pourcentage
    FROM orders
),

satisfaction AS (
    SELECT
        ROUND(AVG(review_score), 2) AS note_moyenne_client,
        COUNT(*) AS nb_avis_total,
        ROUND(
            100.0 * COUNT(CASE WHEN review_score >= 4 THEN 1 END) / COUNT(*),
            2
        ) AS taux_avis_positifs_pourcentage,
        ROUND(
            100.0 * COUNT(CASE WHEN review_score <= 2 THEN 1 END) / COUNT(*),
            2
        ) AS taux_avis_negatifs_pourcentage
    FROM reviews
)

SELECT
    livraison.delai_moyen_livraison_jours,
    livraison.nb_commandes_livrees,
    livraison.nb_commandes_en_retard,
    livraison.taux_retard_livraison_pourcentage,
    satisfaction.note_moyenne_client,
    satisfaction.nb_avis_total,
    satisfaction.taux_avis_positifs_pourcentage,
    satisfaction.taux_avis_negatifs_pourcentage
FROM livraison
CROSS JOIN satisfaction;
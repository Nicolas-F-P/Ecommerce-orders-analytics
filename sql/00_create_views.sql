CREATE OR REPLACE VIEW orders AS
SELECT *
FROM read_csv_auto ("C:\Users\nicoc\Documents\portfolio_data_analyst\Project_Olist_E-commerce_Analytics\data_raw\olist_orders_dataset.csv");

CREATE OR REPLACE VIEW order_items AS
SELECT *
FROM read_csv_auto ("C:\Users\nicoc\Documents\portfolio_data_analyst\Project_Olist_E-commerce_Analytics\data_raw\olist_order_items_dataset.csv");

CREATE OR REPLACE VIEW order_payments AS
SELECT *
FROM read_csv_auto ("C:\Users\nicoc\Documents\portfolio_data_analyst\Project_Olist_E-commerce_Analytics\data_raw\olist_order_payments_dataset.csv");

CREATE OR REPLACE VIEW reviews AS
SELECT *
FROM read_csv_auto ("C:\Users\nicoc\Documents\portfolio_data_analyst\Project_Olist_E-commerce_Analytics\data_raw\olist_order_reviews_dataset.csv");

CREATE OR REPLACE VIEW customers AS
SELECT *
FROM read_csv_auto ("C:\Users\nicoc\Documents\portfolio_data_analyst\Project_Olist_E-commerce_Analytics\data_raw\olist_customers_dataset.csv");

CREATE OR REPLACE VIEW products AS
SELECT *
FROM read_csv_auto ("C:\Users\nicoc\Documents\portfolio_data_analyst\Project_Olist_E-commerce_Analytics\data_raw\olist_products_dataset.csv");

CREATE OR REPLACE VIEW sellers AS
SELECT *
FROM read_csv_auto ("C:\Users\nicoc\Documents\portfolio_data_analyst\Project_Olist_E-commerce_Analytics\data_raw\olist_sellers_dataset.csv");

CREATE OR REPLACE VIEW category_translation AS
SELECT *
FROM read_csv_auto ("C:\Users\nicoc\Documents\portfolio_data_analyst\Project_Olist_E-commerce_Analytics\data_raw\product_category_name_translation.csv");

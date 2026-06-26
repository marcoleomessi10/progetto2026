CREATE DATABASE IF NOT EXISTS shoe_store;

USE shoe_store;

CREATE TABLE IF NOT EXISTS users (
    id            INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         VARCHAR(20),
    role          ENUM('CUSTOMER', 'ADMIN') DEFAULT 'CUSTOMER',
    address       VARCHAR(255),
    city          VARCHAR(100),
    province      VARCHAR(100),
    zip_code      VARCHAR(20),
    postal_code   VARCHAR(20),
    active        TINYINT(1)   DEFAULT 1,
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(50)  NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS products (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    brand       VARCHAR(50)  NOT NULL,
    price       DECIMAL(10,2) NOT NULL,
    category    VARCHAR(50),
    stock       INT          NOT NULL DEFAULT 0,
    image       VARCHAR(255),
    image_path  VARCHAR(255),
    active      TINYINT(1)   DEFAULT 1,
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id               INT PRIMARY KEY AUTO_INCREMENT,
    user_id          INT           NOT NULL,
    order_date       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    total            DECIMAL(10,2) NOT NULL,
    shipping_address VARCHAR(255)  NOT NULL,
    payment_method   VARCHAR(50)   NOT NULL,
    status           ENUM('PROCESSING', 'SHIPPED', 'DELIVERED') DEFAULT 'PROCESSING',
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id             INT PRIMARY KEY AUTO_INCREMENT,
    order_id       INT           NOT NULL,
    product_id     INT,
    product_name   VARCHAR(100)  NOT NULL,
    product_brand  VARCHAR(50)   NOT NULL,
    size           INT           NOT NULL,
    purchase_price DECIMAL(10,2) NOT NULL,
    quantity       INT           NOT NULL,
    subtotal       DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(id)   ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL
);

INSERT IGNORE INTO users (first_name, last_name, email, password_hash, role) VALUES
('Marco',  'Manna',  'marco@shoestore.com',  '2084fcaf8c74cb75b4052259a2cf8a23:4b646bbcf5cd80ee3a2ea8f41144a12f2e4b10a04d0828c438ef577040fc6802', 'ADMIN'),
('Davide', 'Miele',  'davide@shoestore.com', '3da0506a36e42f6ad8eccd3ec653d90e:8c40feaf1cb570a2a02ffc81805e12f03782a6fb772ce0ae5c8953d7e2a0cd4e', 'ADMIN');

INSERT IGNORE INTO categories (id, name, description) VALUES
(1, 'Sneakers', 'Scarpe sportive'),
(2, 'Running',  'Scarpe da corsa'),
(3, 'Eleganti', 'Scarpe eleganti');

INSERT IGNORE INTO products (id, name, description, brand, price, category, stock, image, image_path, active) VALUES
(1,  'Air Force One',     'Sneaker sportiva comoda e leggera',                    'Nike',         129.99, 'Sneakers', 10, 'air-force-one.png',  'images/air-force-one.png',     1),
(2,  'Adidas Samba', 'Scarpa casual per tutti i giorni',                     'Adidas',        89.99, 'Sneakers', 15, 'adidas-samba.png', 'images/adidas-samba.png', 1),
(3,  'Asics Gel',        'Scarpa tecnica da running',                            'Asics',        119.99, 'Running',   8, 'asics-gel.png',     'images/asics-gel.png',        1),
(4,  'Geox Gladwin',  'Scarpa elegante nera in pelle',                        'Geox',         149.99, 'Eleganti',  6, 'geox-gladwin.png', 'images/geox-gladwin.png',  1),
(5,  'Nike Dunk',  'Sneaker casual comoda per tutti i giorni',             'Nike',          89.90, 'Sneakers', 17, 'nike-dunk.png',    'images/nike-dunk.png',  1),
(6,  'Adidas Adizero',    'Scarpa leggera pensata per la corsa su strada',        'Adidas',       119.50, 'Running',  12, 'adidas-adizero.png', 'images/adidas-adizero.png',    1),
(7,  'Geox Spherica',  'Scarpa elegante in stile derby per occasioni formali', 'Geox',         139.00, 'Eleganti',  7, 'geox-spherica.png','images/geox-spherica.png',  1),
(8,  'Puma Skyrocket',    'Sneaker urbana con suola ammortizzata',                'Puma',          74.99, 'Sneakers', 22, 'puma-skyrocket.png','images/puma-skyrocket.png',    1),
(9,  'Asics Excite 11', 'Scarpa running traspirante con buon supporto',         'Asics',        129.90, 'Running',  10, 'asics-excite-11.png', 'images/asics-excite-11.png', 1);

UPDATE products SET image = 'air-force-one.png', image_path = 'images/air-force-one.png' WHERE name = 'Air Force One';
UPDATE products SET image = 'adidas-samba.png', image_path = 'images/adidas-samba.png' WHERE name = 'Adidas Samba';
UPDATE products SET image = 'asics-gel.png', image_path = 'images/asics-gel.png' WHERE name = 'Asics Gel';
UPDATE products SET image = 'geox-gladwin.png', image_path = 'images/geox-gladwin.png' WHERE name = 'Geox Gladwin';
UPDATE products SET image = 'nike-dunk.png', image_path = 'images/nike-dunk.png' WHERE name = 'Nike Dunk';
UPDATE products SET image = 'adidas-adizero.png', image_path = 'images/adidas-adizero.png' WHERE name = 'Adidas Adizero';
UPDATE products SET image = 'geox-spherica.png', image_path = 'images/geox-spherica.png' WHERE name = 'Geox Spherica';
UPDATE products SET image = 'asics-excite-11.png', image_path = 'images/asics-excite-11.png' WHERE name = 'Asics Excite 11';
UPDATE products SET image = 'puma-skyrocket.png', image_path = 'images/puma-skyrocket.png' WHERE name = 'Puma Skyrocket';

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
('Marco',  'Manna',  'marco@shoestore.com',  'admin1', 'ADMIN'),
('Davide', 'Miele',  'davide@shoestore.com', 'admin1', 'ADMIN');

INSERT IGNORE INTO categories (id, name, description) VALUES
(1, 'Sneakers', 'Scarpe sportive'),
(2, 'Running',  'Scarpe da corsa'),
(3, 'Eleganti', 'Scarpe eleganti');

INSERT IGNORE INTO products (id, name, description, brand, price, category, stock, image, image_path, active) VALUES
(1,  'Air Runner',     'Sneaker sportiva comoda e leggera',                    'Nike',         129.99, 'Sneakers', 10, 'air-runner.png',     'images/air-runner.png',     1),
(2,  'Street Classic', 'Scarpa casual per tutti i giorni',                     'Adidas',        89.99, 'Sneakers', 15, 'street-classic.png', 'images/street-classic.png', 1),
(3,  'Run Pro',        'Scarpa tecnica da running',                            'Asics',        119.99, 'Running',   8, 'run-pro.png',        'images/run-pro.png',        1),
(4,  'Elegant Black',  'Scarpa elegante nera in pelle',                        'Geox',         149.99, 'Eleganti',  6, 'elegant-black.png',  'images/elegant-black.png',  1),
(5,  'Air Street 90',  'Sneaker casual comoda per tutti i giorni',             'Nike',          89.90, 'Sneakers', 17, 'air-street-90.png',  'images/air-street-90.png',  1),
(6,  'RunFlex Pro',    'Scarpa leggera pensata per la corsa su strada',        'Adidas',       119.50, 'Running',  12, 'runflex-pro.png',    'images/runflex-pro.png',    1),
(7,  'Classic Derby',  'Scarpa elegante in stile derby per occasioni formali', 'Geox',         139.00, 'Eleganti',  7, 'classic-derby.png',  'images/classic-derby.png',  1),
(8,  'Urban Pulse',    'Sneaker urbana con suola ammortizzata',                'Puma',          74.99, 'Sneakers', 22, 'urban-pulse.png',    'images/urban-pulse.png',    1),
(9,  'Marathon Light', 'Scarpa running traspirante con buon supporto',         'Asics',        129.90, 'Running',  10, 'marathon-light.png', 'images/marathon-light.png', 1);

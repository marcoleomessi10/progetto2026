CREATE DATABASE shoe_store;

USE shoe_store;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    ruolo ENUM('CLIENTE', 'ADMIN') DEFAULT 'CLIENTE',
    data_registrazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descrizione VARCHAR(255)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    data_ordine TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    totale DECIMAL(10,2) NOT NULL,
    indirizzo_spedizione VARCHAR(255) NOT NULL,
    metodo_pagamento VARCHAR(50) NOT NULL,
    stato ENUM(
        'IN_ELABORAZIONE',
        'SPEDITO',
        'CONSEGNATO'
    ) DEFAULT 'IN_ELABORAZIONE',
    FOREIGN KEY (user_id)
        REFERENCES users(id)
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    marca VARCHAR(50) NOT NULL,
    prezzo DECIMAL(10,2) NOT NULL,
    quantita_disponibile INT NOT NULL DEFAULT 0,
    numero_scarpa_min INT DEFAULT 36,
    numero_scarpa_max INT DEFAULT 46,
    genere ENUM('UOMO', 'DONNA', 'UNISEX') DEFAULT 'UNISEX',
    immagine VARCHAR(255),
    category_id INT,
    attivo BOOLEAN DEFAULT TRUE,
    data_creazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON DELETE SET NULL
);

INSERT INTO users (first_name, last_name, email, password_hash, role) VALUES
('Marco', 'Manna', 'marco@shoestore.com', 'admin1', 'ADMIN'),
('Davide', 'Miele', 'davide@shoestore.com', 'admin1', 'ADMIN');

INSERT INTO categories (id, name, description) VALUES
(1, 'Sneakers', 'Scarpe sportive'),
(2, 'Running',  'Scarpe da corsa'),
(3, 'Eleganti', 'Scarpe eleganti');

INSERT INTO products (id, name, description, brand, price, category, quantity, stock, image, image_path, active) VALUES
(1,  'Air Runner',    'Sneaker sportiva comoda e leggera',                    'Nike',        129.99, 'Sneakers', 10, 10, 'air-runner.png',    'images/air-runner.png',    1),
(2,  'Street Classic','Scarpa casual per tutti i giorni',                     'Adidas',       89.99, 'Sneakers', 15, 15, 'street-classic.png','images/street-classic.png', 1),
(3,  'Run Pro',       'Scarpa tecnica da running',                            'Asics',       119.99, 'Running',   8,  8, 'run-pro.png',       'images/run-pro.png',        1),
(4,  'Elegant Black', 'Scarpa elegante nera in pelle',                        'Geox',        149.99, 'Eleganti',  6,  6, 'elegant-black.png', 'images/elegant-black.png',  1),
(5,  'Air Street 90', 'Sneaker casual comoda per tutti i giorni',             'Nike',         89.90, 'Sneakers', 17, 17, 'air-street-90.png', 'images/air-street-90.png',  1),
(6,  'RunFlex Pro',   'Scarpa leggera pensata per la corsa su strada',        'Adidas',      119.50, 'Running',  12, 12, 'runflex-pro.png',   'images/runflex-pro.png',    1),
(7,  'Classic Derby', 'Scarpa elegante in stile derby per occasioni formali', 'Geox',        139.00, 'Eleganti',  7,  7, 'classic-derby.png', 'images/classic-derby.png',  1),
(8,  'Urban Pulse',   'Sneaker urbana con suola ammortizzata',                'Puma',         74.99, 'Sneakers', 22, 22, 'urban-pulse.png',   'images/urban-pulse.png',    1),
(9,  'Marathon Light','Scarpa running traspirante con buon supporto',         'Asics',       129.90, 'Running',  10, 10, 'marathon-light.png','images/marathon-light.png', 1),
(10, 'LV skate',      'non per i poveri',                                     'Luis Vuitton',1099.00,'Sneakers',  8,  8, 'shoe.jpg',          'images/shoe.jpg',           1);

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT,
    nome_prodotto VARCHAR(100) NOT NULL,
    marca_prodotto VARCHAR(50) NOT NULL,
    taglia INT NOT NULL,
    prezzo_acquisto DECIMAL(10,2) NOT NULL,
    quantita INT NOT NULL,
    subtotale DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE SET NULL
);
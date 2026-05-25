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
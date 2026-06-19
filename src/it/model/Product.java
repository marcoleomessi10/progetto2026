package it.model;

import java.sql.Timestamp;

public class Product {

    private int id;
    private String nome;
    private String descrizione;
    private String marca;
    private double prezzo;
    private int quantitaDisponibile;
    private int numeroScarpaMin;
    private int numeroScarpaMax;
    private String genere; 
    private String immagine;
    private String categoria;
    private int categoryId;
    private boolean attivo;
    private Timestamp dataCreazione;

    public Product() {}

    public int getId() { 
    	return id; 
    	}
    public void setId(int id) { 
    	this.id = id; 
    	}

    public String getNome() { 
    	return nome; 
    	}
    public void setNome(String nome) {
    	this.nome = nome; 
    	}

    public String getDescrizione() { 
    	return descrizione;
    	}
    public void setDescrizione(String descrizione) {
    	this.descrizione = descrizione;
    	}

    public String getMarca() {
    	return marca;
    	}
    public void setMarca(String marca) { 
    	this.marca = marca;
    	}

    public double getPrezzo() {
    	return prezzo;
    	}
    public void setPrezzo(double prezzo) { 
    	this.prezzo = prezzo;
    	}

    public int getQuantitaDisponibile() {
    	return quantitaDisponibile; 
    	}
    public void setQuantitaDisponibile(int quantitaDisponibile) {
        this.quantitaDisponibile = quantitaDisponibile;
    }

    public int getNumeroScarpaMin() { 
    	return numeroScarpaMin;
    	}
    public void setNumeroScarpaMin(int numeroScarpaMin) {
        this.numeroScarpaMin = numeroScarpaMin;
    }

    public int getNumeroScarpaMax() { 
    	return numeroScarpaMax; 
    	}
    public void setNumeroScarpaMax(int numeroScarpaMax) {
        this.numeroScarpaMax = numeroScarpaMax;
    }

    public String getGenere() { 
    	return genere; 
    	}
    public void setGenere(String genere) { 
    	this.genere = genere;
    	}

    public String getImmagine() {
    	return immagine; 
    	}
    public void setImmagine(String immagine) { 
    	this.immagine = immagine; 
    	}
    public String getCategoria() {
        return categoria;
        }
    public void setCategoria(String categoria) {
        this.categoria = categoria;
        }
    public int getCategoryId() {
    	return categoryId; 
    	}
    public void setCategoryId(int categoryId) {
    	this.categoryId = categoryId;
    	}

    public boolean isAttivo() {
    	return attivo; 
    	}
    public void setAttivo(boolean attivo) { 
    	this.attivo = attivo;
    	}

    public Timestamp getDataCreazione() { 
    	return dataCreazione;
    	}
    public void setDataCreazione(Timestamp dataCreazione) {
        this.dataCreazione = dataCreazione;
    }
}

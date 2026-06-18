package it.model;

import java.sql.Timestamp;

public class Order {

    private int id;
    private int userId;
    private Timestamp dataOrdine;
    private double totale;
    private String indirizzoSpedizione;
    private String metodoPagamento;
    private String stato;

    public Order() {}

    public int getId() { 
    	return id;
    	}
    public void setId(int id) {
    	this.id = id;
    	}

    public int getUserId() {
    	return userId;
    	}
    public void setUserId(int userId) {
    	this.userId = userId;
    	}

    public Timestamp getDataOrdine() { 
    	return dataOrdine; 
    	}
    public void setDataOrdine(Timestamp dataOrdine) {
    	this.dataOrdine = dataOrdine;
    	}

    public double getTotale() {
    	return totale; 
    	}
    public void setTotale(double totale) { 
    	this.totale = totale;
    	}

    public String getIndirizzoSpedizione() { 
    	return indirizzoSpedizione;
    	}
    public void setIndirizzoSpedizione(String indirizzoSpedizione) {
        this.indirizzoSpedizione = indirizzoSpedizione;
    }

    public String getMetodoPagamento() { 
    	return metodoPagamento; 
    	}
    public void setMetodoPagamento(String metodoPagamento) {
        this.metodoPagamento = metodoPagamento;
    }

    public String getStato() { 
    	return stato;
    	}
    public void setStato(String stato) { 
    	this.stato = stato;
    	}
}
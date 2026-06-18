package it.model;

public class Category {

    private int id;
    private String nome;
    private String descrizione;

    public Category() {}

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
}
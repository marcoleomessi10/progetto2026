package it.model;

public class OrderItem {

    private int id;
    private int orderId;
    private int productId;

    private String nomeProdotto;
    private String marcaProdotto;

    private int taglia;
    private double prezzoAcquisto;
    private int quantita;
    private double subtotale;

    public OrderItem() 
    {
    }

    public int getId() 
    { 
        return id; 
    }
    public void setId(int id) 
    { 
        this.id = id; 
    }

    public int getOrderId() 
    { 
        return orderId; 
    }
    public void setOrderId(int orderId) 
    { 
        this.orderId = orderId; 
    }

    public int getProductId() 
    { 
        return productId; 
    }
    public void setProductId(int productId) 
    { 
        this.productId = productId; 
    }

    public String getNomeProdotto() 
    { 
        return nomeProdotto; 
    }
    public void setNomeProdotto(String nomeProdotto) 
    { 
        this.nomeProdotto = nomeProdotto; 
    }

    public String getMarcaProdotto() 
    { 
        return marcaProdotto; 
    }
    public void setMarcaProdotto(String marcaProdotto) 
    { 
        this.marcaProdotto = marcaProdotto; 
    }

    public int getTaglia() 
    { 
        return taglia; 
    }
    public void setTaglia(int taglia) 
    { 
        this.taglia = taglia; 
    }

    public double getPrezzoAcquisto() 
    { 
        return prezzoAcquisto; 
    }
    public void setPrezzoAcquisto(double prezzoAcquisto) 
    { 
        this.prezzoAcquisto = prezzoAcquisto; 
    }

    public int getQuantita() 
    { 
        return quantita; 
    }
    public void setQuantita(int quantita) 
    { 
        this.quantita = quantita; 
    }

    public double getSubtotale() 
    { 
        return subtotale; 
    }
    public void setSubtotale(double subtotale) 
    { 
        this.subtotale = subtotale; 
    }
}

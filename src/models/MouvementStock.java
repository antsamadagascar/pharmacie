package models;

import java.sql.Date;

public class MouvementStock {
    private int idMouvement;
    private Produits produits;
    private String typeMouvement;
    private int quantite;
    private Date dateMouvement;

    public MouvementStock() {}

    public MouvementStock(int idMouvement,Produits produits,String typeMouvement,int quantite,Date dateMouvement) {
        this.idMouvement=idMouvement;
        this.produits=produits;
        this.typeMouvement=typeMouvement;
        this.quantite=quantite;
        this.dateMouvement=dateMouvement;
    }

    public int getIdMouvement() {
        return idMouvement;
    }

    public void setIdMouvement(int idMouvement) {
        this.idMouvement=idMouvement;
    }

    public Produits getProduits() {
        return produits;
    }

    public void setProduits(Produits produits) {
        this.produits=produits;
    }

    public String getTypeMouvement() {
        return typeMouvement;
    }

    public void setTypeMouvement(String typeMouvement) {
        this.typeMouvement=typeMouvement;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite=quantite;
    }
    
    public Date getDateMouvement() {
        return dateMouvement;
    }

    public void setDateMouvement(Date dateMouvement) {
        this.dateMouvement=dateMouvement;
    }

}

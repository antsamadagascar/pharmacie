package models;

import java.math.BigDecimal;
import java.sql.Date;

public class Achats {
    private int idAchat;
    private Produits produits;
    private int quantiteAchat;
    private BigDecimal prixAchat;
    private Date dateAchat;
    private Unites unites;

    public Achats() {}

    public Achats(int idAchat,Produits produits,int quantiteAchat,BigDecimal prixAchat,Date dateAchat,Unites unites) {
        this.idAchat = idAchat;
        this.produits = produits;
        this.quantiteAchat = quantiteAchat;
        this.prixAchat=prixAchat;
        this.dateAchat =dateAchat;
        this.unites=unites;
    }

    public int getIdAchat() {
        return idAchat;
    }

    public void setIdAchat(int idAchat) {
        this.idAchat=idAchat;
    }
    
    public Produits getProduits() {
        return produits;
    }

    public void setProduits(Produits produits) {
        this.produits=produits;
    }

    public int getQuantiteAchat() {
        return quantiteAchat;
    }

    public void setQuantiteAchat(int quantiteAchat) {
        this.quantiteAchat=quantiteAchat;
    }

    public BigDecimal getPrixAchat() {
        return prixAchat;
    }

    public void setPrixAchat(BigDecimal prixAchat) {
        this.prixAchat = prixAchat;
    }

    public Date getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(Date dateAchat) {
        this.dateAchat=dateAchat;
    }

    public Unites getUnites() {
        return unites;
    }

    public void setUnites(Unites unites) {
        this.unites = unites;
    }

}

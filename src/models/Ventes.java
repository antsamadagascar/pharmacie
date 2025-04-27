package models;

import java.math.BigDecimal;
import java.sql.Date;

public class Ventes {
    private int idVente;
    private Date dateVente;
    private Produits produits;
    private int quantite;
    private BigDecimal prixTotal;
    private Client client;
    private Medicament medicament;
    private Vendeur vendeur;

    public Ventes() {};

    public Ventes(int idVente, Date dateVente, Produits produits, int quantite, BigDecimal prixTotal, Client client,Vendeur vendeur) {
        this.idVente = idVente;
        this.dateVente = dateVente;
        this.produits = produits;
        this.quantite = quantite;
        this.prixTotal = prixTotal;
        this.client = client;
        this.vendeur = vendeur;
    }

    public int getIdVente() {
        return idVente;
    }

    public void setIdVente(int idVente) {
        this.idVente = idVente;
    }

    public Date getDateVente() {
        return dateVente;
    }

    public void setDateVente(Date dateVente) {
        this.dateVente = dateVente;
    }

    public Produits getProduits() {
        return produits;
    }

    public void setProduits(Produits produits) {
        this.produits = produits;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }

    public BigDecimal getPrixTotal() {
        return prixTotal;
    }

    public void setPrixTotal(BigDecimal prixTotal) {
        this.prixTotal = prixTotal;
    }

    public Client getClient() {
        return client;
    }

    public void setClient(Client client) {
        this.client = client;
    }

    public Medicament getMedicament() {
        return medicament;

    }

    public void setMedicament(Medicament medicament) {
        this.medicament=medicament;
    }

    public Vendeur getVendeur() {
        return vendeur;
    }

    public void setVendeur(Vendeur vendeur) {
        this.vendeur = vendeur;
    }
}

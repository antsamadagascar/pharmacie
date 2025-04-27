package models;

import java.sql.Date;

public class HistoriquePrix {
    private int idHistorique;
    private Produits produit;
    private double ancienPrix;
    private double nouveauPrix;
    private Date dateChangement;
    private String raison;
    private Stock stock;

    public HistoriquePrix() {
    }

    public HistoriquePrix(int idHistorique, Produits produit, double ancienPrix, 
            double nouveauPrix, Date dateChangement, String raison) {
        this.idHistorique = idHistorique;
        this.produit = produit;
        this.ancienPrix = ancienPrix;
        this.nouveauPrix = nouveauPrix;
        this.dateChangement = dateChangement;
        this.raison = raison;
    }


    public int getIdHistorique() {
        return idHistorique;
    }

    public void setIdHistorique(int idHistorique) {
        this.idHistorique = idHistorique;
    }

    public Produits getProduit() {
        return produit;
    }

    public void setProduit(Produits produit) {
        this.produit = produit;
    }

    public double getAncienPrix() {
        return ancienPrix;
    }

    public void setAncienPrix(double ancienPrix) {
        this.ancienPrix = ancienPrix;
    }

    public double getNouveauPrix() {
        return nouveauPrix;
    }

    public void setNouveauPrix(double nouveauPrix) {
        this.nouveauPrix = nouveauPrix;
    }

    public Date getDateChangement() {
        return dateChangement;
    }

    public void setDateChangement(Date dateChangement) {
        this.dateChangement = dateChangement;
    }

    public String getRaison() {
        return raison;
    }

    public void setRaison(String raison) {
        this.raison = raison;
    }

    public Stock getStock() {
        return stock;
    }

    public void setStock(Stock stock) {
        this.stock = stock;
    }

    public double getVariationPourcentage() {
        if (ancienPrix == 0) return 0;
        return ((nouveauPrix - ancienPrix) / ancienPrix) * 100;
    }

    @Override
    public String toString() {
        return "HistoriquePrix{" +
                "idHistorique=" + idHistorique +
                ", produit=" + produit +
                ", ancienPrix=" + ancienPrix +
                ", nouveauPrix=" + nouveauPrix +
                ", dateChangement=" + dateChangement +
                ", raison='" + raison + '\'' +
                ", stock=" + stock +
                '}';
    }
}
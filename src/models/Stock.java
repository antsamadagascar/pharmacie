package models;

import java.sql.Timestamp;

public class Stock {

    private int idStock;
    private Produits produit;
    private Timestamp  dateMisAjour;
    private int quantite;
    private int entree;
    private int sortie;
    private int reste;
    private Unites unite;

    public Stock() {}

    public Stock(int idStock, Produits produit, Timestamp  dateMisAjour, 
                 int quantite, int entree, int sortie, Unites unite) {
        this.idStock = idStock;
        this.produit = produit;
        this.dateMisAjour = dateMisAjour;
        this.quantite = quantite;
        this.entree = entree;
        this.sortie = sortie;
        this.reste = entree - sortie; 
        this.unite = unite;
    }

    public int getIdStock() {
        return idStock;
    }

    public void setIdStock(int idStock) {
        this.idStock = idStock;
    }

    public Produits getProduit() {
        return produit;
    }

    public void setProduit(Produits produit) {
        this.produit = produit;
    }

    public Timestamp  getDateMisAjour() {
        return dateMisAjour;
    }

    public void setDateMisAjour(Timestamp  dateMisAjour) {
        this.dateMisAjour = dateMisAjour;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }

    public int getEntree() {
        return entree;
    }

    public void setEntree(int entree) {
        this.entree = entree;
        this.reste = entree - this.sortie; 
    }

    public int getSortie() {
        return sortie;
    }

    public void setSortie(int sortie) {
        this.sortie = sortie;
        this.reste = this.entree - sortie; 
    }

    public int getReste() {
        return reste;
    }

    public void setReste(int reste) {
        this.reste = reste;
    }

    public Unites getUnite() {
        return unite;
    }

    public void setUnite(Unites unite) {
        this.unite = unite;
    }

    @Override
    public String toString() {
        return "Stock{" +
                "idStock=" + idStock +
                ", produit=" + produit +
                ", dateMisAjour=" + dateMisAjour +
                ", quantite=" + quantite +
                ", entree=" + entree +
                ", sortie=" + sortie +
                ", reste=" + reste +
                ", unite=" + unite +
                '}';
    }
}

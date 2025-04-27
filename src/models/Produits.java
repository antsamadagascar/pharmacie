package models;

public class Produits {
    private int idProduit;
    private TypeProduit typeProduit;
    private Categorie categorie;
    private String nomProduit;
    private double prixUnitaire;

    public Produits() {}

    public Produits(int idProduit, TypeProduit typeProduit, Categorie categorie, String nomProduit, double prixUnitaire) {
        this.idProduit = idProduit;
        this.typeProduit = typeProduit;
        this.categorie = categorie;
        this.nomProduit = nomProduit;
        this.prixUnitaire = prixUnitaire;
    }

    public int getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(int idProduit) {
        this.idProduit = idProduit;
    }

    public TypeProduit getTypeProduit() {
        return typeProduit;
    }

    public void setTypeProduit(TypeProduit typeProduit) {
        this.typeProduit = typeProduit;
    }

    public Categorie getCategorie() {
        return categorie;
    }

    public void setCategorie(Categorie categorie) {
        this.categorie = categorie;
    }

    public String getNomProduit() {
        return nomProduit;
    }

    public void setNomProduit(String nomProduit) {
        this.nomProduit = nomProduit;
    }

    public double getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }

}

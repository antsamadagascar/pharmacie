package models;

public class Vendeur {
    private int idVendeur;
    private String nom;
    private String prenom;

    public Vendeur() {} ;
    public Vendeur(int idVendeur, String nom, String prenom) {
        this.idVendeur = idVendeur;
        this.nom = nom;
        this.prenom = prenom;
    }

    public int getIdVendeur() {
        return idVendeur;
    }

    public void setIdVendeur(int idVendeur) {
        this.idVendeur = idVendeur;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
}

package models;

public class TypeProduit {
    private int idTypeProduit;
    private String nomType;

    public TypeProduit() {}

    public TypeProduit(int idTypeProduit, String nomType) {
        this.idTypeProduit = idTypeProduit;
        this.nomType = nomType;
    }

    public TypeProduit(String nomType) {
        this.nomType = nomType;
    }

    public int getIdTypeProduit() {
        return idTypeProduit;
    }

    public void setIdTypeProduit(int idTypeProduit) {
        this.idTypeProduit = idTypeProduit;
    }

    public String getNomType() {
        return nomType;
    }

    public void setNomType(String nomType) {
        this.nomType = nomType;
    }
}

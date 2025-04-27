package models;

public class Unites {
    int idUnite;
    String nomUnite;

    public Unites() {}

    public Unites(int idUnite,String nomUnite) {
        this.idUnite=idUnite;
        this.nomUnite=nomUnite;
    }

    public int getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(int idUnite) {
        this.idUnite=idUnite;
    }

    public String getNomUnite() {
        return nomUnite;
    }    

    public void setNomUnite(String nomUnite) {
        this.nomUnite = nomUnite;
    }
}

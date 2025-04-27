package models;

public class TypeAdministration {
    private int idTypeAdmin;
    private String nomType;
    private String description;

    public TypeAdministration() {}
    public TypeAdministration(int idTypeAdmin, String nomType, String description) {
        this.idTypeAdmin = idTypeAdmin;
        this.nomType = nomType;
        this.description = description;
    }

    public int getIdTypeAdmin() {
        return idTypeAdmin;
    }

    
    public void setIdTypeAdmin(int idTypeAdmin) {
        this.idTypeAdmin = idTypeAdmin;
    }

    public String getNomType() {
        return nomType;
    }

    
    public void setNomType(String nomType) {
        this.nomType = nomType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

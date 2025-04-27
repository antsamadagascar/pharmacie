package models;

public class TypeMaladie {
    private int idTypeMaladie;
    private String nomMaladie;
    private String description;

    public TypeMaladie() {}
    public TypeMaladie(int idTypeMaladie, String nomMaladie, String description) {
        this.idTypeMaladie = idTypeMaladie;
        this.nomMaladie = nomMaladie;
        this.description = description;
    }

    public int getIdTypeMaladie() {
        return idTypeMaladie;
    }

    public void setIdTypeMaladie(int idTypeMaladie) {
        this.idTypeMaladie = idTypeMaladie;
    }

    public String getNomMaladie() {
        return nomMaladie;
    }

    public void setNomMaladie(String nomMaladie) {
        this.nomMaladie = nomMaladie;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "TypeMaladie{idTypeMaladie=" + idTypeMaladie + ", nomMaladie='" + nomMaladie + "', description='" + description + "'}";
    }
}



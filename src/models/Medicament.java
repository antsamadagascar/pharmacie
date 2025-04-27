package models;

import java.util.List;

public class Medicament {
    private int idMedicament;
    private TypeAdministration typeAdmin;
    private GroupeAge groupeAge;
    private Produits produit;
    private List<TypeMaladie> typesMaladies;



    public Medicament() {}

    public Medicament(int idMedicament, TypeAdministration typeAdmin, GroupeAge groupeAge, Produits produit) {
        this.idMedicament = idMedicament;
        this.typeAdmin = typeAdmin;
        this.groupeAge = groupeAge;
        this.produit = produit;
    }

    public int getIdMedicament() {
        return idMedicament;
    }

    public void setIdMedicament(int idMedicament) {
        this.idMedicament = idMedicament;
    }

    public TypeAdministration getTypeAdmin() {
        return typeAdmin;
    }

    public void setTypeAdmin(TypeAdministration typeAdmin) {
        this.typeAdmin = typeAdmin;
    }

    public GroupeAge getGroupeAge() {
        return groupeAge;
    }

    public void setGroupeAge(GroupeAge groupeAge) {
        this.groupeAge = groupeAge;
    }

    public Produits getProduit() {
        return produit;
    }

    public void setProduit(Produits produit) {
        this.produit = produit;
    }

  
    public List<TypeMaladie> getTypesMaladies() {
        return typesMaladies;
    }

    public void setTypesMaladies(List<TypeMaladie> typesMaladies) {
        this.typesMaladies = typesMaladies;
    }
}


package models;

public class GroupeAge {
    private int idGroupeAge;
    private String nomGroupe;
    private int ageMin;
    private int ageMax;

    public GroupeAge() {}
    public GroupeAge(int idGroupeAge, String nomGroupe, int ageMin, int ageMax) {
        this.idGroupeAge = idGroupeAge;
        this.nomGroupe = nomGroupe;
        this.ageMin = ageMin;
        this.ageMax = ageMax;
    }

    public int getIdGroupeAge() {
        return idGroupeAge;
    }

    public void setIdGroupeAge(int idGroupeAge) {
        this.idGroupeAge = idGroupeAge;
    }

    public String getNomGroupe() {
        return nomGroupe;
    }

    public void setNomGroupe(String nomGroupe) {
        this.nomGroupe = nomGroupe;
    }

    public int getAgeMin() {
        return ageMin;
    }

    public void setAgeMin(int ageMin) {
        this.ageMin = ageMin;
    }

    public int getAgeMax() {
        return ageMax;
    }

    public void setAgeMax(int ageMax) {
        this.ageMax = ageMax;
    }
}

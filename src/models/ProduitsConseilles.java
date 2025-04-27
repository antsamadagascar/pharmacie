package models;
import java.sql.Date; 

public class ProduitsConseilles {
    private int idConseil;
    private Produits produits;
    private Stock stock; 
    private Date moisConseil;
    private String description;
    private String raison;

    public ProduitsConseilles() {}

    public ProduitsConseilles(Produits produits, Stock stock, Date moisConseil, String description, String raison) {
        this.produits = produits;
        this.stock = stock;
        this.moisConseil = moisConseil;
        this.description = description;
        this.raison = raison;
    }

    public int getIdConseil() {
        return idConseil;
    }

    public void setIdConseil(int idConseil) {
        this.idConseil = idConseil;
    }

    public Produits getProduits() {
        return produits;
    }

    public void setProduits(Produits produits) {
        this.produits = produits;
    }

    public Stock getStock() {
        return stock;
    }

    public void setStock(Stock stock) {
        this.stock = stock;
    }

    public Date getMoisConseil() {
        return moisConseil;
    }

    public void setMoisConseil(Date moisConseil) {
        this.moisConseil = moisConseil;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
   
    public String getRaison() {
        return raison;
    }

    public void setRaison(String raison) {
        this.raison = raison;
    }
}
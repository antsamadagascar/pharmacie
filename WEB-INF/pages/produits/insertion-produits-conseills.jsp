<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Insertion des Produits</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
</head>
<style>
    .container{
        margin-top: 100px;
    }
</style>
<body>
    <%
        ProduitDAO produitsDAO = new ProduitDAO();
        List<Produits> produits= produitsDAO.getAllProduits();
    %>
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-plus me-2"></i>Insertion des Produits
                </h2>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <button type="button" class="btn btn-primary" id="addProductRow">
                        <i class="fas fa-plus me-2"></i>Ajouter un produit
                    </button>
                </div>
                <form id="productsForm">
                    <div id="productsContainer">
            
                    </div>
                    <button type="submit" class="btn btn-success mt-3">
                        <i class="fas fa-save me-2"></i>Enregistrer tous les produits
                    </button>
                </form>
            </div>
        </div>
    </div>

    <template id="productRowTemplate">
        <div class="row product-row mb-3">
            <div class="col-md-3">
                <select class="form-select" name="idProduit" required>
                    <option value="">Sélectionner un Produit</option>
                    <% for(Produits produit : produits) { %>
                        <option value="<%= produit.getIdProduit() %>"><%= produit.getNomProduit() %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <input type="date" class="form-control" name="moisConseil" required>
                </div>
            </div>
            <div class="col-md-2">
                <input type="text" class="form-control" name="description" placeholder="Description" required>
            </div>

            <div class="col-md-2">
                <input type="text" class="form-control" name="raison" placeholder="Raison">
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-danger remove-row">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        </div>
    </template>

    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#addProductRow').click(function() {
                const template = document.getElementById('productRowTemplate');
                const clone = template.content.cloneNode(true);
                document.getElementById('productsContainer').appendChild(clone);
            });

            $(document).on('click', '.remove-row', function() {
                $(this).closest('.product-row').remove();
            });

            $('#productsForm').on('submit', function(e) {
    e.preventDefault();

    const produitsConseilles = [];
    $('.product-row').each(function() {
        const row = $(this);
        const moisConseil = row.find('[name="moisConseil"]').val(); 
        const description = row.find('[name="description"]').val();
        const raison = row.find('[name="raison"]').val();
        const idProduit = parseInt(row.find('[name="idProduit"]').val()); 

        if (isNaN(idProduit) || idProduit === '') {
            alert('L\'ID du produit est manquant ou invalide.');
            return;
        }

        if (!moisConseil) {
            alert('La date du conseil est requise.');
            return;
        }

        produitsConseilles.push({
            produits: { idProduit: idProduit },
            moisConseil: moisConseil,
            description: description,
            raison: raison
        });
    });
    console.log(JSON.stringify(produitsConseilles)); 
            $.ajax({
                url: 'insertProduitConseilles',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(produitsConseilles),
                success: function(response) {
                    alert(response.message);
                    $('#productsContainer').empty(); 
                },
                error: function(xhr, status, error) {
                    alert(xhr.responseText);
                }
            });
        });

            $('#addProductRow').click();
        });
    </script>
</body>
</html>

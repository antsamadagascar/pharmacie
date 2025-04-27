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
    .container {
        margin-top: 100px;
    }
</style>
<body>
    <%
        TypeProduitDAO typeProduitDAO = new TypeProduitDAO();
        CategorieDAO categorieDAO = new CategorieDAO();
        List<TypeProduit> typesProduit = typeProduitDAO.getAllTypeProduits();
        List<Categorie> categories = categorieDAO.getAllCategories();
    %>
    
    <div class="container mt-4">
        <!-- Formulaire d'insertion -->
        <div class="card mb-4">
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

        <!-- Liste des produits -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-list me-2"></i>Liste des Produits
                </h2>
            </div>
            <div class="card-body">
                <table class="table table-bordered" id="produitsTable">
                    <thead>
                        <tr>
                            <th>Nom du produit</th>
                            <th>Type de produit</th>
                            <th>Catégorie</th>
                            <th>Prix unitaire</th>
                        </tr>
                    </thead>
                    <tbody id="produitsTableBody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <template id="productRowTemplate">
        <div class="row product-row mb-3">
            <div class="col-md-3">
                <select class="form-select" name="idTypeProduit" required>
                    <option value="">Sélectionner un type</option>
                    <% for(TypeProduit type : typesProduit) { %>
                        <option value="<%= type.getIdTypeProduit() %>"><%= type.getNomType() %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-3">
                <select class="form-select" name="idCategorie" required>
                    <option value="">Sélectionner une catégorie</option>
                    <% for(Categorie categorie : categories) { %>
                        <option value="<%= categorie.getIdCategorie() %>"><%= categorie.getNomCategorie() %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-3">
                <input type="text" class="form-control" name="nomProduit" placeholder="Nom du produit" required>
            </div>
            <div class="col-md-2">
                <input type="number" class="form-control" name="prixUnitaire" placeholder="Prix unitaire" step="0.01" required>
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
            function loadProduits() {
                try {
                    const produitsJson = '<%=request.getAttribute("produitsJson")%>';
                    if (!produitsJson) {
                        console.warn('Aucune donnée de produits disponible');
                        return;
                    }

                    const produitsList = JSON.parse(produitsJson);
                    const produitsTableBody = $('#produitsTableBody');
                    produitsTableBody.empty();

                    produitsList.forEach(function(produit) {
                        const row = $('<tr>').append(
                            $('<td>').text(produit.nomProduit),
                            $('<td>').text(produit.typeProduit.nomType),
                            $('<td>').text(produit.categorie.nomCategorie),
                            $('<td>').text(produit.prixUnitaire)
                        );
                        produitsTableBody.append(row);
                    });
                } catch (error) {
                    console.error('Erreur lors du chargement des produits:', error);
                }
            }

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

                const products = [];
                $('.product-row').each(function() {
                    const row = $(this);
                    const product = {
                        typeProduit: { idTypeProduit: parseInt(row.find('[name="idTypeProduit"]').val()) },
                        categorie: { idCategorie: parseInt(row.find('[name="idCategorie"]').val()) },
                        nomProduit: row.find('[name="nomProduit"]').val(),
                        prixUnitaire: parseFloat(row.find('[name="prixUnitaire"]').val())
                    };
                    products.push(product);
                });

                $.ajax({
                    url: 'insertionProduits',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(products),
                    success: function(response) {
                        alert('Produits enregistrés avec succès!');
                        $('#productsContainer').empty();
                        loadProduits(); 
                    },
                    error: function(xhr, status, error) {
                        alert('Erreur lors de l\'enregistrement: ' + xhr.responseText);
                    }
                });
            });

            $('#addProductRow').click();

            loadProduits();
        });
    </script>
</body>
</html>
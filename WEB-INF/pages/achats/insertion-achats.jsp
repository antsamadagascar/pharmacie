<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Insertion des Achats</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <style>
        .container {
            margin-top: 100px;
        }
    </style>
</head>
<body>
    <%
        UniteDAO uniteDAO =new UniteDAO();
        List<Unites> unites = uniteDAO.getAllUnites();

        ProduitDAO produitDAO =new ProduitDAO();
        List<Produits> produits =produitDAO.getAllProduits();
    %>
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-plus me-2"></i>Insertion des Achats
                </h2>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <button type="button" class="btn btn-primary" id="addAchatsRow">
                        <i class="fas fa-plus me-2"></i>Ajouter une achat
                    </button>
                </div>
                <form id="AchatsForm">
                    <div id="AchatsContainer">
            
                    </div>
                    <button type="submit" class="btn btn-success mt-3">
                        <i class="fas fa-save me-2"></i>Enregistrer toutes les Achats
                    </button>
                </form>
            </div>
        </div>
    </div>

    <template id="AchatsRowTemplate">
        <div class="row Achats-row mb-3">
            <div class="col-md-3">
                <select class="form-select" name="idProduit" required>
                    <option value="">Sélectionner un Produit</option>
                    <% for(Produits produit : produits) { %>
                        <option value="<%= produit.getIdProduit() %>" data-prix="<%= produit.getPrixUnitaire() %>">
                            <%= produit.getNomProduit() %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-3">
                <select class="form-select" name="idUnite" required>
                    <option value="">Sélectionner un unite</option>
                    <% for(Unites u : unites) { %>
                        <option value="<%= u.getIdUnite() %>"><%= u.getNomUnite() %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-2">
                <input type="number" class="form-control quantite" name="quantite" placeholder="Quantité Achat" required>
            </div>
            <div class="col-md-2">
                <input type="number" class="form-control" name="prixachat" placeholder="Prix Achat" >
            </div>
            <div class="col-md-3">
                <label for="date" ></label>
                <input type="date" class="form-control date-achat" name="date" required>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-danger remove-row">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        
    </template>

    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#addAchatsRow').click(function() {
                const template = document.getElementById('AchatsRowTemplate');
                const clone = template.content.cloneNode(true);
                document.getElementById('AchatsContainer').appendChild(clone);
            });

            $(document).on('click', '.remove-row', function() {
                $(this).closest('.Achats-row').remove();
            });


            $('#AchatsForm').on('submit', function(e) {
            e.preventDefault();

            const Achats = [];
            $('.Achats-row').each(function() {
                const row = $(this);
                const idUnite = parseInt(row.find('[name="idUnite"]').val());
                const idProduit = parseInt(row.find('[name="idProduit"]').val());
                const quantite = parseInt(row.find('[name="quantite"]').val());
                const prixachat = parseFloat(row.find('[name="prixachat"]').val());
                const dateAchat = row.find('[name="date"]').val();

                if (isNaN(idProduit) || !idProduit) {
                    alert('Veuillez sélectionner un produit');
                    return;
                }
                if (isNaN(idUnite) || !idUnite) {
                    alert('Veuillez sélectionner une unité');
                    return;
                }
                if (isNaN(quantite) || quantite <= 0) {
                    alert('La quantité doit être un nombre positif');
                    return;
                }
                if (!dateAchat) {
                    alert('La date est requise');
                    return;
                }

                Achats.push({
                produits: { idProduit: idProduit },
                unites: { 
                    idUnite: idUnite,
                    nomUnite: row.find('[name="idUnite"] option:selected').text()
                },
                quantiteAchat: quantite,  
                prixAchat: prixachat,   
                dateAchat: dateAchat
            });
            });

            if (Achats.length === 0) {
                alert('Veuillez ajouter au moins un achat');
                return;
            }

            console.log('Données envoyées:', JSON.stringify(Achats));  

            $.ajax({
                url: 'insertAchats',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(Achats),
                success: function(response) {
                    alert('Achats enregistrés avec succès');
                    $('#AchatsContainer').empty();
                    $('#addAchatsRow').click(); 
                },
                error: function(xhr, status, error) {
                    alert('Erreur lors de l\'enregistrement: ' + xhr.responseText);
                }
            });
        });

            $('#addAchatsRow').click();
        });
    </script>
</body>
</html>

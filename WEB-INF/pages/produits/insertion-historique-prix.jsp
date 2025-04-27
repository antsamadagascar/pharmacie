<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Insertion Historique Prix</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
</head>
<style>
       .container {
        margin-top: 100px;
    }
</style>
<body>
    <%
        ProduitDAO produitDAO = new ProduitDAO();
        List<Produits> produits = produitDAO.getAllProduits();
    %>
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-history me-2"></i>Insertion Historique Prix
                </h2>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <button type="button" class="btn btn-primary" id="addHistoriqueRow">
                        <i class="fas fa-plus me-2"></i>Ajouter un Historique
                    </button>
                </div>
                <form id="historiquePrixForm">
                    <div id="historiqueContainer">
                    </div>
                    <button type="submit" class="btn btn-success mt-3">
                        <i class="fas fa-save me-2"></i>Enregistrer tout l'historique
                    </button>
                </form>
            </div>
        </div>
    </div>

    <template id="historiqueRowTemplate">
        <div class="row historique-row mb-3">
            <div class="col-md-3">
                <select class="form-select" name="idProduit" required>
                    <option value="">Sélectionner un Produit</option>
                    <% for(Produits produit : produits) { %>
                        <option value="<%= produit.getIdProduit() %>" 
                                data-prix="<%= produit.getPrixUnitaire() %>">
                            <%= produit.getNomProduit() %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-2">
                <input type="number" step="0.01" class="form-control ancien-prix" 
                       name="ancienPrix" placeholder="Ancien Prix" required>
            </div>
            <div class="col-md-2">
                <input type="number" step="0.01" class="form-control nouveau-prix" 
                       name="nouveauPrix" placeholder="Nouveau Prix" required>
            </div>
            <div class="col-md-3">
                <input type="date" class="form-control" name="dateChangement" 
                       placeholder="dateChangement" required>
            </div>
            <div class="col-md-3">  
                <input type="text" class="form-control" name="raison" 
                       placeholder="Raison du changement" required>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-danger remove-row">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        </div>
    </template>

    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#addHistoriqueRow').click(function() {
                const template = document.getElementById('historiqueRowTemplate');
                const clone = template.content.cloneNode(true);
                document.getElementById('historiqueContainer').appendChild(clone);
            });

            $(document).on('click', '.remove-row', function() {
                $(this).closest('.historique-row').remove();
            });

            $(document).on('change', 'select[name="idProduit"]', function() {
                const row = $(this).closest('.historique-row');
                const prixActuel = parseFloat($(this).find('option:selected').data('prix'));
                row.find('.ancien-prix').val(prixActuel);
            });

            $('#historiquePrixForm').on('submit', function(e) {
                e.preventDefault();

                const historiques = [];
                $('.historique-row').each(function() {
                    const row = $(this);
                    const idProduit = parseInt(row.find('[name="idProduit"]').val());
                    const ancienPrix = parseFloat(row.find('[name="ancienPrix"]').val());
                    const nouveauPrix = parseFloat(row.find('[name="nouveauPrix"]').val());
                    const dateChangement = row.find('[name="dateChangement"]').val();
                    const raison = row.find('[name="raison"]').val();

                    if (isNaN(idProduit) || idProduit === '') {
                        alert('Veuillez sélectionner un produit.');
                        return;
                    }

                    historiques.push({
                        produit: { idProduit: idProduit },
                        ancienPrix: ancienPrix,
                        nouveauPrix: nouveauPrix,
                        dateChangement:dateChangement,
                        raison: raison
                    });
                });

                $.ajax({
                    url: 'insertionHistoriquePrix',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(historiques),
                    success: function(response) {
                        alert('Enregistrement effectué avec succès');
                        $('#historiqueContainer').empty();
                        $('#addHistoriqueRow').click();
                    },
                    error: function(xhr, status, error) {
                        alert('Erreur lors de l\'enregistrement : ' + xhr.responseText);
                    }
                });
            });

            $('#addHistoriqueRow').click();
        });
    </script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Insertion des Ventes</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <style>
        .container {
            margin-top: 100px;
        }
    </style>
</head>
<body>
    <%
        ClientDAO clientDAO = new ClientDAO();
        List<Client> clients = clientDAO.getAllClients();

        ProduitDAO produitDAO =new ProduitDAO();
        List<Produits> produits =produitDAO.getAllProduits();

        VendeurDAO VendeurDAO = new VendeurDAO();
        List<Vendeur> vendeurs = VendeurDAO.getAllVendeurs();
    %>
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-plus me-2"></i>Insertion des Ventes
                </h2>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <button type="button" class="btn btn-primary" id="addventesRow">
                        <i class="fas fa-plus me-2"></i>Ajouter une Vente
                    </button>
                </div>
                <form id="ventesForm">
                    <div id="ventesContainer">
            
                    </div>
                    <button type="submit" class="btn btn-success mt-3">
                        <i class="fas fa-save me-2"></i>Enregistrer toutes les Ventes
                    </button>
                </form>
            </div>
        </div>
    </div>

    <template id="ventesRowTemplate">
        <div class="row ventes-row mb-3">
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
                    <select class="form-select" name="idVendeur" required>
                        <option value="">Sélectionner un vendeur</option>
                        <% for(Vendeur v : vendeurs) { %>
                            <option value="<%= v.getIdVendeur() %>"><%= v.getNom() %></option>
                        <% } %>
                    </select>
                </div>
   
            <div class="col-md-3">
                <select class="form-select" name="idClient" required>
                    <option value="">Sélectionner un client</option>
                    <% for(Client c : clients) { %>
                        <option value="<%= c.getIdClient() %>"><%= c.getNom() %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-2">
                <input type="number" class="form-control quantite" name="quantite" placeholder="Quantité" required>
            </div>
            
            <div class="col-md-2">
                <input type="number" class="form-control prix-total" name="prixTotal" placeholder="Prix Total" readonly>
            </div>
            <div class="col-md-3">
                <input type="date" class="form-control date-vente" name="date" required>
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
            $('#addventesRow').click(function() {
                const template = document.getElementById('ventesRowTemplate');
                const clone = template.content.cloneNode(true);
                document.getElementById('ventesContainer').appendChild(clone);
            });

            $(document).on('click', '.remove-row', function() {
                $(this).closest('.ventes-row').remove();
        });

        $(document).on('change', '.quantite, .form-select[name="idProduit"]', function() {
            const row = $(this).closest('.ventes-row');
            const quantite = row.find('.quantite').val();
            const prixUnitaire = parseFloat(row.find('select[name="idProduit"] option:selected').data('prix'));
            const prixTotal = quantite * prixUnitaire;

            row.find('.prix-total').val(prixTotal.toFixed(2));
        });

        $('#ventesForm').on('submit', function(e) {
            e.preventDefault();

            const ventes = [];
            $('.ventes-row').each(function() {
                const row = $(this);
                const idProduit = parseInt(row.find('[name="idProduit"]').val());
                const idClient = parseInt(row.find('[name="idClient"]').val());
                const idVendeur = parseInt(row.find('[name="idVendeur"]').val());
                const quantite = parseInt(row.find('[name="quantite"]').val());
                const prixTotal = row.find('[name="prixTotal"]').val();
                const dateVente = row.find('[name="date"]').val();


                if (isNaN(idProduit) || idProduit === '') {
                    alert('L\'ID du produit est manquant ou invalide.');
                    return;
                }
                if (isNaN(idVendeur) || idVendeur === '') {
                    alert('Le vendeur est requis.');
                    return;
                }
                if (!dateVente) {
                    alert('La date est requise.');
                    return;
                }

                ventes.push({
                    produits: { idProduit: idProduit },
                    client: { idClient: idClient },
                    vendeur: { idVendeur: idVendeur },
                    quantite: quantite,
                    prixTotal: prixTotal,
                    dateVente: dateVente
                });
            });

            $.ajax({
                url: 'insertionVentes',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(ventes),
                success: function(response) {
                if (typeof response === 'string') {
                    // Si la réponse est une chaîne de caractères
                    alert(response);
                } else if (response && response.message) {
                    // Si la réponse est un objet avec une propriété message
                    alert(response.message);
                } else {
                    // Message par défaut si la structure n'est pas celle attendue
                    alert('Enregistrement effectué avec succès');
                }
                $('#ventesContainer').empty();
                $('#addventesRow').click();
            },
                error: function(xhr, status, error) {
                    alert('Erreur lors de l\'enregistrement : ' + xhr.responseText);
                }
            });
        });

        $('#addventesRow').click();
    });
    </script>
</body>
</html>

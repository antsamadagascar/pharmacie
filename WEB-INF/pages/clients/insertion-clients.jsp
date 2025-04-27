<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Insertion des Clients</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
</head>
<style>
    .container {
        margin-top: 100px;
    }
</style>
<body>
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-plus me-2"></i>Insertion des Clients
                </h2>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <button type="button" class="btn btn-primary" id="addclientRow">
                        <i class="fas fa-plus me-2"></i>Ajouter un clients
                    </button>
                </div>
                <form id="clientsForm">
                    <div id="clientsContainer">
            
                    </div>
                    <button type="submit" class="btn btn-success mt-3">
                        <i class="fas fa-save me-2"></i>Enregistrer tous les clients
                    </button>
                </form>
            </div>
        </div>
    </div>

    <template id="clientRowTemplate">
        <div class="row client-row mb-3">
            <div class="col-md-3">
                <input type="text" class="form-control" name="nom" placeholder="nom" required>
            </div>
            <div class="col-md-2">
                <input type="text" class="form-control" name="prenom" placeholder="prenom">
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
            $('#addclientRow').click(function() {
                const template = document.getElementById('clientRowTemplate');
                const clone = template.content.cloneNode(true);
                document.getElementById('clientsContainer').appendChild(clone);
            });

            $(document).on('click', '.remove-row', function() {
                $(this).closest('.client-row').remove();
            });

            $('#clientsForm').on('submit', function(e) {
            e.preventDefault();

    const clients = [];
    $('.client-row').each(function() {
        const row = $(this);
        const nom = row.find('[name="nom"]').val(); 
        const prenom = row.find('[name="prenom"]').val();


        if (!nom) {
            alert('Le nom est requis');
            return;
        }

        clients.push({
            nom: nom,
            prenom: prenom
        });
    });
    console.log(JSON.stringify(clients)); 
            $.ajax({
                url: 'insertClients',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(clients),
                success: function(response) {
                    alert(response.message);
                    $('#clientsContainer').empty(); 
                },
                error: function(xhr, status, error) {
                    alert(xhr.responseText);
                }
            });
        });

            $('#addclientRow').click();
        });
    </script>
</body>
</html>

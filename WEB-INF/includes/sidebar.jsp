<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ======= Sidebar ======= -->
<aside id="sidebar" class="sidebar">
    <ul class="sidebar-nav" id="sidebar-nav">
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-grid"></i>
                <span>Dashboard</span>
            </a>
        </li><!-- End Dashboard Nav -->
        <li class="nav-heading">Inseriton Donnees</li>
        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#crud-nav" data-bs-toggle="collapse" href="#">
                <i class="bi bi-database"></i><span>Données</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="crud-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
                <li>
                    <a href="insertionVentes">
                        <i class="bi bi-circle"></i><span>Ventes</span>
                    </a>
                </li>
                <li>
                    <a href="insertAchats">
                        <i class="bi bi-circle"></i><span>Achats</span>
                    </a>
                </li>
                <li>
                    <a href="insertionProduits">
                        <i class="bi bi-circle"></i><span>Produits</span>
                    </a>
                </li>
                <li>
                    <a href="insertProduitConseilles">
                        <i class="bi bi-circle"></i><span>Produits Conseilles</span>
                    </a>
                </li>
                <li>
                    <a href="insertClients">
                        <i class="bi bi-circle"></i><span>Clients</span>
                    </a>
                </li>
                <li>
                    <a href="insertionHistoriquePrix">
                        <i class="bi bi-circle"></i><span>Insertion Historique</span>
                    </a>
                </li>
            </ul>
        </li><!-- End CRUD Nav -->

        <li class="nav-heading">Listes</li>
        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#recherche-nav" data-bs-toggle="collapse" href="#">
                <i class="bi bi-search"></i><span>Recherche</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="recherche-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
                <li>
                    <a href="RechercheMedicaments">
                        <i class="bi bi-circle"></i><span>Medicament Maladie</span>
                    </a>
                </li>
                <li>
                    <a href="RechercheVentes">
                        <i class="bi bi-circle"></i><span>Ventes Medicaments</span>
                    </a>
                </li>

                <li>
                    <a href="RechercheProduitsConseills">
                        <i class="bi bi-circle"></i><span>Produits Conseills</span>
                    </a>
                </li>
                <li>
                    <a href="rechercheVentesClient">
                        <i class="bi bi-circle"></i><span>Ventes Clients</span>
                    </a>
                                 </li>
                <li>
                    <a href="rechercheVentesCommision">
                        <i class="bi bi-circle"></i><span>Ventes Commission</span>
                    </a>
                </li>
                <li>
                    <a href="RecherchePrixProduits">
                        <i class="bi bi-circle"></i><span>Historiques Prix</span>
                    </a>
                </li>
            </ul>
        </li><!-- End CRUD Nav -->

        <li class="nav-heading">Stocks</li>
        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#stock-nav" data-bs-toggle="collapse" href="#">
                <i class="bi bi-box"></i><span>Etats Stocks</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="stock-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
                <li>
                    <a href="etatStock">
                        <i class="bi bi-circle"></i><span>Listes</span>
                    </a>
                </li>
                <li>
                    <a href="mouvementStock">
                        <i class="bi bi-circle"></i><span>Mouvement Stock</span>
                    </a>
                </li>
            </ul>
        </li>
    </ul>
</aside><!-- End Sidebar -->

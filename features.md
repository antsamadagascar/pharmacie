# Système de Gestion de Pharmacie

## Vue d'ensemble
Ce système de gestion de pharmacie offre une simple solution  pour gérer les opérations quotidiennes d'une pharmacie, incluant la gestion des produits, des ventes, des stocks, et des commissions des vendeurs.

---

## 📊 **Fonctionnalités Principales**

### **1. Gestion des Produits**

#### **1.1 Insertion et Gestion des Produits**
- **Insertion multiple de produits** : Permet d'ajouter plusieurs produits simultanément avec leurs informations complètes (nom, type, catégorie, prix unitaire)
- **Gestion des types de produits** : Classification des produits par types (médicaments, produits de parapharmacie, etc.)
- **Gestion des catégories** : Organisation des produits par catégories pour une meilleure classification

#### **1.2 Recherche et Filtrage des Produits**
- **Filtrage multicritères** : Recherche avancée par catégories, types, nom de produits, et gammes de prix
- **Recherche de médicaments spécialisée** : Filtrage par type de maladie et groupe d'âge (enfants, adultes, seniors)
- **Interface de recherche intuitive** : Formulaires de recherche avec critères multiples et résultats dynamiques

#### **1.3 Gestion des Prix et Historique**
- **Modification des prix produits** : Mise à jour des prix unitaires avec traçabilité
- **Suivi historique des prix** : Conservation de l'historique complet des modifications de prix
- **Filtrage de l'historique** : Recherche par type de produits, catégories, et périodes spécifiques

---

### **2. Gestion des Ventes**

#### **2.1 Processus de Vente**
- **Insertion multiple de ventes** : Enregistrement rapide de plusieurs ventes simultanément
- **Liaison vendeur-vente** : Chaque vente est associée à un vendeur spécifique
- **Calcul automatique** : Calcul automatique des montants totaux et quantités

#### **2.2 Recherche et Analyse des Ventes**
- **Filtrage multicritères des ventes** : Recherche par type d'administration, groupe d'âge, date, et produit
- **Ventes par client** : Suivi des achats de chaque client avec historique complet
- **Filtrage par catégories** : Analyse des ventes par type de produits et catégories

#### **2.3 Ventes de Produits Spécialisés**
- **Médicaments injectables pour bébés** : Module spécialisé pour les produits destinés aux nourrissons
- **Critères de sécurité** : Filtrage spécifique pour les produits pédiatriques
- **Traçabilité renforcée** : Suivi particulier des ventes de médicaments sensibles

---

### **3. Gestion des Commissions Vendeurs**

#### **3.1 Système de Commission**
- **Calcul automatique** : Commission de 5% sur toutes les ventes réalisées par chaque vendeur
- **Condition de seuil** : Commission accordée uniquement si le total des ventes atteint ou dépasse 200,000 Ar
- **Suivi en temps réel** : Calcul et affichage des commissions par période

#### **3.2 Analyse des Commissions**
- **Filtrage par vendeur** : Consultation des commissions individuelles par vendeur
- **Analyse par genre** : Comparaison des commissions entre vendeurs hommes et femmes
- **Filtrage temporel** : Recherche par dates de début et fin de période
- **Rapports détaillés** : États complets avec totaux et détails par transaction

---

### **4. Gestion des Clients**

#### **4.1 Base de Données Clients**
- **Insertion multiple de clients** : Enregistrement rapide de nouveaux clients
- **Informations complètes** : Nom, prénom, et données de contact
- **Historique d'achat** : Suivi complet des transactions par client

#### **4.2 Analyse Clientèle**
- **Ventes quotidiennes** : Liste des clients ayant effectué des achats dans la journée
- **Comportement d'achat** : Analyse des préférences et habitudes d'achat
- **Segmentation** : Classification des clients selon leurs types d'achats

---

### **5. Produits Conseillés du Mois**

#### **5.1 Gestion des Recommandations**
- **Insertion multiple** : Ajout de plusieurs produits conseillés simultanément
- **Classification mensuelle** : Organisation par mois et année
- **Mise à jour flexible** : Modification facile des recommandations

#### **5.2 Recherche et Suivi**
- **Filtrage multicritères** : Recherche par année, mois, type de produits, et catégories
- **Historique des recommandations** : Consultation des produits conseillés des périodes précédentes
- **Analyse de performance** : Évaluation de l'efficacité des recommandations

---

### **6. Gestion des Stocks**

#### **6.1 Suivi des Stocks**
- **Liste complète des stocks** : Vue d'ensemble de tous les produits en stock
- **Insertion multiple de stocks** : Mise à jour rapide des quantités
- **Alertes de stock** : Notifications pour les produits en rupture ou faible stock

#### **6.2 Mouvements de Stock**
- **Traçabilité complète** : Suivi de tous les mouvements d'entrée et sortie
- **Historique détaillé** : Conservation de l'historique des mouvements
- **Rapports de stock** : États périodiques sur l'évolution des stocks

---

### **7. Gestion des Achats**

#### **7.1 Processus d'Achat**
- **Insertion multiple d'achats** : Enregistrement des commandes fournisseurs
- **Suivi des approvisionnements** : Gestion des relations avec les fournisseurs
- **Intégration au stock** : Mise à jour automatique des stocks lors des réceptions

---

## 🎯 **Avantages du Système**

### **Efficacité simple et Opérationnelle**
- Réduction du temps de saisie grâce aux fonctions d'insertion multiple
- Interface utilisateur intuitive et ergonomique
- Automatisation des calculs et mises à jour


## 📈 **Modules Techniques**

### **Base de Données**
- Structure relationnelle optimisée
- Vues SQL pour les rapports complexes

### **Interface Utilisateur**
- Pages JSP dynamiques
- Formulaires de recherche avancés en utilisant seulement javascript,bootstrap

### **Logique Métier**
- Classes Java bien structurées
- DAO (Data Access Object) pour l'accès aux données
- Servlets pour la gestion des requêtes

---

*Ce  système offre une solution simple  et évolutive pour la gestion moderne d'une pharmacie, alliant efficacitée.*
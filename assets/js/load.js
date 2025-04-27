document.getElementById('searchForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const loadingSpinner = document.querySelector('.loading-spinner');
    const resultsTable = document.getElementById('resultsTable');
    
    loadingSpinner.style.display = 'block';
    resultsTable.style.opacity = '0.5';

    setTimeout(() => {
        loadingSpinner.style.display = 'none';
        resultsTable.style.opacity = '1';
    }, 1000);
});


function formatPrice(price) {
    return new Intl.NumberFormat('fr-FR', {
        style: 'currency',
        currency: 'EUR'
    }).format(price);
}

function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('fr-FR');
}

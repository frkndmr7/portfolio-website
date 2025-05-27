document.addEventListener('DOMContentLoaded', function() {
    // API Gateway endpoint URL'si - GitHub Actions tarafından güncellenecek
    const apiUrl = 'API_GATEWAY_URL_PLACEHOLDER';
    
    console.log('Ziyaretçi sayacı yükleniyor...');
    
    const counterElement = document.getElementById('visitor-counter');
    if (!counterElement) {
        console.error('visitor-counter ID\'li element bulunamadı!');
        return;
    }
    
    fetch(`${apiUrl}?pageId=homepage`)
        .then(response => {
            console.log('API yanıtı statüsü:', response.status);
            if (!response.ok) {
                throw new Error('API yanıtı başarısız: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            console.log('API yanıt verisi:', data);
            counterElement.textContent = data.count || 0;
        })
        .catch(error => {
            console.error('Ziyaretçi sayacı yüklenemedi:', error);
            counterElement.textContent = '0';
        });
});
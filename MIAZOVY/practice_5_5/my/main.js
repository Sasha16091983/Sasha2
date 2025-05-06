// Дані для інформаційних карток
const infoCardsData = [
  { title: 'Загальна кількість техніки', value: '1,245' },
  { title: 'Втрати противника', value: '387' },
  { title: 'Успішні операції', value: '56' },
  { title: 'Рівень готовності', value: '92%' }
];

// Створення інформаційних карток
function createInfoCards() {
  const infoCardsContainer = document.getElementById('info-cards');
  
  infoCardsData.forEach(card => {
    const cardElement = document.createElement('div');
    cardElement.className = 'info-card';
    
    const title = document.createElement('h3');
    title.textContent = card.title;
    
    const value = document.createElement('p');
    value.textContent = card.value;
    
    cardElement.appendChild(title);
    cardElement.appendChild(value);
    infoCardsContainer.appendChild(cardElement);
  });
}

// Ініціалізація графіка Chart.js
function initChart() {
  const ctx = document.getElementById('chart1').getContext('2d');
  
  const data = {
    labels: ['Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень'],
    datasets: [{
      label: 'Виконані завдання',
      data: [65, 59, 80, 81, 56, 55],
      backgroundColor: 'rgba(52, 152, 219, 0.2)',
      borderColor: 'rgba(52, 152, 219, 1)',
      borderWidth: 1
    }, {
      label: 'Ефективність',
      data: [28, 48, 40, 19, 86, 27],
      backgroundColor: 'rgba(46, 204, 113, 0.2)',
      borderColor: 'rgba(46, 204, 113, 1)',
      borderWidth: 1
    }]
  };
  
  const config = {
    type: 'bar',
    data: data,
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  };
  
  new Chart(ctx, config);
}

// Ініціалізація карти Leaflet
function initMap() {
  // Координати центру України
  const ukraineCenter = [49.0, 31.0];
  
  // Створення карти з центром на Україні та масштабом
  const map = L.map('map').setView(ukraineCenter, 6);
  
  // Додавання шару OpenStreetMap
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);
  
  // Додавання маркерів (приклад)
  const locations = [
    { name: 'Київ', coords: [50.45, 30.52] },
    { name: 'Львів', coords: [49.84, 24.03] },
    { name: 'Одеса', coords: [46.48, 30.73] },
    { name: 'Харків', coords: [49.99, 36.23] }
  ];
  
  locations.forEach(location => {
    L.marker(location.coords)
      .addTo(map)
      .bindPopup(location.name);
  });
}

// Ініціалізація всіх компонентів після завантаження сторінки
document.addEventListener('DOMContentLoaded', () => {
  createInfoCards();
  initChart();
  initMap();
});
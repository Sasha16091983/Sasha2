// Ініціалізація графіків та карти після завантаження DOM
document.addEventListener('DOMContentLoaded', () => {
    // Ініціалізація першого графіка (лінійний)
    initChart1();
    
    // Ініціалізація другого графіка (стовпчиковий)
    initChart2();
    
    // Ініціалізація карти
    initMap();
    
    // Ініціалізація четвертого графіка (кругова діаграма)
    initChart4();
});

// Функція для ініціалізації першого графіка (лінійний)
function initChart1() {
    const ctx = document.getElementById('chart1').getContext('2d');
    
    const chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень'],
            datasets: [{
                label: 'Динаміка операцій',
                data: [12, 19, 3, 5, 2, 3],
                borderColor: 'rgb(75, 192, 192)',
                tension: 0.1,
                fill: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

// Функція для ініціалізації другого графіка (стовпчиковий)
function initChart2() {
    const ctx = document.getElementById('chart2').getContext('2d');
    
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Регіон A', 'Регіон B', 'Регіон C', 'Регіон D', 'Регіон E'],
            datasets: [{
                label: 'Розподіл ресурсів',
                data: [12, 19, 3, 5, 2],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

// Функція для ініціалізації карти
function initMap() {
    // Координати центру України
    const ukraineCenter = [49.0, 31.0];
    
    // Створення карти з центром на Україні та масштабом
    const map = L.map('map').setView(ukraineCenter, 6);
    
    // Додавання шару OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    
    // Додавання маркерів для прикладу (можна замінити на реальні дані)
    const cities = [
        {name: 'Київ', coords: [50.45, 30.52]},
        {name: 'Львів', coords: [49.84, 24.03]},
        {name: 'Одеса', coords: [46.48, 30.73]},
        {name: 'Харків', coords: [49.99, 36.23]},
        {name: 'Дніпро', coords: [48.47, 35.04]}
    ];
    
    // Додавання маркерів на карту
    cities.forEach(city => {
        L.marker(city.coords)
            .addTo(map)
            .bindPopup(city.name);
    });
}

// Функція для ініціалізації четвертого графіка (кругова діаграма)
function initChart4() {
    const ctx = document.getElementById('chart4').getContext('2d');
    
    const chart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Категорія A', 'Категорія B', 'Категорія C', 'Категорія D'],
            datasets: [{
                label: 'Розподіл за категоріями',
                data: [30, 25, 20, 25],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(255, 206, 86, 0.7)',
                    'rgba(75, 192, 192, 0.7)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
}
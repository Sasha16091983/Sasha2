// Дані для дашборду
const dashboardData = {
    activeUnits: 42,
    personnel: 1250,
    equipment: 85,
    operations: 12,
    activityData: {
        labels: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Нд'],
        values: [65, 59, 80, 81, 56, 55, 70]
    },
    unitLocations: [
        { name: 'Підрозділ А', lat: 50.4501, lng: 30.5234, personnel: 250 },
        { name: 'Підрозділ Б', lat: 49.8397, lng: 24.0297, personnel: 180 },
        { name: 'Підрозділ В', lat: 48.9226, lng: 24.7111, personnel: 210 },
        { name: 'Підрозділ Г', lat: 46.4825, lng: 30.7233, personnel: 195 },
        { name: 'Підрозділ Д', lat: 49.5883, lng: 34.5514, personnel: 165 }
    ],
    personnelData: [
        { id: '001', name: 'Іван Петренко', rank: 'Капітан', unit: 'Підрозділ А', status: 'Активний' },
        { id: '002', name: 'Олександр Коваль', rank: 'Лейтенант', unit: 'Підрозділ Б', status: 'Активний' },
        { id: '003', name: 'Марія Шевченко', rank: 'Сержант', unit: 'Підрозділ А', status: 'Навчання' },
        { id: '004', name: 'Василь Мороз', rank: 'Майор', unit: 'Підрозділ В', status: 'Активний' },
        { id: '005', name: 'Наталія Іваненко', rank: 'Лейтенант', unit: 'Підрозділ Г', status: 'Відпустка' },
        { id: '006', name: 'Сергій Бондаренко', rank: 'Капітан', unit: 'Підрозділ Д', status: 'Активний' },
        { id: '007', name: 'Олена Ткаченко', rank: 'Сержант', unit: 'Підрозділ Б', status: 'Активний' },
        { id: '008', name: 'Андрій Лисенко', rank: 'Полковник', unit: 'Підрозділ В', status: 'Штаб' },
        { id: '009', name: 'Юлія Мельник', rank: 'Лейтенант', unit: 'Підрозділ А', status: 'Навчання' },
        { id: '010', name: 'Максим Савченко', rank: 'Майор', unit: 'Підрозділ Д', status: 'Активний' }
    ]
};

// Заповнення інформаційних карток
document.getElementById('active-units').textContent = dashboardData.activeUnits;
document.getElementById('personnel').textContent = dashboardData.personnel;
document.getElementById('equipment').textContent = dashboardData.equipment;
document.getElementById('operations').textContent = dashboardData.operations;

// Створення графіка активності
function createActivityChart() {
    const ctx = document.getElementById('activity-chart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: dashboardData.activityData.labels,
            datasets: [{
                label: 'Активність підрозділів',
                data: dashboardData.activityData.values,
                backgroundColor: 'rgba(59, 130, 246, 0.2)',
                borderColor: 'rgba(59, 130, 246, 1)',
                borderWidth: 2,
                tension: 0.3,
                pointBackgroundColor: 'rgba(59, 130, 246, 1)',
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            },
            plugins: {
                legend: {
                    display: true,
                    position: 'top'
                }
            }
        }
    });
}

// Ініціалізація карти
function initMap() {
    const map = L.map('map').setView([49.0139, 31.2858], 6); // Центр України

    // Додавання шару OpenStreetMap
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    // Додавання маркерів для підрозділів
    dashboardData.unitLocations.forEach(unit => {
        const marker = L.marker([unit.lat, unit.lng]).addTo(map);
        marker.bindPopup(`<b>${unit.name}</b><br>Особовий склад: ${unit.personnel}`);
    });
}

// Заповнення таблиці даними про військових
function populatePersonnelTable() {
    const tableBody = document.getElementById('personnel-table');
    
    dashboardData.personnelData.forEach(person => {
        const row = document.createElement('tr');
        
        // Визначення кольору статусу
        let statusColor = '';
        switch(person.status) {
            case 'Активний':
                statusColor = 'text-green-600';
                break;
            case 'Відпустка':
                statusColor = 'text-blue-600';
                break;
            case 'Навчання':
                statusColor = 'text-yellow-600';
                break;
            case 'Штаб':
                statusColor = 'text-purple-600';
                break;
            default:
                statusColor = 'text-gray-600';
        }
        
        row.innerHTML = `
            <td class="py-2 px-4 border-b border-gray-200">${person.id}</td>
            <td class="py-2 px-4 border-b border-gray-200">${person.name}</td>
            <td class="py-2 px-4 border-b border-gray-200">${person.rank}</td>
            <td class="py-2 px-4 border-b border-gray-200">${person.unit}</td>
            <td class="py-2 px-4 border-b border-gray-200 ${statusColor}">${person.status}</td>
        `;
        
        tableBody.appendChild(row);
    });
}

// Ініціалізація всіх компонентів при завантаженні сторінки
document.addEventListener('DOMContentLoaded', () => {
    createActivityChart();
    initMap();
    populatePersonnelTable();
});
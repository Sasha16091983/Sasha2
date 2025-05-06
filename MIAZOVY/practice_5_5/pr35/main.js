// Дані для демонстрації
const studentsData = [
    { name: 'Петренко Іван Олексійович', birthdate: '1995-05-15', rank: 'Лейтенант', group: 'Група А' },
    { name: 'Коваленко Марія Петрівна', birthdate: '1997-08-22', rank: 'Капітан', group: 'Група Б' },
    { name: 'Шевченко Олег Миколайович', birthdate: '1993-03-10', rank: 'Майор', group: 'Група А' },
    { name: 'Бондаренко Анна Василівна', birthdate: '1998-12-05', rank: 'Лейтенант', group: 'Група В' },
    { name: 'Мельник Сергій Ігорович', birthdate: '1990-07-18', rank: 'Полковник', group: 'Група Б' },
    { name: 'Ткаченко Олександр Андрійович', birthdate: '1996-09-30', rank: 'Капітан', group: 'Група В' },
    { name: 'Іваненко Наталія Олегівна', birthdate: '1994-11-12', rank: 'Майор', group: 'Група А' },
    { name: 'Савченко Дмитро Петрович', birthdate: '1992-02-25', rank: 'Полковник', group: 'Група Б' }
];

// Дані про розташування груп
const groupLocations = [
    { group: 'Група А', lat: 50.4501, lng: 30.5234, count: 15 },
    { group: 'Група Б', lat: 49.8397, lng: 24.0297, count: 12 },
    { group: 'Група В', lat: 48.9226, lng: 24.7111, count: 10 }
];

// Функція для форматування дати
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('uk-UA');
}

// Заповнення таблиці студентів
function populateStudentTable() {
    const tableBody = document.querySelector('#student-table tbody');
    
    studentsData.forEach(student => {
        const row = document.createElement('tr');
        
        const nameCell = document.createElement('td');
        nameCell.textContent = student.name;
        row.appendChild(nameCell);
        
        const birthdateCell = document.createElement('td');
        birthdateCell.textContent = formatDate(student.birthdate);
        row.appendChild(birthdateCell);
        
        const rankCell = document.createElement('td');
        rankCell.textContent = student.rank;
        row.appendChild(rankCell);
        
        const groupCell = document.createElement('td');
        groupCell.textContent = student.group;
        row.appendChild(groupCell);
        
        tableBody.appendChild(row);
    });
}

// Створення графіка чисельності груп
function createGroupsChart() {
    const ctx = document.getElementById('chartGroups').getContext('2d');
    
    // Підрахунок кількості студентів у кожній групі
    const groupCounts = {};
    groupLocations.forEach(location => {
        groupCounts[location.group] = location.count;
    });
    
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: Object.keys(groupCounts),
            datasets: [{
                label: 'Кількість студентів',
                data: Object.values(groupCounts),
                backgroundColor: [
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(75, 192, 192, 0.7)'
                ],
                borderColor: [
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 99, 132, 1)',
                    'rgba(75, 192, 192, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Кількість студентів'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'Група'
                    }
                }
            }
        }
    });
}

// Створення карти з розташуванням груп
function createMap() {
    const map = L.map('map').setView([49.8397, 24.0297], 6);
    
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    
    // Додавання маркерів для кожної групи
    groupLocations.forEach(location => {
        L.marker([location.lat, location.lng])
            .addTo(map)
            .bindPopup(`<b>${location.group}</b><br>Кількість: ${location.count}`)
            .openPopup();
    });
}

// Створення інформаційних карток для розподілу військових звань
function createRankCards() {
    const infoCardsContainer = document.getElementById('info-cards');
    
    // Підрахунок кількості студентів за званнями
    const rankCounts = {};
    studentsData.forEach(student => {
        if (rankCounts[student.rank]) {
            rankCounts[student.rank]++;
        } else {
            rankCounts[student.rank] = 1;
        }
    });
    
    // Кольори для різних звань
    const rankColors = {
        'Лейтенант': '#3498db',
        'Капітан': '#2ecc71',
        'Майор': '#f39c12',
        'Полковник': '#e74c3c'
    };
    
    // Створення карток для кожного звання
    Object.keys(rankCounts).forEach(rank => {
        const card = document.createElement('div');
        card.className = 'info-card';
        card.style.borderLeftColor = rankColors[rank] || '#999';
        
        const title = document.createElement('h3');
        title.textContent = rank;
        
        const count = document.createElement('p');
        count.textContent = rankCounts[rank];
        
        card.appendChild(title);
        card.appendChild(count);
        infoCardsContainer.appendChild(card);
    });
}

// Ініціалізація всіх компонентів після завантаження сторінки
document.addEventListener('DOMContentLoaded', () => {
    populateStudentTable();
    createGroupsChart();
    createMap();
    createRankCards();
});
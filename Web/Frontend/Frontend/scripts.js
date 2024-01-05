// Mock credentials
const validCredentials = {
  username: 'admin',
  password: 'admin'
};
let map; // Define a variable to hold the map instance
// Function to show the dashboard after successful login
function showDashboard() {
  document.getElementById('loginPage').style.display = 'none';
  document.getElementById('dashboard').style.display = 'block';
  // Fetch and display user records
  fetchReports();
  // Initialize the map
  initMap();
}

// Function to handle login form submission
document.getElementById('loginForm').addEventListener('submit', function(event) {
  event.preventDefault();
  const username = document.getElementById('username').value;
  const password = document.getElementById('password').value;

  // Check if the entered credentials match
  if (username === validCredentials.username && password === validCredentials.password) {
    showDashboard(); // Show the dashboard on successful login
  } else {
    alert('Invalid credentials. Please try again.');
  }
  // After successful login:
  document.getElementById('loginPage').style.display = 'none'; // Hide login page
  document.getElementById('dashboard').style.display = 'flex'; // Show dashboard

});

// Function to handle logout
document.getElementById('logoutBtn').addEventListener('click', function() {
  document.getElementById('loginPage').style.display = 'block';
  document.getElementById('dashboard').style.display = 'none';
 
});

// Fetch user records (replace with actual functionality)
function fetchReports() {
  // Dummy data	
  const reportData = [
    { reportID: 1, date: '2024-01-01', location: '48.337522, 14.321065', picture: 'dummy.jpg', status: 'Recieved' },
    { reportID: 2, date: '2024-01-02', location: '48.337432, 14.318367', picture: 'dummy.jpg', status: 'In work' },
    
  ];

  const reportTableBody = document.getElementById('reportTableBody');
  reportTableBody.innerHTML = ''; // Clear previous report table

  reportData.forEach(report => {
    const row = document.createElement('tr');

    const reportIDCell = document.createElement('td');
    reportIDCell.textContent = report.reportID;
    row.appendChild(reportIDCell);

    const dateCell = document.createElement('td');
    dateCell.textContent = report.date;
    row.appendChild(dateCell);

	const locationCell = document.createElement('td');
    const locationLink = document.createElement('a');
    locationLink.href = '#'; // Set a placeholder href
    locationLink.textContent = report.location; // Assuming report.location contains "latitude, longitude"

    // Set an onclick event to handle displaying location on the map
    locationLink.onclick = function() {
      const [lat, lon] = report.location.split(','); // Splitting latitude and longitude
      const latitude = parseFloat(lat);
      const longitude = parseFloat(lon);
      showLocationOnMap(latitude, longitude); // Call function to display location on map
      return false; // Prevent default anchor behavior
    };

    locationCell.appendChild(locationLink);
    row.appendChild(locationCell);

    const pictureCell = document.createElement('td');
    pictureCell.textContent = report.picture; // Replace with image display logic if needed
    row.appendChild(pictureCell);

    const statusCell = document.createElement('td');
    const statusSelect = document.createElement('select');
    ['Recieved', 'In work', 'Done'].forEach(option => {
      const optionElement = document.createElement('option');
      optionElement.value = option;
      optionElement.textContent = option;
      if (report.status === option) {
        optionElement.selected = true;
      }
      statusSelect.appendChild(optionElement);
    });
    statusCell.appendChild(statusSelect);
    row.appendChild(statusCell);

    reportTableBody.appendChild(row);
  });
}

// Function to initialize the map (replace with actual functionality)
function initMap() {
    if (!map) { // Check if the map instance exists
    map = L.map('map').setView([48.336042, 14.320847], 15); // Default coordinates (Linz JKU)

    // Add a tile layer (map tiles)
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: 'Map data © <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    // Example marker (can be customized or replaced)
    L.marker([48.336042, 14.320847]).addTo(map)
      .bindPopup('Test Marker') // Popup text
      .openPopup();
  }
}

function showLocationOnMap(latitude, longitude) {
  if (map) {
    map.setView([latitude, longitude], 15); // Set the map view to the clicked location
    L.marker([latitude, longitude]).addTo(map)
      .bindPopup(`Location: ${latitude}, ${longitude}`) // Display the location in the popup
      .openPopup();
  }
}
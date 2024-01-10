// Mock credentials
const validCredentials = {
  username: '',
  password: ''
};
let map; // Define a variable to hold the map instance
// Function to show the dashboard after successful login
function showDashboard() {
  document.getElementById('loginPage').style.display = 'none';
  document.getElementById('dashboard').style.display = 'block';
  // Fetch and display user records
  fetchReports().then(() => {
    // Display the fetched reports after the promise is resolved
    console.log('Reports fetched and displayed');
  });
   // Display the map
   document.getElementById('map').style.display = 'block';
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
    // After successful login:
    document.getElementById('loginPage').style.display = 'none'; // Hide login page
    document.getElementById('dashboard').style.display = 'flex'; // Show dashboard
  } else {
    alert('Invalid credentials. Please try again.');
  }
  

});

// Function to handle logout
document.getElementById('logoutBtn').addEventListener('click', function() {
  document.getElementById('loginPage').style.display = 'block';
  document.getElementById('dashboard').style.display = 'none';
    // Hide the map on logout
    document.getElementById('map').style.display = 'none';
 
});

// Fetch user records (replace with actual functionality)
function fetchReports() {
  return getDataFromServer().then(reportData => {
    const reportTableBody = document.getElementById('reportTableBody');
    reportTableBody.innerHTML = ''; // Clear previous report table
    
    reportData.forEach(report => {
      const row = document.createElement('tr');

      const reportIDCell = document.createElement('td');
      reportIDCell.textContent = report.reportID;
      row.appendChild(reportIDCell);

      const userIDCell = document.createElement('td');
      userIDCell.textContent = report.userID;
      row.appendChild(userIDCell);

      //ATTENTION !
      //Since no date was in the original data.json i commented this part out. Also needs to be enabled in the HTML file again
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

      const dirtcell = document.createElement('td');
      dirtcell.textContent = report.dirtiness;
      row.appendChild(dirtcell);

      const pictureCell = document.createElement('td');
      const picture = document.createElement('img');
      picture.src = 'data:image/jpeg;base64,' +  report.picture; // Set the image URL dynamically
      picture.alt = 'Report Image'; // Optional: Set alt text for the image
      pictureCell.appendChild(picture);
      row.appendChild(pictureCell);

      const commentCell = document.createElement('td');
      commentCell.textContent = report.comment;
      row.appendChild(commentCell);

      const statusCell = document.createElement('td');
      const statusSelect = document.createElement('select');
      ['recieved', 'in work', 'done'].forEach(option => {
        const optionElement = document.createElement('option');
        optionElement.value = option;
        optionElement.textContent = option;
        if (report.status === option) {
          optionElement.selected = true;
        }
        statusSelect.appendChild(optionElement);
      });
      statusSelect.addEventListener('change', function(event) {
        const updatedStatus = event.target.value; // Get the updated status

        // Make a call to update the status via your Express server
        updateStatus(report.userID,report.legacyreportID, updatedStatus);
      });
      statusCell.appendChild(statusSelect);
      row.appendChild(statusCell);

      reportTableBody.appendChild(row);
    });
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

//GET METHODE to get all data from server at start 
function getDataFromServer(){
  return fetch('http://localhost:3000/get/allreports')
    .then(response => response.json())
    .then(data => {
      // Use the received 'data' in your frontend
      let reportRecords = scrapData(data);
      return reportRecords;
    })
    .catch(error => {
      console.error('Error fetching data:', error);
  });
}

//TODO UPDATE METHODE to update the status of a specific report
function updateStatus(userId, reportId, newStatus) {
  // Use fetch to send a POST request to your Express server with the updated status
  console.log(reportId);
  console.log(userId);
  console.log(newStatus);
  fetch('http://localhost:3000/update/status', {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ userId, reportId, newStatus }),
  })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      // Optionally, handle success or update the UI after successful update
      console.log('Status of '+ userId +"-"+ reportId + ' updated successfully');
    })
    .catch(error => {
      console.error('Error updating status:', error);
      // Optionally, handle errors or display a message to the user
    });
}



//Restructure the server data in Array of objects to fit in the HTML table 
function scrapData(data){
  let reportRecords = [];
  console.log(data);
    data.users.forEach(element => {
      element.reports.forEach(rep => {
        reportRecords.push({
          legacyreportID : rep.reportId, 
          reportID : rep.userId +"-"+ rep.reportId.toString(),
          userID : rep.userId,
          date : rep.date,
          location: rep.coordinates.latitude+", "+rep.coordinates.longitude, 
          dirtiness: rep.dirtiness,
          picture: rep.picture,
          comment: rep.comment,
          status: rep.status
        });
      })
    });
  console.log(reportRecords);
  return reportRecords;
}

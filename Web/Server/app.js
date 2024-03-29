const express = require('express')
const fs = require('fs')
const cors = require('cors'); // Import the cors module

const app = express()
const port = 3000

app.use(cors()); // Enable CORS for all routes

app.use(express.json({limit: '50mb'}))

const initJsonFile = {
    users: [
        {
            userId: "123456789",
            reports: []
        },
        {
            userId: "987654321",
            reports: []
        }
    ]
}
app.get('/', (req, res) => {
    //writeFile(JSON.stringify(initJsonFile)) //this was just for initialization of the json file
    res.json(readFile())
})

app.post('/send/report', async (req, res) => {
    newReport(req, res)
})

app.post('/get/myreports', async (req, res) => {
    sendReports(req, res)
})

app.post('/get/allcoordinates', async (req, res) => {
    sendAllCoordinates(req, res)
})

app.listen(port, () => {
    console.log(`Server running on port ${port}`)
})

// Website FRONTEND PART 
// METHODE to get all reports for the init of the interface
app.get('/get/allreports', async (req, res) => {
    res.json(readFile());
})

// UPDATE the status of a report via Pos METHODE
// ReportID, UserID, and Status are needed in request
app.put('/update/status', (req, res) => {
   
    const { userId, reportId, newStatus } = req.body;

    //JUST server console logs
    console.log("UPDATING THE SERVER FILE.....")
    console.log("UserId "+ userId.toString());
    console.log("ReportId "+ reportId);
    console.log("Status "+ newStatus +"\n");

    const data = readFile();
    const userIndex = data.users.findIndex(user => user.userId === userId);
    if (userIndex !== -1) {
        const reportIndex = data.users[userIndex].reports.findIndex(report => report.reportId === reportId);

        if (reportIndex !== -1) {
            data.users[userIndex].reports[reportIndex].status = newStatus;
            writeFile(JSON.stringify(data));
            res.status(200).send('Status updated successfully');
        } else {
            res.status(404).send('Report ID not found');
        }
    } else {
        console.log("User not found")
        res.status(404).send('User ID not found');
    }
});

function newReport(req, res) {
    console.log(`make new request for ${req.body.userId}`)
    var data = readFile()
    console.log(data)
    var userId = req.body.userId
    if(userId === "") {
        userId = createNewUserId(data)
        const newUser = {
            userId: userId,
            reports: []
        }
        data.users.push(newUser)
    }
    var userNumber = -1
    for(var i = 0; i < data.users.length; i++) {
        if(data.users[i].userId === userId) {
            userNumber = i
        }
    }
    if(userNumber === -1) {
        const newUser = {
            userId: userId,
            reports: []
        }
        data.users.push(newUser)
        for(var i = 0; i < data.users.length; i++) {
            if(data.users[i].userId === userId) {
                userNumber = i
            }
        }
    }
    const newReport = {
        userId: userId,
        reportId: createNewReportId(data, userNumber),
        coordinates: {
            longitude: req.body.coordinates.longitude,
            latitude: req.body.coordinates.latitude
        },
        picture: req.body.picture,
        dirtiness: req.body.dirtiness,
        comment: req.body.comment,
        status: "received",
        date: req.body.date
    }
    data.users[userNumber].reports.push(newReport)
    writeFile(JSON.stringify(data))
    res.send(newReport)
}

function sendReports(req, res) {
    var userId = req.body.userId
    console.log(`Sending reports to user ${userId}`)
    var data = readFile()
    var result =  {
        reports: [] 
    }
    if(userId === "") {
        res.send(result)
        return
    }
    console.log(`Number users: ${data.users.length}`)
    for(var i = 0; i < data.users.length; i++) {
        console.log(`Number of reports ${data.users[i].reports.length} for users ${data.users[i].userId}`)
        if(data.users[i].userId === userId) {
            result.reports = data.users[i].reports
        }
    }
    console.log(`Number results ${result.reports.length}`)
    for(var i = 0; i < result.reports.length; i++) {
        result.reports[i].picture = ""
    }
    console.log(result)
    res.send(result)
}

function sendAllCoordinates(req, res) {
    console.log('Sending all coordinates')
    var data = readFile()
    var result = {
        reports: []
    }
    console.log(`Number users: ${data.users.length}`)
    for(var i = 0; i < data.users.length; i++) {
        console.log(`Number of reports ${data.users[i].reports.length} for users ${data.users[i].userId}`)
        for(var j = 0; j < data.users[i].reports.length; j++) {
            var report = data.users[i].reports[j]
            report.picture = ""
            result.reports.push(report)
        }
    }
    console.log(`Number results ${result.reports.length}`)
    console.log(result)
    res.send(result)
}

function readFile() {
    try {
        var result = fs.readFileSync('./data.json')
        return JSON.parse(result)
    } catch (e) {
        console.log(e)
    }
    return { users: []}
}

function writeFile(data) {
    fs.writeFile('./data.json', data, e => {
        if(e) console.log(e)
    })
}

function createNewUserId(data) {
    var result = ""
    for(var i = 0; i < 9; i++) {
        result += Math.floor(Math.random() * 10)
    }
    for(var i = 0; i < data.users.length; i++) {
        if(result === data.users[i]) {
            result = createNewUserId(data)
            break
        }
    }
    console.log(`Created new user ${result}`)
    return result
}

function createNewReportId(data, userNumber) {
    return data.users[userNumber].reports.length + 1
}

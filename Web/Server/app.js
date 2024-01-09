const express = require('express')
const fs = require('fs')
const cors = require('cors'); // Import the cors module

const app = express()
const port = 3000

app.use(cors()); // Enable CORS for all routes

app.use(express.json())

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
    const jsonData = require('./data.json');
    res.json(jsonData);
})

function newReport(req, res) {
    console.log('request to make new report sent')
    console.log(req.body)
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
    var userNumber = 0
    var user = null
    for(var i = 0; i < data.users.length; i++) {
        if(data.users[i].userId === userId) {
            user = data.users[i]
            userNumber = i
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
    user.reports.push(newReport)
    writeFile(JSON.stringify(data))
    res.send(newReport)
}

function sendReports(req, res) {
    var userId = req.body.userId
    var data = readFile()
    let result =  {
        reports: [] 
    }
    if(userId === "") {
        res.send(result)
        return
    }
    for(var i = 0; i < data.users.length; i++) {
        if(data.users[i].userId === userId) {
            result.reports = data.users[i].reports
        }
    }
    res.send(result)
}

function sendAllCoordinates(req, res) {
    let data = readFile()
    var userId = req.body.userId
    if(userId === "") {
        userId = createNewUserId(data)
        const newUser = {
            userId: userId,
            reports: []
        }
        data.users.push(newUser)
        writeFile(JSON.stringify(data))
    }
    let result = {
        reports: []
    }
    for(var i = 0; i < data.users.length; i++) {
        for(var j = 0; j < data.users[i].reports; j++) {
            result.reports.push(data.users[i].reports[j])
        }
    }
    res.send(result)
}

function readFile() {
    var result = fs.readFileSync('./data.json')
    return JSON.parse(result)
}

function writeFile(data) {
    fs.writeFileSync('./data.json', data, e => {
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
    return result
}

function createNewReportId(data, userNumber) {
    return data.users[userNumber].reports.length + 1
}

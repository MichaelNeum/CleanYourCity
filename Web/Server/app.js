const express = require('express')
const fs = require('fs')

const app = express()
const port = 3000

const initJsonFile = {
    users: [
        {
            identification: "123456789",
            reports: []
        },
        {
            identification: "987654321",
            reports: []
        }
    ]
}
app.get('/', (req, res) => {
    //writeFile(JSON.stringify(initJsonFile)) this was just for initialization of the json file
    res.json(readFile())
})

app.get('/send/report', async (req, res) => {
    newReport(req, res)
})

app.get('/get/myreports', async (req, res) => {
    sendReports(req, res)
})

app.get('/get/allreports', async (req, res) => {
    sendAllReports(req, res)
})

app.listen(port, () => {
    console.log(`Server running on port ${port}`)
})


function newReport(req, res) {
    res.send('new Report')
}

function sendReports(req, res) {
    res.send('this will return your Reports')
}

function sendAllReports(req, res) {
    res.send('this will send all the reports locations')
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

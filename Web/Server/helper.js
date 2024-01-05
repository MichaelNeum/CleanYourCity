
const fs = require('fs')

function readFile() {
    var result = fs.readFileSync('./data.json')
    return JSON.parse(result)
}

function writeFile(data) {
    fs.writeFileSync('./data.json', data, e => {
        if(e) console.log(e)
    })
}
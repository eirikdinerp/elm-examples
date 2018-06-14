var express = require('express')
var cors = require('cors')
var bodyParser = require('body-parser')
var app = express()

app.use(cors())
app.use(bodyParser.json())

app.post('/api/contact', (req, res, next) => {
    console.log(`Received: ${JSON.stringify(req.body)}`)
    res.json("OK")
})

app.listen(3000, () => console.log('Listening on http://localhost:3000'))
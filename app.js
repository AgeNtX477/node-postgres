const express = require('express')
const employeeRouter = require('./routs/rout.employee.js')
const reportRouter = require('./routs/rout.report.js')

const PORT = 3000

const app = express()

app.use(express.json()) // body parsing

app.use('/api', employeeRouter)
app.use('/api', reportRouter)


app.listen(PORT, () => {
    console.log('App running on port: ' + PORT) 
});
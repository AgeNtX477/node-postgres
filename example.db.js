const Pool = require('pg').Pool

const pool = new Pool({
    user: '',
    password: '',
    host: '',
    port: 5432, // default port
    database: ''

})


module.exports = pool;
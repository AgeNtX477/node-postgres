const db = require('../db')

class EmployeeController {
  async createEmployer (req, res) {
    const {
      first_name,
      last_name,
      gender,
      email,
      date_of_birth,
      country_of_birth
    } = req.body

    const newEmployer = await db.query(
      `INSERT INTO employee (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [first_name, last_name, gender, email, date_of_birth, country_of_birth]
    )
    res.json(newEmployer.rows[0])
  }

  async getEmployers (req, res) {
    const employers = await db.query(`SELECT * FROM employee`)
    res.json(employers.rows)
  }

  async getEmployerById (req, res) {
    const id = req.params.id
    const employer = await db.query(`SELECT * FROM employee WHERE id = $1`, [
      id
    ])
    res.json(employer.rows[0])
  }

  async updateEmployer (req, res) {
    const {
      id,
      first_name,
      last_name,
      gender,
      email,
      date_of_birth,
      country_of_birth
    } = req.body

    const employer = await db.query(
      `UPDATE employee set first_name = $1, last_name = $2, gender = $3, email = $4, date_of_birth = $5, country_of_birth = $6 where id = $7 RETURNING *`,
      [
        first_name,
        last_name,
        gender,
        email,
        date_of_birth,
        country_of_birth,
        id
      ]
    )

    res.json(employer.rows[0])
  }

  async deleteEmployer (req, res) {
    const id = req.params.id
    const employer = await db.query(`DELETE FROM employee WHERE id = $1`, [id])
    res.json(employer.rows[0])
  }
}

module.exports = new EmployeeController()

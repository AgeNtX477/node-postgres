const db = require('../db')

class ReportController {
  async createReport (req, res) {
    const { report_title, report_content, user_id } = req.body

    const newReport = await db.query(
      `INSERT INTO report (report_title, report_content, user_id) values ($1, $2, $3) RETURNING *`,
      [report_title, report_content, user_id]
    )
        
    res.json(newReport.rows[0])
  }

  async getReportByUserId (req, res) {
    const id = req.query.id
    const reports = await db.query(`SELECT * from report where user_id = $1`, [id])
    // http://localhost:3000/api/report?id=`${id}`
    res.json(reports.rows)
  }
}

module.exports = new ReportController()

const Router = require('express');
const router = new Router();
const reportController = require('../controllers/controller.report.js')

router.post('/report', reportController.createReport)
router.get('/report', reportController.getReportByUserId)


module.exports = router
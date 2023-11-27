const Router = require('express');
const router = new Router();
const employeeController = require('../controllers/controller.employee.js')

router.post('/employee', employeeController.createEmployer)
router.get('/employee', employeeController.getEmployers)
router.get('/employee/:id', employeeController.getEmployerById)
router.put('/employee', employeeController.updateEmployer)
router.delete('/employee/:id', employeeController.deleteEmployer)


module.exports = router
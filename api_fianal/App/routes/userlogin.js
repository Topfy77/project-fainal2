module.exports = app => {

 
    const user = require("../controllers/userController")
   console.log(req.body)
    app.post("/users", user.create);
    app.post("/users/login", user.login);
  
  };
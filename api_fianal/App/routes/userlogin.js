module.exports = app => {

 
    const user = require("../controllers/userController")

    app.post("/users", user.create);
    app.post("/users/login", user.login);
  
  };
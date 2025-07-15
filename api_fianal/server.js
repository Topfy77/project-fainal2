const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
const port = 3000;

const productRoutes = require("./App/routes/productRoutes");
const userRoutes = require("./App/routes/userRoutes");

app.use(cors());
app.use(bodyParser.json());

app.use("/api/products", productRoutes);
app.use("/api/users", userRoutes); 

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

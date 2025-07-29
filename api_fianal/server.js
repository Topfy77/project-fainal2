const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();  // ประกาศ app ก่อน

app.use(express.json());  // ควรเรียกใช้หลังประกาศ app
app.use(cors());
app.use(bodyParser.json());

const productRoutes = require("./App/routes/productRoutes");
const userRoutes = require("./App/routes/userRoutes");
app.use("/users", userRoutes);
app.use("/api/products", productRoutes);
app.use("/api/users", userRoutes); 
app.use("/uploads", express.static("uploads"));


const port = 3000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

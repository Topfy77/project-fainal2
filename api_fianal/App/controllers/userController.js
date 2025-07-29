const User = require("../models/userModel");
const jwt = require("jsonwebtoken");
const SECRET_KEY = "your_secret_key"; // แนะนำให้เก็บในไฟล์ .env และอ่านค่าออกมา

exports.getAll = (req, res) => {
  User.getAllUsers((err, result) => {
    if (err) res.status(500).send(err);
    else res.json(result);
  });
};

exports.getById = (req, res) => {
  User.getUserById(req.params.id, (err, result) => {
    if (err) res.status(500).send(err);
    else res.json(result[0]);
  });
};

exports.create = (req, res) => {
  User.createUser(req.body, (err, result) => {
    if (err) res.status(500).send(err);
    else res.json({ message: "User created", id: result.insertId });
  });
};

exports.update = (req, res) => {
  User.updateUser(req.params.id, req.body, (err, result) => {
    if (err) res.status(500).send(err);
    else res.json({ message: "User updated" });
  });
};

exports.delete = (req, res) => {
  User.deleteUser(req.params.id, (err, result) => {
    if (err) res.status(500).send(err);
    else res.json({ message: "User deleted" });
  });
};

exports.login = (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: "กรุณากรอกอีเมลและรหัสผ่าน" });
    }

    User.getUserByEmail(email, (err, result) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
      }

      if (!result || result.length === 0) {
        return res.status(401).json({ success: false, message: "อีเมลไม่ถูกต้อง" });
      }

      const user = result[0];
      if (user.password === password) {
        // สร้าง JWT token
        const payload = { id: user.id, email: user.email };
        const token = jwt.sign(payload, SECRET_KEY, { expiresIn: "1h" });

        // ตัด password ออกก่อนส่งกลับ
        const { password, ...userWithoutPassword } = user;

        return res.json({ success: true, token, user: userWithoutPassword });
      }

      return res.status(401).json({ success: false, message: "รหัสผ่านไม่ถูกต้อง" });
    });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

exports.register = async (req, res) => {
  const { username, password, email, tel } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    User.createUser({ username, password: hashedPassword, email, tel }, (err, result) => {
      if (err) return res.status(500).json({ message: "Register failed", error: err });
      res.status(201).json({ message: "Register success", user_id: result.insertId });
    });
  } catch (err) {
    res.status(500).json({ message: "Error hashing password", error: err });
  }
};

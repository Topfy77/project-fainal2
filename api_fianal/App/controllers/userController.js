const User = require("../models/userModel");

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
    const { username, password } = req.body;
    if (!username || !password) {
      return res.status(400).json({ success: false, message: "กรุณากรอก username และ password" });
    }

    User.getUserByUsername(username, (err, result) => {
      if (err) {
        console.error("Database error:", err);
        return res.status(500).json({ success: false, message: "Server error" });
      }
      if (!result || result.length === 0) {
        return res.status(401).json({ success: false, message: "ชื่อผู้ใช้ไม่ถูกต้อง" });
      }

      const user = result[0];
      if (user.password === password) {
        return res.json({ success: true, user });
      }
      return res.status(401).json({ success: false, message: "รหัสผ่านไม่ถูกต้อง" });
    });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};
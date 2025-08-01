import axios from "axios";
import React, { useState } from "react";
import { TextField, Button, Typography, Container } from "@mui/material";
import { useNavigate } from "react-router-dom";

const RegisterPage = () => {
  const [form, setForm] = useState({
    username: "",
    password: "",
    email: "",
    tel: "",
  });

  const navigate = useNavigate();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async () => {
    try {
      await axios.post("http://localhost:3000/users/register", form);
      alert("ສະຫມັກຜູ້ໄຊ້ສະເລັດ");
     
    } catch (error) {
      console.error("❌ Register failed:", error.response?.data || error.message);
      alert("ເກີດຂໍ້ຜຶດພາດໃນການສະຫມັກຜູ້ໄຊ້");
    }
  };

  return (
    <Container maxWidth="xs">
      <Typography variant="h5">Register</Typography>
      <TextField name="username" label="Username" fullWidth margin="normal" onChange={handleChange} />
      <TextField name="password" label="Password" type="password" fullWidth margin="normal" onChange={handleChange} />
      <TextField name="email" label="Email" fullWidth margin="normal" onChange={handleChange} />
      <TextField name="tel" label="Tel" fullWidth margin="normal" onChange={handleChange} />
      <Button variant="contained" fullWidth sx={{ mt: 2 }} onClick={handleSubmit}>
        Sing in
      </Button>
        <Button fullWidth variant="text" onClick={() => navigate("/")} sx={{ mt: 2 }}>
                Back
              </Button>
    </Container>
  );
};

export default RegisterPage;

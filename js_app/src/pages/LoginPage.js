import React, { useState } from "react";
import {
  Container,
  TextField,
  Button,
  Typography,
  Box,
} from "@mui/material";
import { useNavigate } from "react-router-dom";
import { login } from "../services/api";

const LoginPage = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleLogin = async () => {
    try {
      const res = await login(email, password); 
       console.log("Login response:", res.data); 
      const token = res.data.token;
      const user = res.data.user;
  if (token && user?.user_id && user?.username) {
      localStorage.setItem("token", token);
      localStorage.setItem("user_id", user.user_id); 
      localStorage.setItem("username",user.username);
      navigate("/home");
      } else {
        alert("Login failed: Token or user ID not received");
      }
    } catch (err) {
      console.error("Login failed:", err.response?.data || err.message);
      alert("Login failed: " + (err.response?.data?.message || err.message));
    }
  };

  return (
    <Container maxWidth="sm">
      <Box mt={10} p={4} boxShadow={3} borderRadius={2}>
        <Typography variant="h4" gutterBottom align="center">
          Login
        </Typography>
        <TextField
          fullWidth
          label="Email"
          margin="normal"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <TextField
          fullWidth
          label="Password"
          type="password"
          margin="normal"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        <Button
          fullWidth
          variant="contained"
          onClick={handleLogin}
          sx={{ mt: 2 }}
        >
          LOGIN
        </Button>
        <Button fullWidth variant="text" onClick={() => navigate("/register")} sx={{ mt: 2 }}>
          Register
        </Button>
        
      </Box>
    </Container>
    
  );
};

export default LoginPage;

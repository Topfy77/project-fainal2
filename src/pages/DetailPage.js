import React from "react";
import { useLocation, useNavigate } from "react-router-dom";
import {
  Box,
  Typography,
  Button,
 
  IconButton
} from "@mui/material";
import MenuIcon from "@mui/icons-material/Menu";
import Navbar from "../components/Navbar";

function DetailPage() {
  const { state } = useLocation();
  const [menuOpen, setMenuOpen] = React.useState(false);
  const navigate = useNavigate();

  return (
    <Box>
      <Box sx={{ display: "flex", alignItems: "center", p: 2 }}>
        <IconButton onClick={() => setMenuOpen(true)}>
          <MenuIcon />
        </IconButton>
        <Typography variant="h4" sx={{ ml: 2 }}>
         Detail products
        </Typography>
      </Box>

      <Box sx={{ p: 3 }}>
        <Typography variant="h5">Name: {state?.name}</Typography>
        <Typography variant="h6">Price: {state?.price} </Typography>
      </Box>

      <Navbar open={menuOpen} onClose={() => setMenuOpen(false)} />

      <Button variant="text" onClick={() => navigate("/home")}>
        Back
      </Button>
      <Button variant="contained">Buy</Button>
    </Box> 
    
  );
}

export default DetailPage;


import React, { useEffect, useState } from "react";
import {
  Container,
  Grid,
  Card,
  CardContent,
  Typography,
  Box,
  IconButton,
  Button
} from "@mui/material";
import MenuIcon from "@mui/icons-material/Menu";
import Navbar from "../components/Navbar";
import { getAllProducts } from "../services/api";
import { useNavigate } from "react-router-dom";

const HomePage = () => {
  const [products, setProducts] = useState([]);
  const [menuOpen, setMenuOpen] = useState(false); 
  const navigate = useNavigate();

  useEffect(() => {
    getAllProducts().then((res) => {
      console.log(res.data); 
      setProducts(res.data);
    });
  }, []);

  return (
    <Box>
      <Box sx={{ display: "flex", alignItems: "center", p: 2 }}>
        <IconButton onClick={() => setMenuOpen(true)}>
          <MenuIcon />
        </IconButton>
        <Typography variant="h4" sx={{ ml: 2 }}>
          All Products
        </Typography>
      </Box>

      <Navbar open={menuOpen} onClose={() => setMenuOpen(false)} />

      <Container sx={{ mt: 2 }}>
        <Grid container spacing={2}>
          {products.map((p) => (
            <Grid item xs={12} sm={6} md={4} key={p.id}>
              <Card>
                <img
                  src={`http://localhost:3000/uploads/${p.photo}`}  
                  alt={p.pro_name}
                  style={{ width: "70%", height: "70%", objectFit: "cover" }}
                />
                <CardContent>
                  <Typography>Name: {p.pro_name}</Typography>
                  <Typography>Price: {p.pro_price}</Typography>
                  <Button
                    fullWidth
                    variant="contained"
                    onClick={() =>
                      navigate("/detail", {
                        state: {
                          name: p.pro_name,
                          price: p.pro_price,
                        },
                      })
                    }
                  >
                    Buy
                  </Button>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
};

export default HomePage;

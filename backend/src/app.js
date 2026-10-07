const express = require('express');
const cors = require('cors');
require('dotenv').config();

const usuariosRoutes = require('./routes/usuarios');
const ocorrenciasRoutes = require('./routes/ocorrencias');

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' })); // limite maior por causa da foto em base64

app.use('/api/usuarios', usuariosRoutes);
app.use('/api/ocorrencias', ocorrenciasRoutes);

app.get('/', (req, res) => res.json({ status: 'API rodando' }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`API rodando em http://localhost:${PORT}`));

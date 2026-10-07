const express = require('express');
const router = express.Router();
const pool = require('../models/db');

router.post('/login', async (req, res) => {
  const { email, nome } = req.body;

  if (!email) {
    return res.status(400).json({ erro: 'Email é obrigatório' });
  }

  try {
    let result = await pool.query('SELECT * FROM usuario WHERE email = $1', [email]);

    let usuario;
    if (result.rows.length === 0) {
      const insert = await pool.query(
        'INSERT INTO usuario (nome, email, tipo) VALUES ($1, $2, $3) RETURNING *',
        [nome || 'Usuário', email, 'cidadao']
      );
      usuario = insert.rows[0];
    } else {
      usuario = result.rows[0];
    }

    res.json({
      token: 'token-fake-' + usuario.id,
      usuario_id: usuario.id,
      nome: usuario.nome,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ erro: 'Erro ao fazer login' });
  }
});

module.exports = router;

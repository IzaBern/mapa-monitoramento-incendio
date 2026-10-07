const express = require('express');
const router = express.Router();
const pool = require('../models/db');

// Registrar foco
router.post('/', async (req, res) => {
  const { usuario_id, latitude, longitude, tipo_vegetacao, foto_base64 } = req.body;

  try {
    const insert = await pool.query(
      `INSERT INTO ocorrencia (id_usuario, latitude, longitude, tipo_vegetacao)
       VALUES ($1, $2, $3, $4) RETURNING *`,
      [usuario_id || null, latitude, longitude, tipo_vegetacao]
    );
    const ocorrencia = insert.rows[0];

    if (foto_base64) {
      await pool.query(
        'INSERT INTO imagem (id_ocorrencia, url_arquivo) VALUES ($1, $2)',
        [ocorrencia.id, foto_base64]
      );
    }

    res.json({
      id: ocorrencia.id,
      status: ocorrencia.status,
      mensagem: 'Foco registrado com sucesso',
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ erro: 'Erro ao registrar ocorrência' });
  }
});

// Listar focos
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT o.id, o.latitude, o.longitude, o.tipo_vegetacao, o.status, o.data_hora,
             i.url_arquivo AS foto_url
      FROM ocorrencia o
      LEFT JOIN imagem i ON i.id_ocorrencia = o.id
      ORDER BY o.data_hora DESC
    `);
    res.json({ focos: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ erro: 'Erro ao listar ocorrências' });
  }
});

module.exports = router;

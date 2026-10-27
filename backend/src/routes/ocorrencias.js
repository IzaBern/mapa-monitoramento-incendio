const express = require('express');
const router = express.Router();
const pool = require('../models/db');

// Registrar foco
router.post('/', async (req, res) => {
  const { usuario_id, latitude, longitude, tipo_vegetacao, foto_base64 } = req.body;

  const lat = Number(latitude);
  const lng = Number(longitude);
  if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
    return res.status(400).json({ erro: 'Latitude e longitude são obrigatórias' });
  }

  try {
    const insert = await pool.query(
      `INSERT INTO ocorrencia (id_usuario, latitude, longitude, tipo_vegetacao)
       VALUES ($1, $2, $3, $4) RETURNING *`,
      [usuario_id || null, lat, lng, tipo_vegetacao]
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
      SELECT o.id, o.id_usuario AS usuario_id, o.latitude, o.longitude, o.tipo_vegetacao, o.status, o.data_hora,
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

// Alterar status (verificador, autoridade e admin usam este endpoint)
const STATUS_VALIDOS = ['pendente', 'verificado', 'negado', 'mobilizada', 'concluida'];

router.patch('/:id/status', async (req, res) => {
  const { status } = req.body;

  if (!STATUS_VALIDOS.includes(status)) {
    return res.status(400).json({ erro: `Status inválido. Use: ${STATUS_VALIDOS.join(', ')}` });
  }

  try {
    const result = await pool.query(
      'UPDATE ocorrencia SET status = $1 WHERE id = $2 RETURNING id, status',
      [status, req.params.id]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ erro: 'Ocorrência não encontrada' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ erro: 'Erro ao alterar status' });
  }
});

module.exports = router;

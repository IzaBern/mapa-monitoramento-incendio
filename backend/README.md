# 🔥 Backend - Monitoramento de Incêndios (Goiás)

API REST em Node.js + Express, conectada a um banco PostgreSQL, responsável por autenticação simplificada, registro de ocorrências de incêndio e listagem para o mapa.

## Stack

- Node.js + Express
- PostgreSQL 18
- Dependências: `express`, `pg`, `cors`, `dotenv`, `nodemon` (dev)

## Pré-requisitos

- Node.js LTS instalado (`node -v` para conferir)
- PostgreSQL instalado e rodando como serviço do Windows
- Banco `incendios` criado com as tabelas `usuario`, `ocorrencia` e `imagem` (ver `docs/schema.sql` ou seção abaixo)

## Setup

```bash
cd backend
npm install
```

Crie um arquivo `.env` na raiz de `backend/` (não é versionado no Git):

```
DATABASE_URL=postgresql://postgres:SUASENHA@localhost:5432/incendios
PORT=3000
```

## Rodando

```bash
npm run dev
```

A API sobe em `http://localhost:3000`. Para outro dispositivo na mesma rede (celular físico, por exemplo), use o IP local da máquina (`ipconfig` → IPv4) no lugar de `localhost`.

## Endpoints

### `POST /api/usuarios/login`
Login simplificado (sem senha real): se o e-mail não existe, cria o usuário na hora.

```json
// Request
{ "email": "user@example.com", "nome": "Usuário" }

// Response
{ "token": "token-fake-1", "usuario_id": 1, "nome": "Usuário" }
```

### `POST /api/ocorrencias`
Registra um novo foco de incêndio.

```json
// Request
{
  "usuario_id": 1,
  "latitude": -15.8267,
  "longitude": -48.2833,
  "tipo_vegetacao": "cerrado",
  "foto_base64": "data:image/jpeg;base64,..."
}

// Response
{ "id": 1, "status": "pendente", "mensagem": "Foco registrado com sucesso" }
```

### `GET /api/ocorrencias`
Lista todas as ocorrências registradas (usado pelo mapa).

```json
// Response
{
  "focos": [
    {
      "id": 1,
      "latitude": -15.8267,
      "longitude": -48.2833,
      "tipo_vegetacao": "cerrado",
      "status": "pendente",
      "data_hora": "2026-10-07T10:30:00.000Z",
      "foto_url": "data:image/jpeg;base64,..."
    }
  ]
}
```

## Schema do banco

```sql
CREATE TABLE usuario (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  email VARCHAR(255) UNIQUE NOT NULL,
  senha_hash VARCHAR(255),
  tipo VARCHAR(50) DEFAULT 'cidadao',
  data_cadastro TIMESTAMP DEFAULT NOW()
);

CREATE TABLE ocorrencia (
  id SERIAL PRIMARY KEY,
  id_usuario INTEGER REFERENCES usuario(id),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  tipo_vegetacao VARCHAR(100),
  status VARCHAR(50) DEFAULT 'pendente',
  data_hora TIMESTAMP DEFAULT NOW(),
  observacoes TEXT
);

CREATE TABLE imagem (
  id SERIAL PRIMARY KEY,
  id_ocorrencia INTEGER REFERENCES ocorrencia(id),
  url_arquivo TEXT,
  data_hora_exif TIMESTAMP DEFAULT NOW()
);
```

## Estrutura

```
backend/
├── src/
│   ├── routes/
│   │   ├── usuarios.js
│   │   └── ocorrencias.js
│   ├── models/
│   │   └── db.js
│   └── app.js
├── .env           (não versionado)
├── .gitignore
└── package.json
```

## Limitações conhecidas (Sprint 0)

Cortes intencionais para entregar o protótipo no prazo — não é a versão final:

- Login não valida senha (apenas encontra ou cria o usuário pelo e-mail)
- Sem autenticação gov.br / JWT real
- Imagem armazenada como base64 direto no banco (não em storage externo)
- Sem verificação por administrador implementada ainda
- Sem testes automatizados

## Problemas comuns

| Sintoma | Causa provável |
|---|---|
| `ECONNREFUSED` ao iniciar | Serviço do PostgreSQL não está rodando |
| `password authentication failed` | Senha do `.env` não bate com a definida na instalação do PostgreSQL |
| `relation "ocorrencia" does not exist` | Tabelas não foram criadas no banco `incendios` |
| App Flutter não conecta | Confira se está usando o IP local (não `localhost`) e se o firewall do Windows liberou o Node.js |
| Erro de CORS | Confirme que `app.use(cors())` está antes das rotas em `app.js` |

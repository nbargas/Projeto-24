const express = require('express');
const app = express();

app.use(express.json());

let veiculos = [
  { id: 1, placa: "ABC-1234", montadora: "Scania", modelo: "R450", status: "DISPONIVEL" },
  { id: 2, placa: "XYZ-9876", montadora: "Volvo", modelo: "FH 540", status: "EM_MANUTENCAO" }
];

app.get('/api/v1/health', (req, res) => {
  res.json({
    status: "ok",
    uptime: process.uptime(),
    memory: process.memoryUsage()
  });
});

app.get('/api/v1/veiculos', (req, res) => {
  res.json(veiculos);
});

app.post('/api/v1/veiculos', (req, res) => {
  const novoVeiculo = { id: Date.now(), ...req.body };
  veiculos.push(novoVeiculo);
  res.status(201).json(novoVeiculo);
});

app.put('/api/v1/veiculos/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const index = veiculos.findIndex(v => v.id === id);
  if (index !== -1) {
    veiculos[index] = { id, ...req.body };
    return res.json(veiculos[index]);
  }
  res.status(404).json({ message: "Veículo não encontrado" });
});

app.patch('/api/v1/veiculos/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const veiculo = veiculos.find(v => v.id === id);
  if (veiculo) {
    Object.assign(veiculo, req.body);
    return res.json(veiculo);
  }
  res.status(404).json({ message: "Veículo não encontrado" });
});

app.delete('/api/v1/veiculos/:id', (req, res) => {
  const id = parseInt(req.params.id);
  veiculos = veiculos.filter(v => v.id !== id);
  res.status(204).send();
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});

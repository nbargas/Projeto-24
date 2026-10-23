#!/bin/bash
# Uso: ./teste_crud.sh [PORTA] [URL_HOST]
# Ex.: ./teste_crud.sh 4000
#      ./teste_crud.sh 5000 http://127.0.0.1
PORT=${1:-3000}
HOST=${2:-http://localhost}
BASE_URL="${HOST}:${PORT}/api/v1"

command -v jq >/dev/null || { echo "jq nao instalado: sudo apt install jq"; exit 1; }

echo "=== TESTANDO HEALTH (${BASE_URL}) ==="
curl -s "${BASE_URL}/health" | jq
echo

echo "=== CRIANDO VEICULO (POST) ==="
POST_RES=$(curl -s -X POST "${BASE_URL}/veiculos" \
  -H "Content-Type: application/json" \
  -d '{"placa":"TEST-9999","montadora":"Mercedes","modelo":"Actros","status":"DISPONIVEL"}')
echo "$POST_RES" | jq

ID=$(echo "$POST_RES" | jq -r '.id // .veiculo.id // empty')
if [ -z "$ID" ]; then
  echo "ERRO: nao foi possivel capturar o ID do POST."
  exit 1
fi
echo "ID Gerado: $ID"
echo

echo "=== ATUALIZANDO STATUS (PATCH) ==="
curl -s -X PATCH "${BASE_URL}/veiculos/${ID}/status" \
  -H "Content-Type: application/json" \
  -d '{"status":"EM_ROTA"}' | jq
echo

echo "=== SUBSTITUINDO VEICULO (PUT) ==="
curl -s -X PUT "${BASE_URL}/veiculos/${ID}" \
  -H "Content-Type: application/json" \
  -d '{"placa":"TEST-9999","montadora":"Scania","modelo":"R450","status":"MANUTENCAO"}' | jq
echo

echo "=== REMOVENDO VEICULO (DELETE) ==="
curl -s -X DELETE "${BASE_URL}/veiculos/${ID}" -w "\nHTTP Status: %{http_code}\n"
echo
echo "Processo concluido."

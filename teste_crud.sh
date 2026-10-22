#!/bin/bash
PORT=${1:-3000}
BASE_URL="http://localhost:${PORT}/api/v1"

echo "=== TESTANDO HEALTH ==="
curl -s "${BASE_URL}/health"
echo -e "\n"

echo "=== CRIANDO VEÍCULO (POST) ==="
POST_RES=$(curl -s -X POST "${BASE_URL}/veiculos" -H "Content-Type: application/json" -d '{"placa":"TEST-9999","montadora":"Mercedes","modelo":"Actros","status":"DISPONIVEL"}')
echo "$POST_RES"

ID=$(echo "$POST_RES" | jq -r '.id')
echo -e "\nID Gerado: $ID"

echo "=== ATUALIZANDO VEÍCULO (PATCH) ==="
curl -s -X PATCH "${BASE_URL}/veiculos/${ID}" -H "Content-Type: application/json" -d '{"status":"EM_VIAGEM"}'
echo -e "\n"

echo "=== REMOVENDO VEÍCULO (DELETE) ==="
curl -s -X DELETE "${BASE_URL}/veiculos/${ID}"
echo -e "\nProcesso concluído."

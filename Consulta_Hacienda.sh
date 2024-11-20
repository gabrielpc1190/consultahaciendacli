#!/bin/bash

# Recibir la IDENTIFICACION como argumento
IDENTIFICACION="$1"
API_URL="https://api.hacienda.go.cr/fe/ae?identificacion=$IDENTIFICACION"
OUTPUT_FILE="respuesta.json"

# Configurar el User-Agent para simular un navegador moderno
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"

echo "Consultando el estado del contribuyente con identificación: $IDENTIFICACION..."

# Ejecutar la solicitud cURL con el User-Agent personalizado
RESPONSE=$(curl -s -w "%{http_code}" -A "$USER_AGENT" -X GET "$API_URL" -H "Content-Type: application/json" -o "$OUTPUT_FILE")
HTTP_STATUS=${RESPONSE: -3}

# Verificar el código de estado HTTP
if [ "$HTTP_STATUS" -eq 200 ]; then
    cat "$OUTPUT_FILE"
elif [ "$HTTP_STATUS" -eq 404 ]; then
    echo "Error: No se encontró información para la identificación: $IDENTIFICACION."
    exit 1
else
    echo "Error al consumir la API. Código HTTP: $HTTP_STATUS"
    exit 1
fi

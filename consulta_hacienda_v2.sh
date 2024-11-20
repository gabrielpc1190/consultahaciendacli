#!/bin/bash

# Recibir la IDENTIFICACION como argumento
IDENTIFICACION="$1"
API_URL="https://api.hacienda.go.cr/fe/ae?identificacion=$IDENTIFICACION"
CACHE_FILE="cache.json"  # Archivo de caché

# Configurar el User-Agent para simular un navegador moderno
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, como Gecko) Chrome/119.0.0.0 Safari/537.36"

# Verificar si el archivo de caché existe
if [ ! -f "$CACHE_FILE" ]; then
    echo "{}" > "$CACHE_FILE"
fi

# Buscar en la caché
CACHE_RESULT=$(jq -r --arg id "$IDENTIFICACION" '.[$id]' "$CACHE_FILE")

# Si existe en la caché, verificar la fecha de expiración
if [ "$CACHE_RESULT" != "null" ]; then
    # Extraer la fecha de actualización
    LAST_UPDATED=$(echo "$CACHE_RESULT" | jq -r '.last_updated')
    CURRENT_DATE=$(date +%s)

    # Calcular si han pasado más de 7 días (604800 segundos)
    SEVEN_DAYS_AGO=$((CURRENT_DATE - 604800))

    if [ "$LAST_UPDATED" -ge "$SEVEN_DAYS_AGO" ]; then
        echo "Datos obtenidos desde la caché:"
        echo "$CACHE_RESULT" | jq '.data'
        exit 0
    fi
fi

# Si no está en la caché o ha expirado, hacer la solicitud al API
echo "Consultando el estado del contribuyente con identificación: $IDENTIFICACION..."
RESPONSE=$(curl -s -w "%{http_code}" -A "$USER_AGENT" -X GET "$API_URL" -H "Content-Type: application/json" -o respuesta.json)
HTTP_STATUS=${RESPONSE: -3}

# Verificar el código de estado HTTP
if [ "$HTTP_STATUS" -eq 200 ]; then
    DATA=$(cat respuesta.json)
    echo "Datos obtenidos del API:"
    echo "$DATA"

    # Guardar en la caché
    CURRENT_DATE=$(date +%s)
    jq --arg id "$IDENTIFICACION" --argjson data "$DATA" --argjson timestamp "$CURRENT_DATE" \
       '.[$id] = {data: $data, last_updated: $timestamp}' "$CACHE_FILE" > tmp.json && mv tmp.json "$CACHE_FILE"

elif [ "$HTTP_STATUS" -eq 404 ]; then
    echo "Error: No se encontró información para la identificación: $IDENTIFICACION."
    exit 1
else
    echo "Error al consumir la API. Código HTTP: $HTTP_STATUS"
    exit 1
fi

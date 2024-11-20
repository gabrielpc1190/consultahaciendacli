# Consulta el estado de una identificación contra el servidor de Hacienda usando el API público

Consulta el estado de una identificación desde la línea de comandos de linux.

Para probar el script desde la línea de comandos en Linux, puedes ejecutarlo pasando el parámetro IDENTIFICACION directamente. Aquí están los pasos:

1. Asegúrate de que el script es ejecutable Si aún no lo has hecho, dale permisos de ejecución al script:
```chmod +x Consulta_Hacienda.sh```

3. Ejecuta el script desde la línea de comandos Usa el siguiente comando para pasar la identificación como argumento:
```./Consulta_Hacienda.sh 123456789```

En este caso, 123456789 es la identificación que quieres consultar. Cambia este valor según sea necesario.

Si todo está correcto, deberías ver la respuesta del API o un mensaje indicando el estado de la consulta.

```Consultando el estado del contribuyente con identificación: 123456789...
{
  "nombre": "NOMBRE DEL TIPO MILLONARIO AQUI",
  "tipoIdentificacion": "01",
  "regimen": {
    "codigo": 1,
    "descripcion": "Régimen General"
  },
  "situacion": {
    "moroso": "NO",
    "omiso": "NO",
    "estado": "Inscrito",
    "administracionTributaria": "Zona Sur"
  },
  "actividades": [
    {
      "estado": "A",
      "tipo": "P",
      "codigo": "721001",
      "descripcion": "CONSULTORES INFORMATICOS"
    },
    {
      "estado": "A",
      "tipo": "S",
      "codigo": "523902",
      "descripcion": "VENTA AL POR MENOR DE SUMINISTROS Y/0 EQUIPO DE OFICINA"
    }
  ]
}
```

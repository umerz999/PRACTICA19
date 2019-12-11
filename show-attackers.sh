#!/bin/bash
https://github.com/umerz999/PRACTICA19/blob/master/show-attackers.sh
readonly LIMIT='10'
LOG_FILE="${1}"

#Asegurarse que se puesto un fichero de parametro correcto
if [[ ! -e "${LOG_FILE}" ]]
then
  echo "El fichero no existe en este directorio o no has puesto ningún fichero: ${LOG_FILE}" >&2
  exit 1
fi

# Mostrar Información
echo 'Count,IP,Location'

# Bucle listando y buscando por IPs.
grep Failed syslog-sample | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" \
| sort | uniq -c | while read COUNT IP; do
  # Si el número de intentos fallidos es mayor que LIMIT
  if [ "${COUNT}" -gt "${LIMIT}" ]; then
      LOCATION=$(geoiplookup "${IP}" | awk -F ', ' '{print $2}')
      echo "${COUNT},${IP},${LOCATION}"
  fi
done


exit 0

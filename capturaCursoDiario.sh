#!/bin/bash
# Script para capturar e encaminhar via e-mail, todos os cursos disponíveis no site SENAC Bauru
# No caso configurei à crontab do servidor da seguinte maneira:
# 00 */1 * * * /capturaCursoDiario.sh

touch cursosresumo
touch cursosresumotmp

links="$(curl -s "http://www.sp.senac.br/jsp/default.jsp?newsID=DYNAMIC,oracle.br.dataservers.GratDataServer16,selectCourses&unit=BAU&template=1575.dwt&testeira=349" | grep --text ",selectCourse&course=" | sed "s/'<a href=/$/" | cut -d "$" -f2 | cut -d '"' -f2 | sed "s/'+currUnit+'/BAU/")"

for l in $links; do
	curso="$(curl -s "http://www.sp.senac.br$l" | grep --text 'id="nmCourse"' | cut -d '>' -f2 | cut -d '<' -f1)"
	echo "$curso|$l" >> cursosresumo	 		
done

dos2unix cursosresumo 2>/dev/null
dos2unix cursosresumotmp 2>/dev/null

for a in $(cat -v cursosresumo | tr " " "$" | tr "\n" " "); do
	c="$(echo "$a" | sed "s/M-a/a/" | sed "s/M-s/o/" | sed "s/M-g/c/" | sed "s/M-c/a/" | sed "s/M-m/i/" | sed "s/M-gM-c/ca/" | sed "s/M-\`/a/" | sed "s/M-i/e/" | tr "$" " " | cut -d "|" -f1)"
	l="$(echo "$a" | tr "$" " " | cut -d "|" -f2)"
	echo -e  "Curso: $c \t Link-> http://www.sp.senac.br$l" >> cursosresumotmp 	
done

echo "$(cat cursosresumotmp)" | mail -s "Resumo Diario - Cursos Disponiveis - $(date +%d/%m/%y) " -r seuusuario seuemail@seudominio.com

sleep 10

rm cursosresumo
rm cursosresumotmp 

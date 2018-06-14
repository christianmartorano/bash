#!/bin/bash

#Layout do arquivo NOME;CPF;EMAIL

if [ "$1" == "" ]; then
  echo "[+] Nao foi passado arquivo de e-mails."
  exit
fi

rm emailsvalidos.txt 2>/dev/null
touch emailsvalidos.txt

regex="[a-z0-9_.%+-]+@[a-z0-9.-]+\.[a-z]{2,}"

echo "[+] Aguarde capturando e-mails validos."
echo -e "CLIENTE;CPF;EMAIL;DOMINIO\r" >> emailsvalidos.txt

qtdreg="$(($(wc -l "$1" | cut -d " " -f1)/40 | bc))"

for l in $(cat "$1" | tr " " "$" | tr "\n" " ");do
  let count++
  cliente="$(echo "$l" | cut -d ";" -f2 | tr "$" " ")"
  cpf="$(echo "$l" | cut -d ";" -f1)"
  email="$(echo "$l" | cut -d ";" -f3 | tr "[A-Z]" "[a-z]" | tr -d "\r")"
  dominio="$(echo "$email" | cut -d "@" -f2)"
  qtd="$(echo -n $email | tr "@" "\n" | wc -l)"
  if [[ "$email" =~ $regex ]] && [ "$qtd" -eq 1 ]; then
    echo -e "$cliente;$cpf;$email;$dominio\r" >> emailsvalidos.txt
  fi
  if [ "$count" -gt "$qtdreg" ]; then
    echo -n "#";
    let count=0;
  fi
done

unix2dos emailsvalidos.txt 2>/dev/null

echo

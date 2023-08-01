#!/bin/bash

### dekaltuje domyslny port i pomocniczy atgument
port=8080
health_flag=null
echo "$health_flag"
### przechwytuje argumenty dodane podczas uruchamiania skryptu (nie portafilem poradzic sobeie z długimi argumentami)
while getopts "p:h" option; do
  case $option in
    p)
      port="$OPTARG";;
    h)
      health_flag=true;;
    *)
      echo "Usage: $0 [-p port_number] [-h healthcheck]"
      exit 1 ;;
  esac
done
### tworze plik Dokerfile (wygodniej oczywiscie jesli jest normalnie utworzony)
touch Dockerfile
echo "### syntax=docker/dockerfile:1
### określam obraz używany w kontenerze
FROM golang:1.19
### tworze katalog roboczy w kontenerze
WORKDIR /usr/src/app
### kopiuje pliki go fo katalogu roboczego
COPY go.mod ./
### pobieram moduly Go i zaleznosci
RUN go mod download
### kopiuje do katalogu roboczego pliki z rozszerzeniem go
COPY *.go ./
RUN   sed -i 's|8080|$port|g' /usr/src/app/main.go
### kompiluje aplikacje
RUN  go build -o /app
### okreslam port, na ktorym kontener nasluchuje
EXPOSE $port
### ustawiam sygnal healthcheck badajacy dostepnosc aplikacji na zdefiniowanym wczesniej porcie
#HEALTHCHECK --interval=30s --timeout=3s   CMD curl -f http://localhost:$port || exit 1
### wysylam polecenie uruchomienia aplikacji app kiedy kontener jest gotow
CMD [ \"/app\" ]">Dockerfile

### jesli argument h byl przy uruchomieniuy sktyptu, odhaszowuje polecenie wysylajace healtczek
if [ $health_flag = true ];
  then
    sed -i '' 's|#HEALTHCHECK|HEALTHCHECK|g' Dockerfile
fi

# buduje obraz oraz uruchamiam kontener z wystawionym wczesniej zefiniowanym portem
docker build --tag app .
docker run  --rm -p $port:$port app
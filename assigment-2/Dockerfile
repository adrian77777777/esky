### syntax=docker/dockerfile:1
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
RUN   sed -i 's|8080|8080|g' /usr/src/app/main.go
### kompiluje aplikacje
RUN  go build -o /app
### okreslam port, na ktorym kontener nasluchuje
EXPOSE 8080
### ustawiam sygnal healthcheck badajacy dostepnosc aplikacji na zdefiniowanym wczesniej porcie
HEALTHCHECK --interval=30s --timeout=3s   CMD curl -f http://localhost:8080 || exit 1
### wysylam polecenie uruchomienia aplikacji app kiedy kontener jest gotow
CMD [ "/app" ]

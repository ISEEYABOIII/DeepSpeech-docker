
# DeepSpeech Docker Návod

Tento dokument poskytuje kroky pro vytvoření a používání Docker kontejneru pro DeepSpeech.

## Klonování Git Repozitáře

Nejdříve si stáhněte repozitář z Gitu:

```
git clone [link]
```

Nahraďte `[link]` skutečnou URL adresou vašeho Git repozitáře.

## Sestavení Docker Image

Poté sestavte Docker Image pomocí následujícího příkazu:

```
docker build -t deepspeech-image .
```

Tento příkaz vytvoří Docker Image s názvem `deepspeech-image` z Dockerfile ve vašem současném adresáři.

## Spuštění Docker Compose

Pro spuštění Docker kontejneru v režimu odpojeného terminálu použijte:

```
docker-compose up -d
```

Příkaz `-d` znamená, že kontejnery běží na pozadí.

## Připojení k Běžícímu Kontejneru

Pro zjištění ID vašeho běžícího kontejneru použijte:

```
docker ps
```

Následně se připojte k terminálu běžícího kontejneru:

```
docker exec -it <container_id> /bin/bash
```

Nahraďte `<container_id>` skutečným ID vašeho kontejneru.

## Vypnutí Kontejneru

A konečně, pro vypnutí kontejneru použijte:

```
docker-compose down
```

Tento příkaz zastaví a odstraní všechny kontejnery definované ve vašem `docker-compose.yml`.

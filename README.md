
# DeepSpeech Docker Návod

Tento dokument poskytuje kroky pro vytvoření a používání Docker kontejneru pro DeepSpeech.

## Obsah
1. [Klonování Git Repozitáře](#Klonování-Git-repozitáře)
2. [Sestavení Docker Image](#Sestavení-Docker-image)
3. [Spuštění Docker Compose](#Spuštění-Docker-compose)
4. [Připojení k Běžícímu Kontejneru](Připojení-k-běžícímu-kontejneru)
5. [Vypnutí Kontejneru](#Vypnutí-kontejneru)
6. [Trénování Vlastního Modelu](#Trénování-vlastního-modelu)
7. [Vygenerování Souboru Alphabet.txt](#Vygenerování-souboru-alphabet.txt)

## Klonování Git repozitáře
Nejdříve si stáhněte repozitář z Gitu:
```
git clone https://github.com/ISEEYABOIII/DeepSpeech-docker
```

## Sestavení Docker image
Poté sestavte Docker Image pomocí následujícího příkazu:
```
docker build -t deepspeech-image .
```
Tento příkaz vytvoří Docker Image s názvem `deepspeech-image` z Dockerfile ve vašem současném adresáři.

## Spuštění Docker compose
Pro spuštění Docker kontejneru použijte:
```
docker-compose up -d
```
Příkaz `-d` znamená, že kontejnery běží na pozadí.

## Připojení k běžícímu kontejneru
Pro zjištění ID nebo jména vašeho běžícího kontejneru použijte:
```
docker ps
```
Následně se připojte k terminálu běžícího kontejneru:
```
docker exec -it <container_id_nebo_name> /bin/bash
```
Nahraďte `<container_id_nebo_name>` skutečným ID nebo jménem vašeho kontejneru.

## Vypnutí kontejneru
A konečně, pro vypnutí kontejneru použijte:
```
docker-compose down
```
Tento příkaz zastaví a odstraní všechny kontejnery definované ve vašem `docker-compose.yml`.

## Trénování vlastního modelu
Stahovat datasety nahrávek je možné z [Common Voice](https://commonvoice.mozilla.org/cs/datasets).

### Kopírování nahrávek do kontejneru
Zkopírujte nahrávky pro trénink z vašeho PC do Docker kontejneru:
```
docker cp (home/user)~/[jmeno-souboru] [id-containeru]:/[cesta]
```
Nahraďte `[jmeno-souboru]`, `[id-containeru]`, `[cesta]` správným názvem souboru, ID kontejneru a cestou.

#### Příklad příkazu
```
docker cp ~/cv-corpus-13.0-2023-03-09-cs.tar.gz 70f7d0c11df5:/DeepSpeech/data/recordings
```

### Extrahování archivu
Extrahujte archiv:
```
tar -xzf data/recordings/[jmeno-souboru] -C [adresář-extraxce]
```
Nahraďte `[jmeno-souboru]` správným názvem souboru.

#### Příklad příkazu
```
tar -xzf data/recordings/cv-corpus-13.0-2023-03-09-cs.tar.gz -C data/recordings
```

### Script na převeedení datasetu na potřebný formát
Spusťte skript na převedení souborů z datasetu do požadovaného formátu:
```
python bin/import_cv2.py data/recordings/[cesta]/
```
Nahraďte `[cesta]` správnou cestou.

#### Příklad příkazu
```
python bin/import_cv2.py data/recordings/cv-corpus-13.0-2023-03-09/cs/
```

## Vygenerování souboru Alphabet.txt
Spusťte Python interpreter:
```
python3
```
Následně upravte tento skript pro své cesty a názvy souborů:
```python
import csv

# Cesty k CSV souborům
csv_files = [
    'data/recordings/cv-corpus-15.0-2023-09-08/cs/clips/train.csv', 
    'data/recordings/cv-corpus-15.0-2023-09-08/cs/clips/dev.csv',
    'data/recordings/cv-corpus-15.0-2023-09-08/cs/clips/test.csv'
]

def generate_alphabet(csv_files):
    # Čtení existujících znaků z alphabet.txt
    existing_chars = set()
    try:
        with open('data/alphabet.txt', 'r', encoding='utf-8') as file:
            for line in file:
                existing_chars.add(line.strip())
    except FileNotFoundError:
        # Pokud soubor neexistuje, začneme s prázdnou množinou
        pass

    # Hledání unikátních znaků v CSV souborech
    unique_chars = set()
    for csv_file in csv_files:
        with open(csv_file, newline='', encoding='utf-8') as file:
            reader = csv.reader(file)
            next(reader)  # Přeskočit header
            for row in reader:
                text = row[2]
                unique_chars.update(text)

    # Kombinace existujících a nových unikátních znaků
    updated_chars = existing_chars.union(unique_chars)

    # Zápis aktualizované sady znaků do alphabet.txt
    with open('data/alphabet.txt', 'w', encoding='utf-8') as file:
        for char in sorted(updated_chars):
            file.write(char + '\n')

if __name__ == '__main__':
    generate_alphabet(csv_files)
```

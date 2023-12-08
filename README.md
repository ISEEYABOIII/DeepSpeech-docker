# DeepSpeech Docker Návod

## Obsah
1. [Instalace a Konfigurace](#instalace-a-konfigurace)
   - [Klonování Git Repozitáře](#klonování-git-repozitáře)
   - [Sestavení Docker Image](#sestavení-docker-image)
2. [Práce s Kontejnerem](#práce-s-kontejnerem)
   - [Spuštění Docker Compose](#spuštění-docker-compose)
   - [Připojení k Běžícímu Kontejneru](#připojení-k-běžícímu-kontejneru)
   - [Vypnutí Kontejneru](#vypnutí-kontejneru)
3. [Příprava pro Trénování](#příprava-pro-trénování)
   - [Kopírování Nahrávek](#kopírování-nahrávek)
   - [Extrahování Archivu](#extrahování-archivu)
   - [Převod Datasetu na Požadovaný Formát](#převod-datasetu-na-požadovaný-formát)
   - [Vygenerování Souboru Alphabet.txt](#vygenerování-souboru-alphabettxt)
4. [Spuštění Trénování Modelu](#spuštění-trénování-modelu)

## Instalace a Konfigurace

### Klonování Git repozitáře
Nejdříve si stáhněte repozitář z Gitu:
```
git clone https://github.com/ISEEYABOIII/DeepSpeech-docker
```

### Sestavení Docker image
Poté sestavte Docker Image pomocí následujícího příkazu:
```
docker build -t deepspeech-image .
```
Tento příkaz vytvoří Docker Image s názvem `deepspeech-image` z Dockerfile ve vašem současném adresáři.

## Práce s Kontejnerem

### Spuštění Docker compose
Pro spuštění Docker kontejneru použijte:
```
docker-compose up -d
```
Příkaz `-d` znamená, že kontejnery běží na pozadí.

### Připojení k běžícímu kontejneru
Pro zjištění ID nebo jména vašeho běžícího kontejneru použijte:
```
docker ps
```
Následně se připojte k terminálu běžícího kontejneru:
```
docker exec -it <container_id_nebo_name> /bin/bash
```
Nahraďte `<container_id_nebo_name>` skutečným ID nebo jménem vašeho kontejneru.

### Vypnutí kontejneru
Pro vypnutí kontejneru použijte:
```
docker-compose down
```
Tento příkaz zastaví a odstraní všechny kontejnery definované ve vašem `docker-compose.yml`.

## Příprava pro Trénování

### Kopírování nahrávek do kontejneru
Zkopírujte nahrávky pro trénink z vašeho PC do Docker kontejneru:
```
docker cp ~/[jmeno-souboru] [id-containeru]:/[cesta]
```
Nahraďte `[jmeno-souboru]`, `[id-containeru]`, `[cesta]` správným názvem souboru, ID kontejneru a cestou.

#### Příklad příkazu
```
docker cp ~/cv-corpus-13.0-2023-03-09-cs.tar.gz 70f7d0c11df5:/DeepSpeech/data/recordings
```

### Extrahování archivu
Extrahujte archiv
```
tar -xzf data/recordings/[jmeno-souboru] -C [adresář-extraxce]
```
Nahraďte `[jmeno-souboru]` správným názvem souboru a `[adresář-extraxce]` adresářem, kam chcete soubory extrahovat.

#### Příklad příkazu
```
tar -xzf data/recordings/cv-corpus-13.0-2023-03-09-cs.tar.gz -C data/recordings
```

### Script na převedení datasetu na potřebný formát
Spusťte skript na převedení souborů z datasetu do požadovaného formátu:
```
python bin/import_cv2.py data/recordings/[cesta]/
```
Nahraďte `[cesta]` správnou cestou k vašim datům.

#### Příklad příkazu
```
python bin/import_cv2.py data/recordings/cv-corpus-13.0-2023-03-09/cs/
```

### Vygenerování souboru Alphabet.txt

Vytvořte si python script pomocí nano:
```
nano script.py
```


Vložte do editoru následující kód:
```python
import csv
import string

# Cesty k CSV souborům
csv_files = [
        '[cesta]/train.csv',
        '[cesta]/dev.csv',
        '[cesta]/test.csv'
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
Nahraďte `[cesta]` správnou cestou k vašim datům.

#### Příklad příkazu
```python
import csv
import string

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

Ukončete upravování pomocí `ctrl + X` následného stistnutí klávesy `Y` pro uložení a potvrzení klávesou `enter`

Spusťte script.py pro vygenerování souboru `alphabet.txt` pomocí  :
```
python script.py
```


## Spuštění Trénování Modelu
Pro spuštění trénování modelu DeepSpeech použijte následující příkaz:
```
python DeepSpeech.py \
--train_files [cesta]/train.csv \
--dev_files [cesta]/dev.csv \
--test_files [cesta]/test.csv \
--epochs 30 \
--learning_rate 0.0001 \
--dropout_rate 0.30 \
--train_batch_size 32 \
--dev_batch_size 32 \
--test_batch_size 32 \
--augment reverb[p=0.2,delay=50.0~30.0,decay=10.0:2.0~1.0] \
--n_hidden 1024 \
--es_epochs 5 \
--alphabet_config_path data/alphabet.txt \
--checkpoint_dir Checkpoints/
```

### Příklad příkazu
```
python DeepSpeech.py \
--train_files data/recordings/cv-corpus-15.0-2023-09-08/cs/clips/train.csv \
--dev_files data/recordings/cv-corpus-15.0-2023-09-08/cs/clips/dev.csv \
--test_files data/recordings/cv-corpus-15.0-2023-09-08/cs/clips/test.csv \
--epochs 30 \
--learning_rate 0.0001 \
--dropout_rate 0.30 \
--train_batch_size 32 \
--dev_batch_size 32 \
--test_batch_size 32 \
--augment reverb[p=0.2,delay=50.0~30.0,decay=10.0:2.0~1.0] \
--n_hidden 1024 \
--es_epochs 5 \
--alphabet_config_path data/alphabet.txt \
--checkpoint_dir Checkpoints/
```

### Přehled Parametrů Trénování DeepSpeech

#### Základní Nastavení
- **`--train_files`**: Cesta k trénovacím datům. (např. `data/train.csv`)
- **`--dev_files`**: Cesta k validačním datům. (např. `data/dev.csv`)
- **`--test_files`**: Cesta k testovacím datům. (např. `data/test.csv`)

#### Konfigurace Učení
- **`--epochs`**: Počet epoch. (např. `10`)
- **`--learning_rate`**: Rychlost učení modelu. (např. `0.0001`)
- **`--dropout_rate`**: Pravděpodobnost vypnutí neuronu. (např. `0.3`)

#### Velikosti Batchů
- **`--train_batch_size`**: Velikost dávky pro trénování. (např. `32`)
- **`--dev_batch_size`**: Velikost dávky pro validaci. (např. `32`)
- **`--test_batch_size`**: Velikost dávky pro testování. (např. `32`)

#### Augmentace Dat
- **`--augment`**: Definice augmentací. (např. `reverb[p=0.2,delay=50.0~30.0,decay=10.0:2.0~1.0]`)

#### Architektura Modelu
- **`--n_hidden`**: Počet neuronů v skrytých vrstvách. (např. `1024`)

#### Early Stopping
- **`--es_epochs`**: Počet epoch bez zlepšení pro předčasné ukončení. (např. `5`)
- **`--early_stop`**: Aktivace funkce předčasného ukončení trénování. (např. `True` nebo `False`)

#### Konfigurace Jazyka
- **`--alphabet_config_path`**: Cesta k definici používaných znaků. (např. `data/alphabet.txt`)

#### Ukládání a Obnova
- **`--checkpoint_dir`**: Adresář pro ukládání checkpointů. (např. `checkpoints/`)

#### Pokročilá Konfigurace
- **`--export_dir`**: Cesta pro export natrénovaného modelu. (např. `exported_model/`)
- **`--scorer`**: Cesta k externímu scoreru. (např. `data/kenlm.scorer`)
- **`--beam_width`**: Šířka prohledávání v dekódování. (např. `1024`)

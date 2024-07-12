# m122_projectInitializer
Abschlussprojekt für das Modul 122

## Inhaltsverzeichnis
- [Projektidee](#projektidee)
- [Use Cases](#use-cases)
- [Anforderungen](#anforderungen)
- [Projekt ausführen](#projekt-ausführen)
- [Projekt testen](#projekt-testen)
- [Disclaimer](#disclaimer)

## Projektidee
Ich will ein Projekt erstellen, welches automatisch gewisse Projekte für mich initialisiert, welche ich häufig in meinem Berufsalltag brauche (z.B. Python Flask REST API).

### Use Cases
- Ich als Nutzer kann, wenn ich das Skript ausführe, als erstes Argument, den Projektnamen angeben.
- Ich als Nutzer kann, wenn ich das Skript ausführe, als zweites Argument, den Projekttyp angeben.
- Ich als Nutzer kann, wenn ich das Skript ausführe, als drittes Argument, den Pfad angeben, bei dem das Projekt erstellt werden soll.
- Das Skript wird abgebrochen, wenn ich ein Argument mitgeben, welches ungültig ist.
- Ich als Nutzer werde gefragt, wenn ich das Skript gestartet habe, ob ich ein Git-Repo hinzufügen will.
- Ich als Nutzer werde gefragt, ob ich die Umgebung für mein Projekt einrichten will (z.B. venv, dependencies, ...).
- Ich als Nutzer werde informiert, wenn das Skript korrekt ausgeführt wurde.
- Ich als Nutzer werde informiert, wenn es einen Fehler bei der Ausführung des Skriptes gab.
- Ich als Nutzer kann, wenn ich das Skript mit der -h bzw. --help Flag ausführe, eine Dokumentation zum Befehl sehen

### Anforderungen
- Alle Use Cases werden vom Skript erfüllt.
- Es gibt Tests, mit welchen man das Skript testen kann.

## Projekt ausführen
1. Falls nicht vorhanden: `sudo apt install python3`
2. Falls nicht vorhanden: `sudo apt install maven`
3. Falls nicht vorhanden: `sudo apt install default-jdk`
4. `chmod +x projectInitializer.sh`
5. `./projectInitializer <args>`

Die Basisfunktionen des Skriptes werden in folgendem Video aufgezeigt: https://drive.google.com/file/d/1SwEPxquVifyOROZw3Tb8HHMx_QdWKDU0/view?usp=drive_link

### Projekt testen
1. Falls nicht vorhanden: `sudo apt install bats`
2. Falls nicht vorhanden: `sudo apt install shellcheck`
3. `bats projectInitializer.bats`

### Disclaimer
Die Applikation wurde auf dem OS `Ubuntu 22.04.4 LTS` entwickelt. Obwohl ein Fokus darauf gelegt wurde, das Skript auf diversen OS ausführen zu können, kann dies nicht garantiert werden.

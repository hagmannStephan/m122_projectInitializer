# m122_projectInitializer
Abschlussprojekt für das Modul 122

## Projektidee
Ich will ein Projekt erstellen, welches automatisch gewisse Projekte für mich initialisiert, welche ich häufig in meinem Berufsalltag brauche (z.B. Python Flask REST API).

### Use Cases
- Ich als Nutzer kann, wenn ich das Skript ausführe, als erstes Argument, den Projektnamen angeben.
- Ich als Nutzer kann, wenn ich das Skript ausführe, als zweites Argument, den Projekttyp angeben.
- Ich als Nutzer kann, wenn ich das Skript ausführe, als drittes Argument, den Pfad angeben, bei dem das Projekt erstellt werden soll.
- Das Skript wird abgebrochen, wenn ich ein Argument mitgeben, welches ungültig ist.
- Ich als Nutzer werde gefragt, wenn ich das Skript gestartet habe, ob ich ein Git-Repo hinzufügen will.
- Ich als Nutzer werde gefragt, wenn ich das Skript gestartet habe, ob ich ein .env File mit Variablen erstellen will.
- Ich als Nutzer werde informiert, wenn das Skript korrekt ausgeführt wurde.
- Ich als Nutzer werde informiert, wenn es einen Fehler bei der Ausführung des Skriptes gab.

### Anforderungen
- Alle Use Cases werden vom Skript erfüllt.
- Es gibt Tests, mit welchen man das Skript testen kann.

## Projekt ausführen
1. `chmod +x projectInitializer.sh`
2. `./projectInitializer <args>`

### Projekt testen
1. `sudo apt update; sudo apt install bats` (Wenn noch nicht vorhanden)
2. `sudo apt update; sudo apt install shellcheck` (Wenn noch nicht vorhanden)
3. `bats projectInitializer.bats`
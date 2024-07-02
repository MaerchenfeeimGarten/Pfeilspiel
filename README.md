<!---

 SPDX-FileCopyrightText: 2023-2024 MaerchenfeeimGarten
 
 SPDX-License-Identifier:  AGPL-3.0-only

--->

# Pfeilspiel

Pfeilspiel ist ein Spiel, dass ich in der ersten TOS-Version während meiner Schulzeit weit vor meinem Informatikstudium programmiert habe. 
Das erklärt auch den Programmierstil und die Programmiersprachenauswahl.

Dieses Gitrepo soll das Spiel in seinem originalen Zustand von damals (TOS="The Original Spiel" oder auch TOS="Tas Originale Spiel" erhalten und wieder zum Laufen bringen.

Außerdem sind neue Varianten entstanden (z. B. Pfeilspiel TNG), die ein paar der Fehler von damals beheben und einige Neuerungen einführen.


## Spielprinzip

Ein Pfeil zeigt irgendwo hin und man muss herausfinden, wohin genau.

## Varianten

### **Pfeilspiel TNG** (The Next Game):
Übersetzt, verbesserte Grafik, andere Spielprinzipien, mehr Farben, mehr Abwechslung und besserer Programmierstil. Die empfohlene Variante.

[<u>**--> Aktuellste Version online spielen <--**</u>](https://maerchenfeeimgarten.codeberg.page/pfeilspiel/)

[<u>**--> Download-Bereich <--**</u>](https://codeberg.org/MaerchenfeeimGarten/Pfeilspiel/releases)

Bildschirmfotos:
![4 Bildschirmfotos von Pfeilspiel TNG: 1. Sprachauswahl, 2. Spielauswahl, 3. Richtung des Pfeiles wird animiert, 4. Auflösung, ob das ausgewählte Rechteck das richtige ist.](https://codeberg.org/MaerchenfeeimGarten/Pfeilspiel/raw/branch/main/doc/Pfeilspiel%20TNG%20international/screenshots/001-004.webp "Pfeilspiel TNG international v0.0.5")

### Pfeilspiel TOS: (Tas Originale Spiel) 

Nur auf Deutsch, da der Quellcode seit der Schulzeit nicht mehr verändert worden ist und wird - zumindest unter diesem Namen... (!).

### Pfeilspiel TOS international: (The Original Spiel):

Auf Deutsch, auf Englisch, in vielleicht noch ein paar mehr Sprachen. Der schlechte Programmierstiel bleibt aus Authentizitätsgründen bestehen. Es ist wirklich nur eine Übersetzung der TOS-Variante - mehr nicht.

## Bauen/Compilieren

Zum Bauen von Pfeilspien TNG international gibt es einen [_Docker-Container in einem weiteren Git-Repo_](https://codeberg.org/MaerchenfeeimGarten/pfeilspiel-fbc).
Dieser compiliert automatisch für alle hier erwähnten Platformen und speichert die Ergebnisse im Unterordner `bin`.

## Installieren

Dieses Programm muss nicht installiert werden - es reicht, die entsprechende Programmdatei direkt zu starten.

### Windows

Unter Windows einfach die Programmdatei anklicken.

### Linux

Um das Programm unter Linux zu starten, muss die Programmdatei erst einmal ausführbar gemacht werden.
Dazu einem Dateimanager (z. B. Dolphin) mit der rechten Maustaste auf die Datei klicken und im daraufhin auftauchenden Kontextmenü den Punkt "Eigenschaften" auswählen. Bei den meisten Linux-Distributionen befindet sich im dann auftauchenden Fenster direkt oder in einem der dort erscheinenden Tabs die Möglichkeit, das Programm als "Ausführbar" zu kennzeichnen.

Wer fit auf der Komandozeile ist, kann stattdessen folgenden Befehl verwenden:

```
chmod +x <Programmdatei>
```

### DOS

Pfeilspiel benötigt - wie alle in FreeBasic geschriebene Software - einen sogenannten DOS-Extender.
Dazu kann der in FreeDOS direkt mitgelieferte Open-Source-DOS-Extender `cwsdpmi` verwendet werden.
Er kann unter einen der folgenden Links heruntergeladen werden:

 - [Originalwebseite](https://sandmann.dotster.com/cwsdpmi/)
 - [Info über das Mitliefern in FreeDOS](https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/1.3/pkg-html/cwsdpmi.html)
 - [Download aus dem pfeilspiel-fbc-Repo](https://codeberg.org/MaerchenfeeimGarten/pfeilspiel-fbc/src/commit/0172accadbe5bb3f2f6ddf86e9a9b8009d17f742/cwsdpmi.zip)

Nachdem diese Software in Ihre DOS-Installation integriert wurde, kann diese mit folgendem Befehl geladen werden:

`cwsdpmi -p `

Danach lässt sich das Spiel mit der Eingabe des Namens der Programmdatei öffnen - vorausgesetzt, sie befinden sich in dem Ordner, in dem diese abgelegt worden ist (hier am Beispiel der Version 0.0.8):

`PFEIL008`

## Lizenz

Die Lizenz-Informationen werden in diesem Repo anhand der [REUSE-Spezifikation 3.0](https://reuse.software/) bei Text-Dateien in an derem Anfang und bei anderen Dateien in `dateiname.dateiendung.license` angegeben. Der Lizenz-Text selber befindet sich im Unterordner `LICENSES`.

Das Programm bzw. die Programme _Pfeilspiel TOS_, _Pfeilspiel TOS international_ sowie _Pfeilspiel TNG (international)_ in diesem Repo stehen unter der [agpl-3.0-only-Lizenz](https://www.gnu.org/licenses/agpl-3.0.txt).

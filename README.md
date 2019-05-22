# pr0gramm-miner-native

## Projekt Archiviert 2019-05-22
Die Möglichkeit, zu minen, ist nun schon seit einiger Zeit abgeschaltet. Dieses Projekt ist damit hinfällig.

## Setup
Benötigt Docker.

```Shell
git clone https://github.com/holzmaster/pr0gramm-miner-native
cd pr0gramm-miner-native
[sudo] docker build .
# ...
# Successfully built <image>
```

## Benutzung
Der Container kann über Umgebungsvariablen konfiguriert werden.
- `PR0GRAMM_USER` (optional): Der Benutzername. `Default:` `holzmaster` (Spende)
- `NUM_THREADS` (optional): Anzahl an zu verwendendne Threads. `Default:` Anzahl an Kernen / 2; von Fusl (siehe `run.sh`).
- `XMRIG_OPTS` (optional): Weitere Optionen für XMRIG. `Default:` leer

```Shell
[sudo] docker run -e PR0GRAMM_USER=username <image>
```

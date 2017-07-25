# pr0gramm-miner-native

## Setup
Benötigt Docker.

```Shell
git clone https://github.com/holzmaster/pr0gramm-miner-native
cd pr0gramm-miner-native
[sudo] docker build .
```

## Benutzung
Der Container kann über Umgebungsvariablen konfiguriert werden.
- `PR0GRAMM_USER`: Der Benutzername
- `NUM_THREADS` (optional): Anzahl an zu verwendendne Threads. `Default:` Anzahl an Prozessoren / 2; von Fusl (sieh `run.sh`).
Setzen von Umgebungsvariablen mit `-e VARIABLE=wert`
```Shell
[sudo] docker run <image>
```

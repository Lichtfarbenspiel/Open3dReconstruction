# 3D Rekonstruktion mit einer RGBD-Sequenz
<details>
  <summary>Inhalt</summary>
  <ol>
    <li><a href="#anleitung-zur-nutzung-des-programms">Anleitung zur Nutzung des Programms</a></li>
    <li><a href="#schritt-1---make">Schritt 1 --make</a></li>
    <li><a href="#schritt-2---register">Schritt 2 --register</a></li>
    <li><a href="#schritt-3---refine">Schritt 3 --refine</a></li>
    <li><a href="#schritt-4---integrate">Schritt 4 --integrate</a></li>
    <li><a href="#begriffserklärungen">Begriffserklärungen</a></li>
    <li><a href="#referenzen">Referenzen</a></li>
    <li><a href="#verwendete-module">Verwendete Module</a></li>
  </ol>
</details>


# Anleitung zur Nutzung des Programms
Mit folgendem Konsolenbefehl müssen die einzelnen Frames einer Videoaufnahme (.mkv) extrahiert werden:

```python azure_kinect_mkv_reader.py --input record.mkv --output frames```

Hierbei wird ein Verzeichnis "frames" mit den Unterverzeichnissen "color" und "depth" erstellt. In welchen die Farbwerte und Tiefenkarten der einzelnen Frames gespeichert werden.

Anschließend müssen die folgenden vier Befehle nacheinander in der Konsole ausgeführt werden:


```python run_system.py "config.json" --make```

```python run_system.py "config.json" --register```

```python run_system.py "config.json" --refine```

```python run_system.py "config.json" --integrate```

## Schritt 1 --make
Fragmente erstellen. Lokale geometrische Oberflächen (Meshes) werden gebaut aus kurzen Untersequenzen der Eingangssequenz. Dazu wird RGBD-Odometrie, Mehrwegregistrierung und RGBD-Integration verwendet.

Für die RGBD-Odometrie wird bei Bildern, die nicht direkt aufeinander folgen, eine Pose Estimation berechnet als initiale Transformationsmatrix. Bei der Pose Estimation werden Feature Points gefunden und mit RANSAC wird eine grobe Ausrichtung für die Punkte zueinander berechnet.

Für die Mehrwegregistrierung wird ein Pose Graph aufgebaut. Dabei wird für jedes Bild ein Knoten eingefügt mit der Transformation, die die Kameraausrichtung zurück zur Ursprungsausrichtung bringt. Zusätzlich wird jeder Knoten mit jedem anderen Knoten über eine Kante verbunden mit der Transformation, die die Kameraausrichtung von einem Bild zum nächsten bringt und einem Wahrheitswert, der Aussagt, ob es einen großen Fehler geben kann oder nicht. Der Wahrheitswert wird auf Wahr gesetzt, wenn die Kante einen Knoten mit dem Folgeknoten verbindet (nach Bildfolge in der Sequenz). Schließlich wird der Pose Graph durch Mehrwegregistrierung optimiert. Hier wird in Open3D Global Optimization angewandt.

Für die RGBD-Integration werden alle Knoten des Pose Graphs durchlaufen und deren Posentransformation ausgelesen, um die Bilder relativ zum Startbild richtig auszurichten und schließlich in eine 3D-Objekt zu integrieren.

## Schritt 2 --register
Fragmente registrieren. Die Fragmente werden ausgerichtet, um Loop Closure zu erkennen (Bewegungsschleifen der Kamera, bei denen der Ausgangspunkt gleich dem Eingangspunkt ist). Dazu wird globale Registrierung, ICP-Registrierung und Mehrwegregistrierung verwendet.

## Schritt 3 --refine
Registrierung verfeinern. Dazu wird ICP-Registrierung und Mehrwegregistrierung verwendet.

## Schritt 4 --integrate
Szene integrieren. Integrieren der RGBD-Bilder, um ein Mesh für die Szene zu erstellen. Dazu wird RGBD-Integration verwendet.

## Begriffserklärungen
### RGBD-Odometrie:
Finden der Kamerabewegung zwischen zwei aufeinanderfolgenden Bildern.

### Mehrwegregistrierung:
Ausrichten mehrerer Geometrieteile in einem globalen Raum. Open3D nutzt dazu Pose Graph Optimazation.

### RGBD-Integration:
Berechnen eines 3D-Objekts aus RGBD-Bildern.

### Globale Registrierung:
Ausrichtungsalgorithmen, die keine initiale Ausrichtung benötigen und eine grobe Ausrichtung berechnen.

### Iterative Closest Point (ICP)-Registrierung:
Iterativ werden Transformationen berechnet, die die nächsten Punkte immer näher zueinander bringen. Hier spricht man von lokaler Registrierung.

# Referenzen
[Open3d Reconstruction system](http://www.open3d.org/docs/latest/tutorial/ReconstructionSystem/index.html)

# Verwendete Module
|Modul          |Version    |
|---------------|-----------|
|Python         |3.9        |
|opencv-python  |4.5.5.64   |
|Open3D         |0.15       |
|matplotlib     |           |
|joblib         |           |

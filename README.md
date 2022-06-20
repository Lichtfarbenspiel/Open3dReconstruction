# 3D Rekonstruktion mit einer RGBD-Sequenz
<details>
  <summary>Inhalt</summary>
  <ol>
    <li><a href="#schritt-1">Schritt 1</a></li>
    <li><a href="#schritt-2">Schritt 2</a></li>
    <li><a href="#schritt-3">Schritt 3</a></li>
    <li><a href="#schritt-4">Schritt 4</a></li>
    <li><a href="#begriffserklärungen">Begriffserklärungen</a></li>
    <li><a href="#referenzen">Referenzen</a></li>
    <li><a href="#verwendete-module">Verwendete Module</a></li>
  </ol>
</details>

## Schritt 1
Fragmente erstellen. Lokale geometrische Oberflächen (Meshes) werden gebaut aus kurzen Untersequenzen der Eingangssequenz. Dazu wird RGBD-Odometrie, Mehrwegregistrierung und RGBD-Integration verwendet.

Für die RGBD-Odometrie wird bei Bildern, die nicht direkt aufeinander folgen, eine Pose Estimation berechnet als initiale Transformationsmatrix. Bei der Pose Estimation werden Feature Points gefunden und mit RANSAC wird eine grobe Ausrichtung für die Punkte zueinander berechnet.

Für die Mehrwegregistrierung wird ein Pose Graph aufgebaut. Dabei wird für jedes Bild ein Knoten eingefügt mit der Transformation, die die Kameraausrichtung zurück zur Ursprungsausrichtung bringt. Zusätzlich wird jeder Knoten mit jedem anderen Knoten über eine Kante verbunden mit der Transformation, die die Kameraausrichtung von einem Bild zum nächsten bringt und einem Wahrheitswert, der Aussagt, ob es einen großen Fehler geben kann oder nicht. Der Wahrheitswert wird auf Wahr gesetzt, wenn die Kante einen Knoten mit dem Folgeknoten verbindet (nach Bildfolge in der Sequenz). Schließlich wird

## Schritt 2
Fragmente registrieren. Die Fragmente werden ausgerichtet, um Loop Closure zu erkennen (Bewegungsschleifen der Kamera, bei denen der Ausgangspunkt gleich dem Eingangspunkt ist). Dazu wird globale Registrierung, ICP-Registrierung und Mehrwegregistrierung verwendet.

## Schritt 3
Registrierung verfeinern. Dazu wird ICP-Registrierung und Mehrwegregistrierung verwendet.

## Schritt 4
Szene integrieren. Integrieren der RGBD-Bilder, um ein Mesh für die Szene zu erstellen. Dazu wird RGBD-Integration verwendet.

## Begriffserklärungen
### RGBD-Odometrie:
Finden der Kamerabewegung zwischen zwei aufeinanderfolgenden Bildern.

### Mehrwegregistrierung:
Ausrichten mehrerer Geometrieteile in einem globalen Raum. Open3D nutzt dazu Pose Graph Optimazation.

### RGBD-Integration:
Berechnen eines Meshes aus RGBD-Bildern.

### Globale Registrierung:
Ausrichtungsalgorithmen, die keine initiale Ausrichtung benötigen und eine grobe Ausrichtung berechnen.

### ICP-Registrierung:
Iterative Closest Point. Iterativ werden Transformationen berechnet, die die nächsten Punkte immer näher zueinander bringen. (Lokal)

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

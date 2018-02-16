
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Januar 2018 (Swift ARKit bei Manu)
 *  Kapitel 4 – Unsere Erde
 *  - Button: Animierte Erde rotiert um sich selbst
 *  - Mond hat seine eigene Umlaufbahn um die Erde
 *  - Button: Erde kann wachsen und schrumpen (Animation)
 *
 *  AUFGABE: Erde betrachten, Länder und Kontinente abfragen
 *  (Vision für Zukunft: Vielleicht das ganze Sonnensystem oder
 *   kurze gesprochene „Erklär-Texte" zu verschiedenen Ländern/Kontinenten)
 */
// ************************************ //

import SceneKit // importieren für SCNNodes

 let earthSize = CGFloat(0.3)

// Funktion: Planet (return -> SCNNode)
func planet(planetForm: SCNGeometry, planetTexture: UIImage, planetLightReflection: UIImage?, planetClouds: UIImage?, planetMountains: UIImage?, planetPosition: SCNVector3)-> SCNNode {
    /** Erklärung:
     planetClounds: UIImage?
     --> „?" bedeutet, dass ein Planet z.B. der Mond es nicht haben muss (nil)
   
     planet.geometry?.firstMaterial?....
     ....diffuse.contents = planetTexture
     --> Textur vom Planet
     ....specular.contents = planetLightReflection
     --> Lichtreflektion im Meer
     ....emission.contents = planetClouds
     --> Zusätzliche Textur (Wolken über der Erde-Textur)
     ....normal.contents = planetMountains
     --> Berge und Täler (3d Map)
     */
    let planet = SCNNode(geometry: planetForm)
    planet.name = "Planet" // alle gleich benennen (zsm löschen)
    planet.geometry?.firstMaterial?.diffuse.contents = planetTexture
    planet.geometry?.firstMaterial?.specular.contents = planetLightReflection
    planet.geometry?.firstMaterial?.emission.contents = planetClouds
    planet.geometry?.firstMaterial?.normal.contents = planetMountains
    planet.position = planetPosition
   
    return planet
 }


/* Funktion: rotierende Planeten (Animation)
--> SCNAction ist für Animationen
--> für Animation/Rotation der Planeten (return SCNAction)
--> Erde soll nur um die y-Achse (um sich selbst) rotieren innerhalb von X Sekunden
--> Geschwindigkeit der Rotation beeinflussen? „durationPlanetRotation"
--> Die Erde braucht X Sekunden, um 360 Grad einmal um sich selbst zu rotieren
--> endlessPlanetRotation, damit sie dauerhaft rotiert und nicht nur einmal
*/
 func planetRotation(durationPlanetRotation: TimeInterval) -> SCNAction {
    
    let planetRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: durationPlanetRotation)
    let endlessPlanetRotation = SCNAction.repeatForever(planetRotation)
    
    return endlessPlanetRotation
 }


/* Funktion: Animation – Erde wird groß
 --> Planet vergrößern mit SCNAction.scale
 --> Wie groß soll er werden? „planetEndSize"
 --> Zeit, bis er die volle Größe „planetEndSize" erreicht hat: duration (in Sek)
 */
func planetGrowing(planetEndSize: CGFloat) -> SCNAction {
    
    let planetGrowing = SCNAction.scale(by: planetEndSize, duration: 1)
   
    return planetGrowing
}


// Die Rotation von den Planeten in Radius angeben:
extension Int {
    
    var degreesToRadians: Double {
        
        return Double(self) * .pi/100
    }
}


extension ViewController {
    
    /* planetButton
     --> Kapitel 4 „Unsere Erde"
     --> Aktuelle Position ermitteln (currentPlanetPosition) + Abstand
     --> Dort erscheint die Erde
     --> 3d Planet – auf func planets() zugreifen 
     
     Nur ein Planet soll in die Scene hinzugefügt werden
     und nicht 28367 Planeten, wenn man 28367 Mal den Button drückt:
     --> enumerateChileNodes({...)
     = loop durch jeden Node, der ein ChildNode der Scene ist
     --> if node.name == "Planet"
     = wenn der Node „Planet" heißt, ...
     --> node.removeFromParentNode()
     = ... wird er vom parentNode entfernt
     also nur der neueste Planet wird hinzugefügt und der „alte" wird gelöscht
     
     planet.geometry?.firstMaterial?
     = dem Planeten eine Textur verleihen:
     im Assets.xcassets eine neue Textur anlegen: „new image set" > Texture_PlanetEarth
     --> diffuse.contents
     = Planet eine (diffuse) Textur verleihen
     --> specular.contents
     = Lichtreflektion (z.B. nur das Wasser reflektiert das Licht zurück)
     --> emission.contents
     = Zusätzlich zur diffuse Textur hinzufügen (z.B. Wolken)
     --> normal.contents
     = Optischer 3d Content wird hinzugefügt (z.B. Berge und Täler)
     */
    func addPlanetEarth() {
        
        guard let pointOfView = sceneView.pointOfView else
        {return}
        let Transform = pointOfView.transform
        let Orientation = SCNVector3(-Transform.m31,-Transform.m32,-Transform.m33)
        let Location = SCNVector3(Transform.m41,Transform.m42,Transform.m43)
        let currentPlanetPosition = Orientation + Location
        
        // Planet Erde erstellen:
        let earthPosition = currentPlanetPosition + SCNVector3(0,0,-1)
        let earthSize = CGFloat(0.3)
        let planetEarth = planet(planetForm: SCNSphere(radius: earthSize), planetTexture: #imageLiteral(resourceName: "Texture_PlanetEarth"), planetLightReflection: #imageLiteral(resourceName: "Texture_PlanetEarth-specular"), planetClouds: #imageLiteral(resourceName: "Texture_PlanetEarth-clouds"), planetMountains: #imageLiteral(resourceName: "Texture_PlanetEarth-mountains"), planetPosition: earthPosition)
        // Kostenlose, freie Texturen von Planeten:
        // https://www.solarsystemscope.com/textures
        
        
        // Planet Mond erstellen:
        let moonSize = CGFloat(0.07)
        let lunarDistance = SCNVector3(0.4,0,0) //Abstand: Erde-Mond
        // Lunar distance = also called Earth–Moon distance (wikipedia)
        let moon = planet(planetForm: SCNSphere(radius: moonSize), planetTexture: #imageLiteral(resourceName: "Texture_PlanetMoon"), planetLightReflection: nil, planetClouds: nil, planetMountains: nil, planetPosition: lunarDistance)
        // Kostenlose, freie Texturen von Planeten:
        // https://www.solarsystemscope.com/textures
    
        
        // Umlaufbahn vom Mond um die Erde (orbit)
        // Orbit = „unsichtbarer Node", der die Umlaufbahn widerspiegelt
        let orbitMoon = SCNNode()
        orbitMoon.position = planetEarth.position
        // --> Illussion, dass der Mond an der Erde hängt
        // --> planetEarthPosition (damit es um die Erde rotiert)
        orbitMoon.addChildNode(moon)
        // --> moon = Child von der Mond-Umlaufbahn
       
        
        // Animation hinzufügen --> Funktion: planetRotation()
        let earthRotation = planetRotation(durationPlanetRotation: 20)
        let moonRotation = planetRotation(durationPlanetRotation: 10)
        let orbitMoonRotation = planetRotation(durationPlanetRotation: 5)
        
        // Animation starten mit .runAction
        planetEarth.runAction(earthRotation)    //Erde rotiert um sich selbst
        moon.runAction(moonRotation)            //Mond rotiert um sich selbst
        orbitMoon.runAction(orbitMoonRotation)  //Mond läuft um Erde herum
        
        
        // Nodes Löschen, wenn man nochmal auf Button klickt (nur 1 Planet in Scene)
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if node.name == "Planet" {
                node.removeFromParentNode()
            }
        })
        // Danach in die Scene hinzufügen (sichbar machen):
        self.sceneView.scene.rootNode.addChildNode(planetEarth)
        self.sceneView.scene.rootNode.addChildNode(orbitMoon)
    }
    
    
    // Funktion: Planet Erde wächst (Animation)
    func growingPlanetEarth() {
        
        guard let pointOfView = sceneView.pointOfView else
        {return}
        let Transform = pointOfView.transform
        let Orientation = SCNVector3(-Transform.m31,-Transform.m32,-Transform.m33)
        let Location = SCNVector3(Transform.m41,Transform.m42,Transform.m43)
        let currentPlanetPosition = Orientation + Location
        
        let earthPosition = currentPlanetPosition + SCNVector3(0,0,-1)
        let earthSize = CGFloat(0.3)
        
        let planetEarth = planet(planetForm: SCNSphere(radius: earthSize), planetTexture: #imageLiteral(resourceName: "Texture_PlanetEarth"), planetLightReflection: #imageLiteral(resourceName: "Texture_PlanetEarth-specular"), planetClouds: #imageLiteral(resourceName: "Texture_PlanetEarth-clouds"), planetMountains: #imageLiteral(resourceName: "Texture_PlanetEarth-mountains"), planetPosition: earthPosition)
 
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if node.name == "Planet" {
                node.removeFromParentNode()
            }
        })
        
        let earthGrowing = planetGrowing(planetEndSize: earthSize + 2)
        planetEarth.runAction(earthGrowing)
        
        self.sceneView.scene.rootNode.addChildNode(planetEarth)
    }
    
    
    // Funktion: Planet Erde schrumpft (Animation)
    func shrinkingPlanetEarth() {
        
        guard let pointOfView = sceneView.pointOfView else
        {return}
        let Transform = pointOfView.transform
        let Orientation = SCNVector3(-Transform.m31,-Transform.m32,-Transform.m33)
        let Location = SCNVector3(Transform.m41,Transform.m42,Transform.m43)
        let currentPlanetPosition = Orientation + Location
        
        let earthPosition = currentPlanetPosition + SCNVector3(0,0,-1)
        let earthSize = CGFloat(0.6)
        
        let planetEarth = planet(planetForm: SCNSphere(radius: earthSize), planetTexture: #imageLiteral(resourceName: "Texture_PlanetEarth"), planetLightReflection: #imageLiteral(resourceName: "Texture_PlanetEarth-specular"), planetClouds: #imageLiteral(resourceName: "Texture_PlanetEarth-clouds"), planetMountains: #imageLiteral(resourceName: "Texture_PlanetEarth-mountains"), planetPosition: earthPosition)

        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if node.name == "Planet" {
                node.removeFromParentNode()
            }
        })
    
        let earthShrinking = planetGrowing(planetEndSize: earthSize - 0.2)
        planetEarth.runAction(earthShrinking)
        
        self.sceneView.scene.rootNode.addChildNode(planetEarth)
    }


}


// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Januar 2018 (Swift ARKit bei Manu)
 *  Kapitel 7 – Gute Nacht
 *  - Button: Elias AR Zimmer erscheint
 *  - (lädt etwas zu lang..)
 *
 *  AUFGABE: Elias in seinem AR Zimmer besuchen
 *  (Vision für Zukunft: mehr Möbel, Kinderzimmer-Style und Interaktionsmöglichkeiten
 *   Und vlt. kleine EasterEggs, z.B. in Schubladen etwas Lustiges finden)
 *
 *  Online-Tutorials zu einem AR-Portal:
 *  www.codestars.com
 */
// ************************************ //

import SceneKit

public let roomPosition = SCNVector3(0,-1.5,-1)

extension ViewController {
    
    // Funktion: Elias AR Zimmer hinzufügen
    func addEliasRoom(){
        print("Willkommen in Elias AR Welt!")
        let room = model(modelPath: "Models.scnassets/Elias_Room_AR/eliasRoom.scn", modelSCNAssetsName: "Model_Elias_Room", modelName: "Room", modelPosition: roomPosition, printModel: "AR-Zimmer in der echten Welt, huui")
        
        self.sceneView.scene.rootNode.addChildNode(room)
        
        // den Objekten (Wänden) von „eliasRoom.scn" eine Textur geben:
        self.roomTextures(nodeName: "roof", roomNode: room, imageName: "Wand")
        self.roomTextures(nodeName: "backWall", roomNode: room, imageName: "Window")
        self.roomTextures(nodeName: "sideWall-right", roomNode: room, imageName: "Wand")
        self.roomTextures(nodeName: "sideWall-left", roomNode: room, imageName: "Steinwand")
        self.roomTextures(nodeName: "floor", roomNode: room, imageName: "219958-P0W1QJ-930")
    }
    
    
    // Funktion: Texturen für das roomDesign laden (Tapete, Teppich, ...)
    func roomTextures(nodeName: String, roomNode: SCNNode, imageName: String){
        let child = roomNode.childNode(withName: nodeName, recursively: true)
        /** Erklärung:
         recursively: true
         --> die einzelnen Wände sind children von „Walls"
         --> und nicht direkte children von „Model_Elias_Room"
        --> darum "true" (der ganze Subtree von „Model_..." wird durchgegangen)
         */
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Models.scnassets/Elias_Room_AR/textures_WallDesign/\(imageName).png")
        // --> Pfad zu den Texturen
    }
  
}

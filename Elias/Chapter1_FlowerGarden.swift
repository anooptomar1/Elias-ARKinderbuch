
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Dezember 2017 (Swift ARKit bei Manu)
 *  Kapitel 1 – Hi, ich bin Elias!
 *  - 3d Model Haus und Elias erscheinen automatisch
 *
 *  AUFGABE: Blumen in den Garten pflanzen per Button
 *  (Vision für Zukunft: verschiedene Blumen/Bäume auswählen und
 *   mehr Interaktion mit Elias, z.B. wenn man ihn antippt)
 */
// ************************************ //

import SceneKit

extension ViewController {
    
    // ************ Kapitel 1 – „Hi, ich bin Elias!" ************ //
    
    /* Funktion: Elias steht vor dem Haus
     --> Elias und das Haus werden automatisch angezeigt
     --> Position von Haus und Elias bestimmen
     (Haus-Entfernung, um den Garten gut zu bepflanzen)
     (Elias steht in der Haus-Einfahrt)
     */
    public func addEliasInFrontOfHouse() {
        guard let pointOfView = sceneView.pointOfView else
        {return}
        let Transform = pointOfView.transform       //--> Transform Matrix
        let Orientation = SCNVector3(-Transform.m31,-Transform.m32,-Transform.m33)
        let Location = SCNVector3(Transform.m41,Transform.m42,Transform.m43)
        let currentCameraPosition = Orientation + Location
        
        let housePosition = currentCameraPosition + SCNVector3(0,0, -0.5)
        // let housePosition = SCNVector3(x:0, y:-0.3,z:-1.5) // alte Pos.
        let eliasInFrontOfHousePosition = housePosition + SCNVector3(x:-0.25, y:-0.25, z:0.5)
        
        let eliasHouse = model(modelPath: "Models.scnassets/House/simplehouse.dae", modelSCNAssetsName: "Model_House", modelName: "House", modelPosition: housePosition, printModel: "Elias Haus erscheint in Kapitel 1")
        
        let wavingElias = elias(eliasModelsPath: "Models.scnassets/Elias_Waving/Waving.dae", eliasModelName: "Model_Elias_Waving", eliasName: "wavingElias", eliasPosition: eliasInFrontOfHousePosition, printElias: "Das ist Elias")
        
        wavingElias.eulerAngles = SCNVector3(0, 15.degreesToRadians, 0)
        // --> Elias rotieren (um die y-Achse)
        
        self.sceneView.scene.rootNode.addChildNode(eliasHouse)
        self.sceneView.scene.rootNode.addChildNode(wavingElias)
    }
    
    
    
    /* Funktion: Blume pflanzen
     --> Im Kapitel 1 „Hi, ich bin Elias!"
     --> Aktuelle Position ermitteln (currentFlowerPosition)
     --> Dorthin wird die Blume gepflanzt
     --> 3d Blume – auf func model() zugreifen („Function_3dModels.swift")
     */
    public func plantFlower() {
        guard let pointOfView = sceneView.pointOfView else
        {return}
        let Transform = pointOfView.transform       //--> Transform Matrix
        let Orientation = SCNVector3(-Transform.m31,-Transform.m32,-Transform.m33)
        let Location = SCNVector3(Transform.m41,Transform.m42,Transform.m43)
        let currentFlowerPosition = Orientation + Location
        
        let flower = model(modelPath: "Models.scnassets/Flower/cartoon_flower.dae", modelSCNAssetsName: "Model_Flower", modelName: "Flower", modelPosition: currentFlowerPosition, printModel: "Noch eine schöne Blume!")
        
        self.sceneView.scene.rootNode.addChildNode(flower)
    }
    
}


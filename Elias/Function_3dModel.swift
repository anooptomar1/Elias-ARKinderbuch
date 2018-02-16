
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Februar 2018 (Swift ARKit bei Manu)
 *  3d Model
 *  - alle 3d Modelle und Objekte der App
 *  - zurückgeben mit -> return
 *
 *  Kein umwerfend schönes Tutorial, aber hat sehr weitergeholfen:
 *  https://www.youtube.com/watch?v=5G5nGTUGEsI
 *  --> "How to Import 3D Objects & Characters Into iOS App Projects:
 *       SceneKit, COLLADA, and .dae"
*/
// ************************************ //

import SceneKit

extension ViewController {
  
    // Funktion: alle 3d Elias Modelle
    func elias(eliasModelsPath: String, eliasModelName: NSString, eliasName: NSString, eliasPosition: SCNVector3, printElias: NSString) -> SCNNode {
  
        let elias = SCNScene(named: eliasModelsPath)
        let eliasNode = elias?.rootNode.childNode(withName: eliasModelName as String, recursively: false)
        eliasNode?.name = eliasName as String
        eliasNode?.position = eliasPosition
        print(printElias)
        self.sceneView.scene.rootNode.addChildNode(eliasNode!)
        
        return eliasNode!
    }
    /** Erklärung:
     BEISPIEL, was diese Funktion elias() zurückgeben könnte: -> SCNNode
     
     let elias = SCNScene(named: "Models.scnassets/Elias_Waving/Waving.dae")
     let eliasNode = elias?.rootNode.childNode(withName: "Model_Elias_Wave", recursively: false)
     eliasNode?.name = "wavingElias"
     eliasNode?.position = SCNVector3(x:0, y:0,z:-1)
     print("Hello!")
     self.sceneView.scene.rootNode.addChildNode(eliasNode!)
     ------------------------------------------------------
     - eliasNode ist ein Child
     - rootNode = parentNode von ALLEN anderen Nodes!!!
     - withName = Model-Name (links in der Info bei einer Scene, z.B: „Model_Flower")
     - recursively: false = nicht jeden einzelnen Node im gesamten Subtree durchsuchen
     - eliasNode! = ! = auf jeden Fall!! Es ist ein Node, den du verwenden kannst
     */
    
    
    // im Prinzip die selbe Funktion wie elias()..
    // damals zur Übung gemacht (für alle 3d Modelle z.B. das Haus)
    func model(modelPath: String, modelSCNAssetsName: NSString, modelName: NSString, modelPosition: SCNVector3, printModel: NSString) -> SCNNode {
        
        let model = SCNScene(named: modelPath)
        let modelNode = model?.rootNode.childNode(withName: modelSCNAssetsName as String, recursively: false)
        modelNode?.name = modelName as String
        modelNode?.position = modelPosition
        print(printModel)
        self.sceneView.scene.rootNode.addChildNode(modelNode!)
        
        return modelNode!
    }
    
    
    // Funktion „plane" speziell für alle Planen (z.B. für „Elias_Room_AR")
    func plane(planeWidth: CGFloat, planeHeight: CGFloat, planeTexture: UIImage, planePosition: SCNVector3, printPlane: NSString) -> SCNNode {
        
    let plane = SCNNode(geometry: SCNPlane(width: planeWidth, height: planeHeight))
    plane.geometry?.firstMaterial?.diffuse.contents = planeTexture
    plane.geometry?.firstMaterial?.isDoubleSided = true
    // --> Textur auf beiden Seiten der Plane (davor teilweise nur einseitig)
    plane.position = planePosition
    plane.eulerAngles = SCNVector3(50.degreesToRadians, 0, 0)
        
    return plane
    }
}


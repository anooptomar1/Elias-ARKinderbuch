
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Dezember 2017 (Swift ARKit bei Manu)
 *  Kapitel 3 – Malen
 *  - Button: Mit AR im Raum bunt malen können
 *  - Button: Bild mit NEW-Button wieder löschen
 *
 *  AUFGABE: Ein Bild mit AR in die Umgebung malen
 *  (Vision für Zukunft: Komplette Farbpalette als Auswahl,
 *  Raddiergummi für einzelne Linien oder „weißes Blatt(plane)" als Unterlage)
 */
// ************************************ //

import SceneKit

extension ViewController {
   
    // Funktion: Scene rendern (ein unendlicher Loop)
    // --> solang etwas gerendert wird, wird diese Funktion getriggert
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        guard let pointOfView = sceneView.pointOfView else
        {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentDrawPosition = orientation + location
        /** Erklärung:
            aktuelle Position ermitteln für das Zeichnen
         
         currentDrawPosition = location + orientation
         
         Location vom iPhone:
         --> die aktuelle Position vom iPhone (ändert sich, wenn man sich im Raum bewegt)
         Orientation vom iPhone:
         --> wohin das iPhone „schaut" (ändert sich, wenn man das iPhone rotiert)
         
         SCNVector3(...)
         --> 3dVector mit (x, y, z)
         --> Minus(-transform), damit die Ausgabe in der Konsole positiv wird
         
         transform.m32
         --> transform-Matrix
         --> .m32 = collumn 3 und row 2 in der transform-Matrix
         */
        
    
        DispatchQueue.main.async {
            
        /** KAPITEL 3 - „Malen"
             
        Wenn der drawButton gedrückt wird, soll ein Punkt Farbe erscheinen
        --> SCNSphere             = Farbkreis (Radius: 0,02)
        --> currentDrawPosition   = Position: da, wo wir hinmalen wollen
        --> addChildNode(colour)  = Ein Farbkreis wird an dieser Position hinzugefügt
             
        Wenn man den drawButton gedrückt hält und das iPhone bewegt,
        entsteht eine Farb-Linie aus mehreren Farbkreisen
        Es sieht so aus, als würde man in der Luft malen! :)
        */
            if self.drawButtonRed.isHighlighted {
                //rot malen
                let colourRed = colour(whichColor: UIColor.red, colourName: "rot", colourPosition: currentDrawPosition, printColour: "rot malen")
                self.sceneView.scene.rootNode.addChildNode(colourRed)
            }
                
            else if self.drawButtonBlue.isHighlighted {
                // blau malen
                let colourBlue = colour(whichColor: UIColor.blue, colourName: "blau", colourPosition: currentDrawPosition, printColour: "blau malen")
                self.sceneView.scene.rootNode.addChildNode(colourBlue)
            }
                
            else if self.drawButtonYellow.isHighlighted {
                // gelb malen
                let colourYellow = colour(whichColor: UIColor.yellow, colourName: "gelb", colourPosition: currentDrawPosition, printColour: "gelb malen")
                self.sceneView.scene.rootNode.addChildNode(colourYellow)
            }
                
            else if self.drawButtonGreen.isHighlighted {
                //grün
                let colourGreen = colour(whichColor: UIColor.green, colourName: "grün", colourPosition: currentDrawPosition, printColour: "grün malen")
                self.sceneView.scene.rootNode.addChildNode(colourGreen)
                
            } else {
                /** Erklärung:
                 else-Statement, wenn der drawButton NICHT gedrückt wird
                 
                 Damit man weiß, wo man sich gerade befindet bzw. gleich hinmalen wird:
                 myPosition
                 --> zeigt dem Nutzer die Position zum Malen
                 
                 Nur die neueste „myPosition" soll als Farbpunkt hinzugefügt werden:
                 enumerateChileNodes({...)
                 --> loop durch jeden Node, der ein ChildNode der Scene ist
                 if node.name == "myPosition"
                 --> wenn der Node „myPosition" heißt, ...
                 node.removeFromParentNode()
                 --> ... wird er vom parentNode entfernt
                 --> also nur die neueste „myPosition" wird hinzugefügt!
                 */
                let myPosition = SCNNode(geometry: SCNSphere(radius: 0.01))
                myPosition.name = "myPosition"
                myPosition.position = currentDrawPosition
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "myPosition" {
                        node.removeFromParentNode()
                    }
                })
 
                self.sceneView.scene.rootNode.addChildNode(myPosition)
                myPosition.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            }
            
        }
    }
    
}



// Funktion: Farbpunkt (SCNSphere)
func colour(whichColor: UIColor, colourName: NSString, colourPosition: SCNVector3, printColour: NSString)-> SCNNode {
    
    let colour = SCNNode(geometry: SCNSphere(radius: 0.02))
    colour.geometry?.firstMaterial?.diffuse.contents = whichColor
    colour.name = colourName as String
    colour.position = colourPosition
    print(printColour)
    return colour
}


// Funktion, damit 2 SCNVector3 addiert werden können (z.B. Location+Orientation)
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    //--> SCNVector(x1 + x2, y1 + y2, z1 + z2)
}

 

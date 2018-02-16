
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Februar 2018 (Swift ARKit bei Manu)
 *  Kapitel 5 – Basketball
 *  - Basketballfeld erscheint automatisch
 *  - 3d Model von Elias, der Basketball dribbelt
 *  - Button: Basketball werfen
 *
 *  AUFGABE: Einen Korb werfen!
 *  (Vision für Zukunft: Zeit-Counter einbauen, Punkte und Soundeffekte)
 */
// ************************************ //

import SceneKit

// public let, damit addDribbleElias() und bounceBasketball() darauf zugreifen können
public let dribblingEliasPosition = SCNVector3(x:0, y:-0.5,z:-1)


extension ViewController {
    
    // Funktion: 3d Model Elias dribbelt
    func addDribblingElias() {
        
        let dribblingElias = elias(eliasModelsPath: "Models.scnassets/Elias_Dribbling/Dribble.dae", eliasModelName: "Model_Elias_Dribbling", eliasName: "dribblingElias", eliasPosition: dribblingEliasPosition, printElias: "Dribble, Elias!")
        
        self.sceneView.scene.rootNode.addChildNode(dribblingElias)
    }
    
    
    // Funktion: animierter Basketball fliegt hoch und runter (unter Elias Hand)
    func addEliasBasketball() {
        
        let basketballSize =  CGFloat(0.035)
        // let basketballColour = UIColor.orange
        let basketballColour = #imageLiteral(resourceName: "Texture_Basketball")
        // --> Textur: "Designed by photoangel/Freepik"
        
        let eliasBasketball = SCNNode(geometry: SCNSphere(radius: basketballSize))
        eliasBasketball.geometry?.firstMaterial?.diffuse.contents = basketballColour
        eliasBasketball.name = "eliasBasketball"
        
        if eliasBasketball.animationKeys.isEmpty {
            // wenn der Ball noch nicht animiert ist (.isEmpty)
            // -> starte Animation
            // wenn er schon am Animieren/Bouncen ist
            // -> NICHT NEU animieren
            // Grund: sonst entstehen super vieeele Basketbälle
            
            // Animation hinzufügen --> func bounceBasketball(ball: SCNNode)
            self.bounceBasketball(ball: eliasBasketball)
        }
        
        // damit nur 1 eliasBasketball da ist, egal wie oft der Button gedrückt wird:
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if node.name == "eliasBasketball" {
                node.removeFromParentNode()
            }
        })
        
        self.sceneView.scene.rootNode.addChildNode(eliasBasketball)
    }
    
    
    // Funktion: Animation vom Basketball (bounced hoch und runter)
    func bounceBasketball(ball: SCNNode) {
        
        // Animation "position" -> ändert Position im Raum (SCNVector3)
        let bounce = CABasicAnimation(keyPath: "position")
        
        // Basketball an dribblingEliasPosition angepasst --> Elias Hand
        let basketballStartPosition = dribblingEliasPosition + SCNVector3(x:-0.1, y:0.18, z:0.09)
        let basketballEndPosition = basketballStartPosition + SCNVector3(x:0, y:-0.18,z:0)
        
        // Bounce Geschwindigkeit (relativ synchron zur Handbewegung)
        let bounceSpeed = CFTimeInterval(0.35)
        
        // Bounce-Animation wiederholen.... gaaaaanz oft (annähernd "unendlich")
        let bounceRepetition = Float(600000000*6000000^100)
        
        bounce.fromValue = basketballStartPosition
        bounce.toValue = basketballEndPosition
        bounce.duration = bounceSpeed   // Dauer: StartPosition -> EndPosition
        bounce.autoreverses = true      // Ball animiert zurück zur StartPosition
        bounce.repeatCount = bounceRepetition
        
        // Animation hinzufügen
        ball.addAnimation(bounce, forKey: "position")
    }
    
    
    // Funktion: Basketballfeld ("Models.scnassets/Basketball/Basketball.scn")
    func addBasketballField() {
        
        let basketballField = model(modelPath: "Models.scnassets/Basketball/Basketball.scn", modelSCNAssetsName: "Model_Basketball", modelName: "BasketballFeld", modelPosition: SCNVector3(0,-1.3,-4), printModel: "Play Basketball") //(0,-1,-4)
        
        basketballField.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: basketballField, options: [SCNPhysicsShape.Option.keepAsCompound: true, SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron]))
        /** Erklärung:
         
         SCNPhysicsBody
         --> bekommt einen physikalischen Körper
         --> kann mit anderen physics Bodies kollidieren
         --> Ball prallt am basketballBackboard ab und fliegt nicht durch
         
        type: .static
         --> nicht von Schwerkraft beinflussbar (fällt nicht runter, wie der Ball)
         
         SCNPhysicsShape.ShapeType.concavePolyhedron
         --> provides the highest level of detail..
         --> it can detect perceived collission behaviour
         --> damit der Ring ein Loch hat (Basketball durchfliegen/an Kante abprallen)
         
         SCNPhysicsShape.Option.keepAsCompound
         --> verschiedene Geometrien und verschiedene Shapes
         --> Backboard und Ring (Torus) werden als verschiedene Shapes wahrgenommen
         */
 
        self.sceneView.scene.rootNode.addChildNode(basketballField)
    }
    
    
    // Funktion: Ball werfen
    func throwBasketball() {
    
        let basketballSize =  CGFloat(0.13)
        let basketballColour = #imageLiteral(resourceName: "Texture_Basketball")   // Textur: "Designed by photoangel/Freepik"
        let throwPower = Float(7)   // Wurfstärke: X-mal so powerfull
        
        guard let pointOfView = sceneView.pointOfView else
        {return}
        // Transform Matrix
        let Transform = pointOfView.transform
        let Orientation = SCNVector3(-Transform.m31,-Transform.m32,-Transform.m33)
        let Location = SCNVector3(Transform.m41,Transform.m42,Transform.m43)
        let currentBallPosition = Orientation + Location
        
        let Basketball = SCNNode(geometry: SCNSphere(radius: basketballSize))
        Basketball.name = "Basketball"
        Basketball.geometry?.firstMaterial?.diffuse.contents = basketballColour
        Basketball.position = currentBallPosition + SCNVector3(0,0.2,-0.5)
 
        // physicsBody, damit er geworfen und abprallen kann
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: Basketball))
        //** Erklärung:  type: .dynamic --> wird von Schwerkraft beeinflusst
        Basketball.physicsBody = body
        
        // Wenn der Ball abprall, wird er langsamer (verliert Speed)
        body.restitution = 0.2
        
        Basketball.physicsBody?.applyForce(SCNVector3(Orientation.x*power, Orientation.y*power, Orientation.z*power), asImpulse: true)
        //--> in Richtung werfen, wohin das iPhone „schaut" (orientation of the phone)

        // damit nur 1 Basketball in der Scene ist:
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if node.name == "Basketball" {
                node.removeFromParentNode()
            }
        })
        
        self.power = throwPower
        self.sceneView.scene.rootNode.addChildNode(Basketball)
    }

}

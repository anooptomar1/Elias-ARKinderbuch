
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Februar 2018 (Swift ARKit bei Manu)
 *  Kapitel 2 – Mein erster Schultag
 *  - 3d Auto erscheint durch Button-Klick
 *
 *  AUFGABE: X (noch in Bearbeitung)
 *  (Vision für Zukunft:
 *   Das Auto lenken durch Neigung/Drehen vom iPhone)
 */
// ************************************ //

import SceneKit
import CoreMotion   // importieren, um im Kapitel 2 das Auto zu lenken (iPhone neigen)


extension ViewController {
    
    // Tutorial: Auto lenken per Geste (Tracking einstellen)
    // iPhone: „change the screen orientation"
    
    func addCar() {
        
        guard let pointOfView = sceneView.pointOfView else
        {return}
        let Transform = pointOfView.transform
        let Orientation = SCNVector3(-Transform.m31,-Transform.m32,-Transform.m33)
        let Location = SCNVector3(Transform.m41,Transform.m42,Transform.m43)
        let currentCarPosition = Orientation + Location
    
        let car = model(modelPath: "Models.scnassets/Car/1987Camel Trophy Range Rover dae", modelSCNAssetsName: "Model_Car", modelName: "Car", modelPosition: currentCarPosition, printModel: "Ein cooler, gelber Truck!")

        
        /******** TEST-BEREICH ******* – in Bearbeitung
 
        // dem Auto einen physicsBody geben (.dynamic)
        // --> Kräfte können einwirken
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: car, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        body.mass = 1
        car.physicsBody = body
        // --> dem Auto einen physikaltischen Körper geben
        
        // eine Straße (Plane), auf der das Auto fahren kann:
        let street = plane(planeWidth: 4, planeHeight: 4, planeTexture: #imageLiteral(resourceName: "Texture_PlanetMoon"), planePosition: currentCarPosition + SCNVector3(0,-1,0), printPlane: "Straße wurde geteert")
        // --> Test-Textur: Mond-Textur
        let staticBody = SCNPhysicsBody.static()
        // --> Straße ist statisch!
        street.physicsBody = staticBody
        // --> keine Schwerkraft (auf ihr kann das Auto später fahren)
        
        //  let chassis = model(modelPath: "Models.scnassets/Car/1987Camel Trophy Range Rover.scn", modelSCNAssetsName: "chassis", modelName: "Car", modelPosition: currentCarPosition + SCNVector3(0,-1,0), printModel: "Ein cooler, gelber Truck!")
        //--> später wieder auf car?  geht das?
        //--> oder .dae??
        
        // self.sceneView.scene.rootNode.addChildNode(car)
        // self.sceneView.scene.rootNode.addChildNode(street)
 
        ********* TEST-ENDE *********/
        
        
        self.sceneView.scene.rootNode.addChildNode(car)
 }
    
    
    
    //************** IN BEARBEITUNG (online Tutorials) ****************//
    // Auto steuern, indem man das iPhone neigt
    
    
    // Funktion: motionManager
    func setUpAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1/60
            motionManager.startAccelerometerUpdates(to: .main, withHandler: { (accelerometerData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.accelerometerDidChange(acceleration: accelerometerData!.acceleration)
            })
        } else {
            print("accelerometer not available")
        }
    }
    
    func accelerometerDidChange(acceleration: CMAcceleration) {
        accelerationValues[1] = filtered(currentAcceleration: accelerationValues[1], UpdatedAcceleration: acceleration.y)
        accelerationValues[0] = filtered(currentAcceleration: accelerationValues[0], UpdatedAcceleration: acceleration.x)
        if accelerationValues[0] > 0 {
            self.orientation = -CGFloat(accelerationValues[1])
        } else {
            self.orientation = CGFloat(accelerationValues[1])
        }
    }
    
    func filtered(currentAcceleration: Double, UpdatedAcceleration: Double) -> Double {
        let kfilteringFactor = 0.5
        return UpdatedAcceleration * kfilteringFactor + currentAcceleration * (1-kfilteringFactor)
    }

}

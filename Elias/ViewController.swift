
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  November 2017 bis Februar 2018
 *  Mobile Programming ARKit bei Manu Rink
 *
 *  - Im Ordner „Elias_ARKinderbuch" ist das ARKinderbuch
 *  - Kapitelauswahl über den chapterButton steuern
 *
 *  Vision für Zukunft (geht jetzt noch nicht):
 *    - Kapitel per Texterkennung auswählen
 *    - Im 2. Kapitel das Auto mit dem iPhone lenken
 */
// ************************************ //


//---------------- Import ----------------//
// Frameworks importieren
import UIKit
import ARKit        // um ARKit framework zu verwenden
import CoreMotion   // im Kapitel 2 das Auto lenken (iPhone neigen)
import AVFoundation // für Sound

//---------------- ViewController ----------------//
// Main class
// alles was in DelegateFunction passiert, geschieht im Hintergrund
class ViewController: UIViewController, ARSCNViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

//---------------- IBOutlets ----------------//
// Verknüpfungen zum Storyboard (z.B. UIButton)
    @IBOutlet weak var helpText: UILabel!               // 0_HilfeText
    @IBOutlet weak var helpBubble: UIButton!            // 0_Sprechblase
    @IBOutlet weak var helpElias: UIButton!             // 0_EliasLogo
    @IBOutlet weak var flowerButton: UIButton!          // 1_BlumePflanzen
    @IBOutlet weak var carButton: UIButton!             // 2_AutoHinzufügen
    @IBOutlet weak var drawButtonRed: UIButton!         // 3_MalenRot
    @IBOutlet weak var drawButtonBlue: UIButton!        // 3_MalenBlau
    @IBOutlet weak var drawButtonYellow: UIButton!      // 3_MalenGelb
    @IBOutlet weak var drawButtonGreen: UIButton!       // 3_MalenGrün
    @IBOutlet weak var planetButton: UIButton!          // 4_PlanetAnzeigen
    @IBOutlet weak var planetGrowButton: UIButton!      // 4_PlanetWachsen
    @IBOutlet weak var planetShrinkButton: UIButton!    // 4_PlanetSchrumpfen
    @IBOutlet weak var danceButton: UIButton!           // 6_MusikUndEliasTanzt
    @IBOutlet weak var basketballButton: UIButton!      // 5_BasketballWerfen
    @IBOutlet weak var eliasRoomButton: UIButton!       // 7_EliasZimmerAnzeigen
    @IBOutlet weak var sceneView: ARSCNView!            // Scene
    @IBOutlet weak var pickerView: UIPickerView!        // Kapitel-Menü(„PickerView.swift")
    @IBOutlet weak var chapterButton: UIButton!         // Kapitel-Anzeige/-Auswahl
    @IBOutlet weak var clearButton: UIButton!           // 3_MalenLöschen
    
//---------------- Variablen ----------------//
// globale Variablen definieren (var und let)
    // Licht:
    var currentLightEstimate : ARLightEstimate?
    let spotLight = SCNLight()
    let ambientLight = SCNLight()
    
    // Alle Kapitel-Nummern in einem Array, startet bei 0 = „Kapitel"
    let chapterArray = ["Kapitel", "1", "2", "3", "4", "5", "6", "7"]
    
    // die Orientation und Location vom iPhone tracken (die ganze Zeit):
    let configuration = ARWorldTrackingConfiguration()
    
    // Auto steuern durch Neigung vom iPhone (Tutorial):
    // --> @Manu: geht nocht nicht :(
    let motionManager = CMMotionManager()
    var vehicle = SCNPhysicsVehicle()
    var orientation: CGFloat = 0
    var accelerationValues = [UIAccelerationValue(0), UIAccelerationValue(0)]
    var touched: Int = 0
    
    // Basketball-Wurfkraft (Kraft, die auf Ball einwirkt):
     var power: Float = 1.0
    
//---------------- viewDidLoad() ----------------//
// Einmalige Einstellung beim Starten der App
    override func viewDidLoad() {
        super.viewDidLoad()
        runSession()
        addLightToScene ()
        // self.sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        // --> FeaturePoints auskommentiert für das Demo-Video
    }
    
//---------------- IBActions ----------------//
// Den Objekten (UIButtons) vom Storyboard eine Aktion zuweisen

    @IBAction func selectChapter(_ sender: UIButton) {
        /* chapterButton:
         --> Kapitelauswahl (Kapitel 1-7, 0 = Hilfe-Text)
         --> Kapitel-Menü wird ausgeklappt („PickerView.swift")
         --> Scene wird automatisch wieder leer (neues Kapitel)
         --> Keine Musik = stopSound()
         */
        self.clearScene()
        isPickerViewHidden()
        stopSongGangnamStyle()
        print("Welches Kapitel magst du auswählen?")
    }
   
    // clearButton: Scene aufräumen (alle Nodes löschen)
    @IBAction func didTapClear(_ sender: Any) {
        self.clearScene()
        print("CLEAR")
    }
    
    // flowerButton: eine Blume pflanzen („Chapter1_FlowerGarden.swift")
    @IBAction func didTapFlower(_ sender: Any) {
        self.plantFlower()
        print("Eine schöne Blume wurde gepflanzt.")
    }
    
    // carButton: das Auto erscheint in der Scene („Chapter2_Car.swift")
    @IBAction func didTapCar(_ sender: Any) {
        self.addCar()
        print("Das Auto wurde hinzugefügt.")
    }
    
    // planetButton: Animation von Erde und Mond („Chapter4_Planets.swift")
    @IBAction func didTapPlanets(_ animated: Bool) {
        self.addPlanetEarth()
        print("Ohhhh, die Erde.")
    }
    
    // planetGrowButton: Animation wachsende Erde („Chapter4_Planets.swift")
    @IBAction func didTapGrowPlanet(_ sender: Any) {
        self.growingPlanetEarth()
        print("Magic! Die Erde wird größer.")
    }
    
    // planetShrinkButton: Animation schrumpfende Erde („Chapter4_Planets.swift")
    @IBAction func didTapShrinkPlanet(_ sender: Any) {
        self.shrinkingPlanetEarth()
        print("Die Erde wird wieder klein.")
    }
    
    // danceButton: Musik und Elias tanzt zu GangnamStyle („Chapter6_Music.swift")
    @IBAction func didTapDance(_ sender: Any) {
        addDancingElias()
        playSongGangnamStyle()
        print("Dem dem dem dem. Wooppa Gangnam Style. GangnamStyle. Najeneun ttasaroun inganjeokin yeoja.")
    }
    
    // basketballButton: Basketball werfen („Chapter5_Basketball.swift")
    @IBAction func didTapBasketball(_ sender: Any) {
        self.throwBasketball()
        print("Ein Basketball wurde geworfen.")
    }
    
    // eliasRoomButton: AR Zimmer von Elias erscheint („Chapter7_Room.swift")
    @IBAction func didTapEliasRoom(_ sender: Any) {
        self.addEliasRoom()
        print("Hi! Komm mich doch mal in meinem Zimmer besuchen.")
    }
    
//---------------- Functions ----------------//
// Funktionen definieren (und in den @IBAction func aufrufen)
// --> einige Funktionen sind in „Chapter1/2/.../7.swift"

    /* Funktion: clearScene()
     --> Wenn man auf den chapterButton tippt / clearButton im Kapitel 3 „Malen"
     --> Loop durch alle ChildNodes und entfernt alle vom ParentNode
     --> Löscht alle Nodes aus der Scene
     --> Wieder leere Scene = neues Kapitel / neues Bild malen
     */
    func clearScene() {
        self.sceneView.scene.rootNode.enumerateChildNodes({ (allChildNodes, _) in allChildNodes.removeFromParentNode()
            print("Alle childNodes aus der Scene gelöscht!")
        })
    }
    
    func runSession() {
        // Buttons sind unsichtbar beim Starten der App:
        // --> Main.storyboard > Buttons > .isHidden = true
        // --> .isHidden = false (Button ist sichtbar beim Start)
        helpElias.isHidden = false
        helpBubble.isHidden = false
        helpText.isHidden = false
        // pickerView:
        pickerView.delegate = self
        pickerView.dataSource = self
        // SceneView runs per session with configuration:
        self.sceneView.session.run(configuration)
        // aktivieren, sonst läuft garnichts:
        self.sceneView.delegate = self
    }
    
    func addLightToScene() {
        // Licht in die Scene hinzufügen:
        self.sceneView.autoenablesDefaultLighting = true
        // spotLight (aus Manu's Code „HomeHero"):
        spotLight.type = .omni
        spotLight.name = "omniLight"
        let spotNode = SCNNode()
        spotNode.light = spotLight
        spotNode.position = SCNVector3Make(0, 50, 0)
        sceneView.scene.rootNode.addChildNode(spotNode)
        // ambientLight (aus Manu's Code „HomeHero"):
        ambientLight.type = .ambient
        ambientLight.name = "ambientLight"
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        ambientNode.position = SCNVector3Make(0, 50, 50)
        sceneView.scene.rootNode.addChildNode(ambientNode)
    }
    
    func updateLights () {
        // (aus Manu's Code „HomeHero")
        if let lightInfo = currentLightEstimate {
            spotLight.intensity = lightInfo.ambientIntensity
            spotLight.temperature = lightInfo.ambientColorTemperature
            ambientLight.intensity = lightInfo.ambientIntensity / 2
            ambientLight.temperature = lightInfo.ambientColorTemperature
        }
    }
    
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
        super.didReceiveMemoryWarning()
    }
    
    
    
//********************* TEST-BEREICH-START **********************//
    
    // Funktion draus machen (wird oft im Code gebraucht)!!
    // --> ...enumerateChildNodes({ (node, _)...
    
    //TEST 1!! --> no
    /*
    func removeObjects(nodeName: NSString) -> NSString {
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if node.name == nodeName as String {
                node.removeFromParentNode()
            }
        })
        return nodeName
    }
     */
    
    //TEST 2!! --> NOPE, alles wird gelöscht (clearScene) ... auch die Zeichnungen!
    /*
    func removeObject(){
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            node.removeFromParentNode()
        })
    }
    */
//********************* TEST-BEREICH-ENDE **********************//
    
    
} // <-- letztes } !!!


// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Januar 2018 (Swift ARKit bei Manu)
 *  Kapitel 6 – Musik
 *  - Song laden („Song_GangnamStyle_freeMusic.mp3")
 *  - Song wieder stoppen in anderen Kapiteln
 *  - Button: Musik spielt ab und Elias tanzt
 *
 *  Musik einbinden/Sound laden:
 *  https://stackoverflow.com/questions/32036146/how-to-play-a-sound-using-swift
 *
 *  AUFGABE: Elias zum Tanzen bringen
 *  (Vision für Zukunft: Mehr Lieder und verschiedene Tänze auswählen
 *  und vlt. Karaoke-Funktion (AR-Songtexte im Raum) zum Mitsingen
 */
// ************************************ //


import SceneKit
import AVFoundation         // importieren für Sound

var player: AVAudioPlayer?  // AVAudioPlayer für Sound


// Funktion: Song laden und abspielen
func playSongGangnamStyle() {
    
  guard let url = Bundle.main.url(forResource: "Song_GangnamStyle_freeMusic", withExtension: "mp3") else {
     print("url not found")
    return
    }
    do {
         // this codes for making this app ready to takeover the device audio
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        /* The following line is required for the player to work on iOS 11. Change the file type accordingly */
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else { return }
        player.play()   // Musik spielt ab mit .play()
    } catch let error as NSError {
        print("error: \(error.localizedDescription)")
    }
}

// Problem: brauch eine neue Funktion
// Musik soll wieder aufhören und nicht in jedem Kapitel abspielen


// Funktion: Song stoppen
func stopSongGangnamStyle() {
    
    guard let url = Bundle.main.url(forResource: "Song_GangnamStyle_freeMusic", withExtension: "mp3") else { return }
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true) //false
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else { return }
        player.stop()   // Musik hört auf zu spielen mit .stop()
    } catch let error {
        print(error.localizedDescription)
    }
}


extension ViewController {

    /* danceButton
     --> Im Kapitel 6 „Musik"
     --> Aktuelle Position ermitteln (currentDancePosition)
     --> Dort tanzt Elias
     --> 3d Elias – auf func elias() zugreifen („Function_3dModels.swift")
     --> Musik abspielen – func playSong()
     */
    // Funktion: tanzenden Elias hinzufügen
    func addDancingElias(){
    
        let dancingElias = elias(eliasModelsPath: "Models.scnassets/Elias_Dancing/Gangnam Style.dae", eliasModelName: "Model_Elias_GangnamDance", eliasName: "dancingElias", eliasPosition: SCNVector3(x:0, y:-0.5,z:-1), printElias: "Dance Elias, dance!")
    
        // let breakdancingElias = elias(eliasModelsPath: "Models.scnassets/Elias_Dancing_Breakdance/Breakdance Footwork To Idle.dae", eliasModelName: "Model_Elias_Breakdance", eliasName: "dancingElias", eliasPosition: SCNVector3(x:0.5, y:-0.5,z:-1), printElias: "Cooler Breakdance Tanz!")
    
        //  let twistdancingElias = elias(eliasModelsPath: "Models.scnassets/Elias_Dancing_TwistDance/Twist Dance.dae", eliasModelName: "Model_Elias_Twistdance", eliasName: "dancingElias", eliasPosition: SCNVector3(x:-0.5, y:-0.5,z:-1), printElias: "Fancy Twist Tanz!")
    
        // Damit es nur einen tanzenden Elias in der Scene gibt:
        self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if node.name == "dancingElias" {
                node.removeFromParentNode()
            }
        })
    
        self.sceneView.scene.rootNode.addChildNode(dancingElias)
    
        /*
         // nach 3 Sekunden erscheinen zwei weitere Elias-Tänzer:
         DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
         self.sceneView.scene.rootNode.addChildNode(breakdancingElias)
         self.sceneView.scene.rootNode.addChildNode(twistdancingElias)
         }
         */
        }

}

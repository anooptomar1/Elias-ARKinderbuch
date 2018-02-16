
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Januar 2018 (Swift ARKit bei Manu)
 *  Kapitel-Auwahl
 *  Menü klappt aus (Picker View)
 *  Steuern, was bei Kapitel 1/2/... passiert
 *  (z.B. einen Button verbergen)
 *
 *  Online-Tutorials/Code zur Picker View:
 *  „MeinErsteHilfeKasten.swift" – Punkt 13
 */
// ************************************ //

import SceneKit

//let chapterArray = ["Kapitel", "1", "2", "3", "4", "5", "6", "7"]

extension ViewController {
  
    // Funktion: returns the number of 'columns' to display
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Funktion: pickerView (returns the # of rows in each component)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chapterArray.count
        //Array komplett durchzählen mit .count
    }
    
    // Funktion: pickerView (was soll in der pickerView drin stehen?!)
    func pickerView(_ pickerView: UIPickerView, titleForRow chapter: Int, forComponent component: Int) -> String? {
        return chapterArray[chapter]
        // Was soll in den PickerView Reihen stehen? --> chapterArray
        // Reihe (row) wird zurückgegeben z.B. 3 (steht für Kapitel 3)
    }
    
    // Funktion: pickerView (*** KAPITEL-MENÜ ***)
    func pickerView(_ pickerView: UIPickerView, didSelectRow chapter: Int, inComponent component: Int) {
        chapterButton.setTitle(chapterArray[chapter], for: .normal)
        /** Erklärung:
            chapterButton wird benannt nach der PickerView-Auswahl (.setTitle)
            je nachdem was man auswählt, ändert sich der Titel im chapterButton
            z.B. auf row "3" klicken --> im chapterButton steht "3"
         */
        pickerView.isHidden = true
        // --> Picker View (Kapitelauswahl) verschwindet wieder
        

// ************ Kapitel 0 – „Start – Hilfetext" ************ //
        
        if (chapter == 0) {
            // Buttons und Labels erscheinen:
            helpElias.isHidden = false
            helpBubble.isHidden = false
            helpText.isHidden = false
            // nach 5 Sekunden ab jetzt .now() verschwindet es:
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                // Buttons und Labels verschwinden wieder:
                self.helpElias.isHidden = true
                self.helpBubble.isHidden = true
                self.helpText.isHidden = true
            }
            // Wenn 0 („Kapitel") nicht ausgewählt ist:
        } else {
            // Buttons und Labels verschwinden wieder:
            helpElias.isHidden = true
            helpBubble.isHidden = true
            helpText.isHidden = true
        }
        
// ************ Kapitel 1 – „Hi, ich bin Elias!" ************ //
        
        if (chapter == 1){
            flowerButton.isHidden = false
            addEliasInFrontOfHouse()
        } else {
            flowerButton.isHidden = true
        }
 
// ************ Kapitel 2 – „Erster Schultag" ************ //
        
        if (chapter == 2){
            carButton.isHidden = false
            print("in Bearbeitung")
        } else {
            carButton.isHidden = true
        }
        
// ************ Kapitel 3 – „Malen" ************ //
        
        if (chapter == 3){
            drawButtonRed.isHidden = false
            drawButtonBlue.isHidden = false
            drawButtonYellow.isHidden = false
            drawButtonGreen.isHidden = false
            clearButton.isHidden = false
            // Licht aus, damit es mehr wie eine Farblinie aussieht
            // --> sonst wird jede einzelne Sphere beleuchtet:
            self.sceneView.autoenablesDefaultLighting = false
        } else {
            drawButtonRed.isHidden = true
            drawButtonBlue.isHidden = true
            drawButtonYellow.isHidden = true
            drawButtonGreen.isHidden = true
            clearButton.isHidden = true
        }
        
// ************ Kapitel 4 – „Unsere Erde" ************ //
        
        if (chapter == 4){
            planetButton.isHidden = false
            planetShrinkButton.isHidden = false
            planetGrowButton.isHidden = false
        } else {
            planetButton.isHidden = true
            planetShrinkButton.isHidden = true
            planetGrowButton.isHidden = true
        }
        
// ************ Kapitel 5 – „Basketball" ************ //
        
        if (chapter == 5){
            basketballButton.isHidden = false
            // Basketballfeld und Elias erscheinen automatisch in der Scene:
            addBasketballField()
            addDribblingElias()
            addEliasBasketball()
        } else {
            basketballButton.isHidden = true
        }
        
// ************ Kapitel 6 – „Musik" ************ //
        
        if (chapter == 6){
            danceButton.isHidden = false
        } else {
            danceButton.isHidden = true
            // Musik hört auf zu spielen:
            stopSongGangnamStyle()
        }
        
// ************ Kapitel 7 – „Gute Nacht" ************ //
        
        if (chapter == 7){
            eliasRoomButton.isHidden = false
            self.sceneView.autoenablesDefaultLighting = false
        } else {
            eliasRoomButton.isHidden = true
        }
        
    }
    
    
    // Funktion aufrufen in „ViewController.swift" > @IBAction func selectChapter
    func isPickerViewHidden() {
        if pickerView.isHidden {
            pickerView.isHidden = false
        }
    }
 
    
}





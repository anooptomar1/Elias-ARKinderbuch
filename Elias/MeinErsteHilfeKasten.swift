
// ************************************ //
/*
 *  Elias ARKinderbuch – Janine Weirich
 *  Februar 2018 (Swift ARKit bei Manu)
 *  Mein Erste Hilfe Kasten:
 *  FEHLER_ERROR_BUGS_TUTORIALS
 *  - Fehlermeldungen, die 1-3 mal angezeigt wurden
 *    und wie man sie schnell behebt (fürs nächste Mal)
 *  - hilfreiche Tutorials zu verschiedenen Themen
 */
// ************************************ //

/* 1 – SIGABERT
 
 Lösung:
 Sehr wahrscheinlich im Storyboard
 ein Button falsch verbunden
 Rechtsklick auf Button
 Dort kann man die Verbindung vom Code richtig löschen
 Nicht nur im Code die Zeile löschen
 @IBAction ...
 Sondern auch die Verbindung beim Button löschen
 (x drücken)
 */


/* 2 – Could not located devide support files.
 
 iOS 11.3 auf dem iPhone installiert (30.01.18)
 App kann 2 Tage NICHT mehr auf das iPhone geladen werden (Simulator). PANIK
 
 Fehlermeldung:
 „Could not located devide support files.
 This iPhone 8+ (Model: ....) is running iOS 11.3 (....),
 which may not be supported by this version of xcode."
 
 Wollte erst das Update rückgängig machen,
 Tutorials, wie man über iTunes das Alte wiederbekommt
 ABER BESSERE LÖSUNG (ohne iPhone neu aufzusetzen):
 
 Lösung:
 1 – xCode Beta herunterladen
 2 – Auf Mac in Programme/Applications Rechtsklick auf Beta
 Contents > Developer > Platforms > iPhoneOS.platform > DeviceSupport
 Dort stehen alle Versionen (8.1, ..... 11.3)
 11.3 kopieren
 3 – Auf Mac in Programme/Applications Rechtsklick auf normal xCode
 Contents > Developer > Platforms > iPhoneOS.platform > DeviceSupport
 Dort stehen alle Versionen (8.1, ..... 11.2)
 11.3 einfügen (aus Beta kopiert)
 4 – xCode neu starten
 5 – Funktioniert wieder! juhu
 
 Hilfreichester Link:
 https://medium.com/swiftist/how-to-use-ios-11-beta-installed-device-with-xcode-8-c255b916aca5
 */


/* 3 – Warnung wegen der Info.plist
 
 Warning:
 „The Copy Bundle Resources build phase contains this target's Info.plist file 'Elias/Info.plist'."
 
 Lösung:
https://developer.apple.com/library/content/qa/qa1649/_index.html
 --> Elias (blaues xCode Symbol) > „Build Phases" > „Copy Bundle Resources"
       > Liste erscheint > Info.plist daraus löschen
*/

 
/* 4 – Storyboard –> Text/Label -> Wie mache ich einen Zeilenumbruch?
 
 Lösung:
 Label auswählen
 „Line Break" -> „Word Wrap" auswählen
 „Lines: 1" -> „Lines: 2, 3, ..."
 (wie viele Zeilen man haben möchte)
 Lösung dank Stackoverflow:
 https://stackoverflow.com/questions/27762236/line-breaks-and-number-of-lines-in-swift-label-programmatically
 */


/* 5 – Button kann nicht in den Code gezogen/verlinkt werden
 
 Problem:
 Button aus Storyboard in den Code gezogen
 Normal erstellt man so ein IBOutlet / IBAction /...
 Funktionierte ein paar mal nicht
 aus komischen Gründen..
 
 Lösung:
 Im Code „ViewController.swift" schreiben:
 @IBOutlet wear var BUTTONNAME: UIButton!
 Dann zum Storyboard wechseln
 Button auf den geschrieben Code ziehen
 Funktioniert auch so!
 */


/* 6 – In einer Funktion einen String zurückgeben
 
 func NAME(position: SCNVevtor3, eliasName: String) -> SCNNode {
 
 Wenn man in so einer Funktion den Name als String zurück geben will
 Beispiel:
 elias.name = "elias"
 dann muss man das z.B. so schreiben:
 elias.name = eliasName as String
 
 return elias
 */


/* 7 – codedesign failed with exit code 1 (1)
 
 Fehlermeldung:
 „Command /usr/bin/codedesign failed with exit code 1"
 
 Lösung:
 https://www.youtube.com/watch?v=JlsDzOvkWDk
 --> Im Terminal:
 „xattr -cr" Pfad, an dem das Projekt abgespeichert ist
 „find . -type f -name `*,png`-exec xattf -c {} ..."
 --> Funktioniert wieder
 */


/* 8 – codesign failed with exit code 1 (2)
 
 Fehlermeldung:
 „no identity found Command /usr/bin/codesign failed with exit code 1“
 
 Lösung:
 https://stackoverflow.com/questions/29242485/command-usr-bin-codesign-failed-with-exit-code-1-code-sign-error/29243456
 --> Detailierte Beschreibung, echt gut!
 */


/* 9 – World tracking has encountered a fatal error.
 
 Lösung:
 https://stackoverflow.com/questions/45511838/technique-world-tracking-performance-is-being-affected-by-resource-constraints
 */


/* 10 – Problem: Bild als Button?
 
 Button soll nicht nur eine Farbe haben
 Er soll ein Bild haben „Button Design"
 
 Lösung:
 https://www.youtube.com/watch?v=hqWJC9v9osc
 Lösung 2:
 https://stackoverflow.com/questions/27903500/swift-add-icon-image-in-uitextfield
 */


/* 11 – iPhone is busy. Waiting for Device.
 
 Fehlermeldung:
 „Xcode will continue when JW iPhone 8+  is finished."
 
 Lösung 1:
 https://stackoverflow.com/questions/46316373/xcode-9-iphone-is-busy-preparing-debugger-support-for-iphone
 --> Funktionierte!
 
 wenn das nicht geht...
 Lösung 2:
 xCode schleißen und neu starten
 --> Funktioniert!
 */


/* 12 – App öffnet nicht mehr
 
 Fehlermeldung:
 „A valid provisioning profile for this executable was not found."
 
 Lösung:
 Mac-Menü-Leiste: xCode > Product > „Clean"
 --> Funktioniert wieder!
 */


/* 13 – Wie bekomme ich ein relativ schönes, ausklappbares Kapitel-Menü????
 
 Lösung: PickerView als Kapitel-Menü
 
 Tutorials:
 https://developer.apple.com/documentation/uikit/uipickerview
  https://www.ralfebert.de/ios-examples/uikit/uicatalog-playground/UIPickerView/
 https://www.youtube.com/watch?v=tGr7qsKGkzY
 https://www.youtube.com/watch?v=rsPjf39DZKc
 https://www.youtube.com/watch?v=oHkEUibsShM
 https://www.youtube.com/watch?v=tGr7qsKGkzY
 https://www.youtube.com/watch?v=jdHw7D_tpMU
 In Zukunft (Picker View geschmeidig ausfahren):
 https://www.youtube.com/watch?v=dIKK-SCkh_c
 */


/* 14 – Problem: Wie soll das Interface aussehen?
 
 Design Inspiration für das Elias Menü (Picker View) und Button-Design
 
 Inspiration:
 https://www.youtube.com/watch?v=-o7qr1NpeNI
 https://www.youtube.com/watch?v=UvsM_sx7GCo
 --> Schöner Button (Chapter Button)
 */


/* 15 – 3D Modelle importieren
 
 Tutorials:
 https://www.youtube.com/watch?v=E-CbBIh044M
 https://www.youtube.com/watch?v=tgPV_cRf2hA
 */


/* 16 – Musik soll AUS sein, nicht kurz anspielen und dann stoppen
 
 Problem: Musik spielt in JEDEM Kapitel an bzw. auch im Menü
 
  Lösung:
  player.stop()
  --> Musik hört auf zu spielen mit: .stop()
  --> so simpel kann es manchmal sein.
 */


import UIKit
import Foundation
import WatchKit

class PlantFeeding: WKInterfaceController {
    
    @IBOutlet weak var scene: WKInterfaceSKScene!
    
    override func didAppear() {
        super.didAppear()
        
        
    }
    
    @IBAction func rightSwipeGestureRecognizer(_ sender: Any) {
        print("fertilizer")
    }
    
    @IBAction func downSwipeGestureRecgnizer(_ sender: Any) {
        print("sun")
    }
    
    @IBAction func leftSwipeGestureRecgnizer(_ sender: Any) {
        print("water")
    }
    
    

}
    

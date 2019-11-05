import UIKit
import Foundation
import WatchKit

class PlantFeedingIC: WKInterfaceController, WKCrownDelegate {
    
    @IBOutlet weak var scene: WKInterfaceSKScene!
    
    var tree = TreeScene(size: CGSize(width: 200, height: 200))
    
    var canResetZoom: Bool = false
    var crownAccumulator = 0.0
    var zoom : Int = 1
    
    override func willActivate() {
        super.willActivate()
        crownSequencer.focus()
        
        scene.presentScene(tree)
        tree.backgroundColor = .blue
        print("eentrou")
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        self.canResetZoom = false
        
        crownAccumulator += rotationalDelta
        
        if abs(crownAccumulator) > 0.05 {
            zoom = max(0, Int(sign(crownAccumulator)) + zoom)
            let scale : CGFloat = CGFloat(abs(zoom)) * 0.1 + 1
            self.scene.scene?.camera?.xScale = scale
            self.scene.scene?.camera?.yScale = scale
            
            crownAccumulator = 0
        }
        
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        self.canResetZoom = true
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            if self.canResetZoom {
                self.scene.scene?.camera?.run(.scale(to: 1.0, duration: 0.3))
                self.crownAccumulator = 0
                self.zoom = 0
            }
        }
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
    

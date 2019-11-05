//
//  InterfaceController.swift
//  c2-wachoski WatchKit Extension
//
//  Created by Otávio Baziewicz Filho on 18/10/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    //crown variables
    var canResetZoom: Bool = false
    var crownAccumulator = 0.0
    var zoom : Int = 1

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self
    }
    
    override func willActivate() {
        super.willActivate()
        crownSequencer.focus()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        self.canResetZoom = false
        
        crownAccumulator += rotationalDelta
        
        if abs(crownAccumulator) > 0.05 {
            zoom = max(0, Int(sign(crownAccumulator)) + zoom)
            let scale : CGFloat = CGFloat(abs(zoom)) * 0.1 + 1
//            Desconmentar quando adicionar a scene
//            self.scene.scene?.camera?.xScale = scale
//            self.scene.scene?.camera?.yScale = scale
            
            crownAccumulator = 0
        }
        
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        self.canResetZoom = true
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            if self.canResetZoom {
//                Desconmentar quando adicionar a scene
//                self.scene.scene?.camera?.run(.scale(to: 1.0, duration: 0.3))
                self.crownAccumulator = 0
                self.zoom = 0
            }
        }
    }

//    @IBAction func botaoTeste() {
//        print("botão")
//    }
}

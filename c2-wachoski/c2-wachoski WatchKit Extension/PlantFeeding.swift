//
//  PlantFeeding.swift
//  c2-wachoski WatchKit Extension
//
//  Created by João Raffs on 30/10/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import UIKit
import Foundation
import WatchKit

class PlantFeeding: WKInterfaceController {
    @IBOutlet weak var plantInterfaceImage: WKInterfaceImage!
    
    
    override func didAppear() {
//        plantInterfaceImage.
        
//        print
        
        
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
    

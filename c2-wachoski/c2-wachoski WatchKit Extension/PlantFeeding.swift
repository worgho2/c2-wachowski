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
    
	@IBOutlet weak var scene: WKInterfaceSKScene!
	var tree = TreeScene()
    
	override func willActivate() {
		super.willActivate()
		
		// Can change parameters:
		tree.backgroundColor = .darkGray
		tree.color = .white
		
		scene.presentScene(tree, transition: .crossFade(withDuration: 0.1))
		scene.scene?.scaleMode = .resizeFill
		
		// Do not change:
		tree.anchorPoint = CGPoint(x: 0.5, y: 0)
		tree.createTree()
		
//		printSizeValues()
	}
	
	func growNextLevel () {
		tree.growNewBranches()
//		printSizeValues()
	}
	
	func printSizeValues () {
		print("\n==== Interface Values ====")
		print("Width:  ", self.contentFrame.width)
		print("Height: ", self.contentFrame.height)
		print("\n==== SKScene Values ====")
		print("Width:  ", scene.scene?.size.width  ?? "nil")
		print("Height: ", scene.scene?.size.height ?? "nil")
		print("\n==== TreeScene Values ====")
		print("Width:  ", tree.frame.size.width)
		print("Height: ", tree.frame.size.height)
		print("-- Tree Size --")
		print("Width:  ", tree.width)
		print("Height: ", tree.height)
		print("ogBranch Scale: ", tree.ogBranch.shapeNode.xScale)
		print("")
	}
	
    override func didAppear() {
//        plantInterfaceImage.
        
//        print
        
        
    }
    @IBAction func rightSwipeGestureRecognizer(_ sender: Any) {
        print("fertilizer")
		growNextLevel()
    }
    @IBAction func downSwipeGestureRecgnizer(_ sender: Any) {
        print("sun")
		growNextLevel()
    }
    @IBAction func leftSwipeGestureRecgnizer(_ sender: Any) {
        print("water")
		growNextLevel()
    }
    
    
}
    

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

class PlantFeeding: WKInterfaceController, WKCrownDelegate {
    @IBOutlet weak var plantInterfaceImage: WKInterfaceImage!
    
    @IBOutlet weak var waterView: WKInterfaceGroup!
    @IBOutlet weak var fertilizerView: WKInterfaceGroup!
    @IBOutlet weak var sunView: WKInterfaceGroup!
    
    @IBOutlet weak var scene: WKInterfaceSKScene!
    var tree = TreeScene()
    
    //crown variables
    var canResetZoom: Bool = false
    var crownAccumulator = 0.0
    var zoom : Int = 1
    
    var agua = ResourceModel.instance.agua
    var sol = ResourceModel.instance.sol
    var fertilizante = ResourceModel.instance.fertilizante
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self
        agua = ResourceModel.instance.agua
        sol = ResourceModel.instance.sol
        fertilizante = ResourceModel.instance.fertilizante
        praApresentacao()
        animateResourceCircle()
        
        // Can change parameters:
        tree.backgroundColor = .black
        tree.color = .white
        
        scene.presentScene(tree, transition: .crossFade(withDuration: 0.1))
        scene.scene?.scaleMode = .resizeFill
        
        // Do not change:
        tree.anchorPoint = CGPoint(x: 0.5, y: 0)
        tree.createTree()
        
        
    }
    
    func praApresentacao(){
        agua.available = 150
        agua.total = 200
        sol.available = 100
        sol.total = 200
        fertilizante.available = 200
        fertilizante.total = 200
    }
    override func willActivate() {
        super.willActivate()
        
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
    @IBAction func upSwipeGestureRecognizer(_ sender: Any) {
        resetResource()
    }
    
    @IBAction func rightSwipeGestureRecognizer(_ sender: Any) {
        print(fertilizante.available)
        print(fertilizante.total)
        if (fertilizante.available >= 100){
            
            AudioManager.shared.play(soundEffect: .fertilizer)
            growNextLevel()
            useResource(resource: .fertilize)
        }
    }
    @IBAction func downSwipeGestureRecgnizer(_ sender: Any) {
        print(sol.available)
        if (sol.available >= 100){
            AudioManager.shared.play(soundEffect: .sun_1)
            growNextLevel()
            useResource(resource: .sun)
        }
    }
    @IBAction func leftSwipeGestureRecgnizer(_ sender: Any) {
        print(agua.available)
        if (agua.available >= 100){
            AudioManager.shared.play(soundEffect: .water)
            print("water")
            growNextLevel()
            useResource(resource: .water)
        }
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
    
    func animateResourceCircle(){
        self.waterView.setRelativeWidth(1, withAdjustment: 0)
        self.sunView.setRelativeWidth(1, withAdjustment: 0)
        self.fertilizerView.setRelativeWidth(1, withAdjustment: 0)
        
        animate(withDuration: 3) {
            print("relative")
            print(CGFloat(self.agua.available / self.agua.total))
            self.waterView.setRelativeHeight(CGFloat(self.agua.available / self.agua.total), withAdjustment: 0)
            //            self.waterView.setRelativeHeight(CGFloat(self.agua.available / self.agua.total), withAdjustment: 0)
            
            self.sunView.setRelativeHeight(CGFloat(self.sol.available / self.sol.total), withAdjustment: 0)
            //            self.sunView.setRelativeHeight(CGFloat(self.sol.available / self.sol.total), withAdjustment: 0)
            
            self.fertilizerView.setRelativeHeight(CGFloat(self.fertilizante.available / self.fertilizante.total), withAdjustment: 0)
            //            self.fertilizerView.setRelativeHeight(CGFloat(self.fertilizante.available / self.fertilizante.total), withAdjustment: 0)
        }
    }
    
    enum ResourceType {
        case sun
        case water
        case fertilize
    }
    
    func useResource(resource : ResourceType){
        animate(withDuration: 2) {
            if (resource == .sun){
                self.sol.available = 0
                self.sunView.setRelativeHeight(CGFloat(self.sol.available / self.sol.total), withAdjustment: 0)
                
            }
            else if (resource == .water){
                self.agua.available = 0
                self.waterView.setRelativeHeight(CGFloat(self.agua.available / self.agua.total), withAdjustment: 0)
            }
            else{
                self.fertilizante.available = 0
                self.fertilizerView.setRelativeHeight(CGFloat(self.fertilizante.available / self.fertilizante.total), withAdjustment: 0)
            }
        }
    }
    
    func resetResource(){
        animate(withDuration: 3) {
            self.sol.available = Double.random(in: 100 ... 200)
            self.sol.total = 200
            self.sunView.setRelativeHeight(CGFloat(self.sol.available / self.sol.total), withAdjustment: 0)
            
            self.agua.available = Double.random(in: 100 ... 200)
            self.agua.total = 200
            self.waterView.setRelativeHeight(CGFloat(self.agua.available / self.agua.total), withAdjustment: 0)
            
            self.fertilizante.available = Double.random(in: 100 ... 200)
            self.fertilizante.total = 200
            self.fertilizerView.setRelativeHeight(CGFloat(self.fertilizante.available / self.fertilizante.total), withAdjustment: 0)
        }
    }
}


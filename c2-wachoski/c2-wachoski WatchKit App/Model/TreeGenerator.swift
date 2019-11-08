//
//  TreeScene.swift
//  waxaski WatchKit Extension
//
//  Created by Kaz Born on 25/10/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

//>>>---------> TO MAKE WORK:
//	class InterfaceController: WKInterfaceController {
//
//		@IBOutlet weak var scene: WKInterfaceSKScene!
//
//		var tree = TreeScene(size: CGSize(width: 200, height: 200))
//
//		override func willActivate() {
//			super.willActivate()
//
//			// Can change parameters:
//			tree.backgroundColor = .darkGray
//			tree.color = .white
//			scene.presentScene(tree, transition: .crossFade(withDuration: 0.1))
//
//			// Must have exactly like this:
//			tree.anchorPoint = CGPoint(x: 0.5, y: 0)
//			tree.createTree()
//		}
//	}
//
//>>>---------> TO GROW NEXT LEVEL:
//	Call funcion:
//		tree.growNewBranches()

import SpriteKit
import Foundation

class TreeScene: SKScene {
	
	// Tree Color
	var color : UIColor = .white
	
	// Array of Branches by Level/Depth
	//                [depthOfBranch : [Branches]]
	var treeBranchs : [CGFloat: [Branch]] = [:]
	var plant       : Plant!
	
	// Original Branch
	var ogBranch    : Branch!
	
	// Size of the tree
	// ( to make tree fit in the view )
	var width  : CGFloat = 200
	var height : CGFloat = 200
	
	
	
	func createTree () {
		plant = Plant()
		
		createNewBranch(parent: nil, type: "A", depth: 0)
		
		self.scaleMode = .resizeFill
		
		width = self.size.width
		height = self.size.height
        
        backgroundColor = .black
	}
	
	override func didChangeSize(_ oldSize: CGSize) {
		super.didChangeSize(oldSize)
		width = self.size.width
		height = self.size.height
	}
	
	// ================== GROW TREE
	func growNewBranches () {
		// 1. Get the depth of the tips
		var depth : [CGFloat] = []
		
		for (key, _) in treeBranchs {
			depth.append(key)
		}
		
		let minDepth = depth.min()!
		
		// 2. Get array of branches to grow
		let branches : [Branch] = treeBranchs[minDepth]!
		
		// 3. Grow new branches
		for branch in branches {
			let types = getChildTypes(parentType: branch.type)
			
			for type in types {
				createNewBranch(parent: branch, type: type, depth: minDepth-1)
			}
		}
		
		// 4. Fix tree size in case it's too big to fit the screen
		let newBranches : [Branch] = treeBranchs[minDepth-1]!
		
		checkSize(branches: newBranches)
		
		saveTree()
	}
	
	// ======== ALGORITHM FOR TREE GROWTH
	func getChildTypes (parentType: Character) -> [Character] {
		var out : [Character] = []
		
		switch parentType {
		case "A": // Splits in 2
			out = ["A", "B"]
		case "B": // Splits in 3
			out = ["E", "C", "D"]
		case "C": // Splits in 2
			out = ["D", "B"]
		case "D": // Grows longer
			out = ["E"]
		default: // Stops growing
			out = []
		}
		
		return out
	}
	
	// ================== CREATE NEW BRANCH
	func createNewBranch (parent: Branch?, type: Character, depth: CGFloat) {
		// 1. Get all values
		let iniPos : CGPoint = parent?.endPos! ?? CGPoint(x: 0, y: 0)
		let length = getLength(parent: parent)
		let angle  = getAngle(type: type,parent: parent)
		
		// 2. Create new branch
		let newBranch = Branch(color: color, type: type, initialPos: iniPos, angle: angle, length: length, parent: parent)
		
		// 3. Input new branch in the array
		addToArray(depth: depth, branch: newBranch)
		
		// 4. Add Shape Node to view
		if parent != nil {
			parent?.shapeNode.addChild(newBranch.shapeNode)
		} else {
			self.addChild(newBranch.shapeNode)
			ogBranch = newBranch
		}
	}
	
	// ================= GET VALUES
	func getLength (parent: Branch?) -> CGFloat {
		if let pLength = parent?.length {
			let multiplier = CGFloat.random(in: 0.8...0.95)
			return pLength * multiplier
		}
		return 100
	}
	
	func getAngle (type: Character, parent: Branch?) -> CGFloat {
		
		// if parent != nil
		if let pAngle = parent?.angle {
			if type == "A" {
				return pAngle
			}
			else {
				var angle : CGFloat = pAngle + CGFloat.random(in: -60 ... 60)
				
				let safeguard : CGFloat = 10
				
				if angle > 180 - safeguard {
					angle = 180 - safeguard
					// to be sure it won't grow in a straight line
					// "attracted" to the light
					if angle == pAngle { angle -= safeguard }
				} else if angle < safeguard {
					angle = safeguard
					// to be sure it won't grow in a straight line
					// "attracted" to the light
					if angle == pAngle { angle += safeguard }
				}
				
				return angle
			}
		}
		
		// if parent == nil
		return 90
	}
	
	// ===================== TREE SIZE RELATIVE TO SCREEN SIZE
	func checkSize (branches: [Branch]) {
		var right : CGFloat = 0.0
		var left  : CGFloat = 0.0
		var maxY  : CGFloat = 0.0
		
		for branch in branches {
			if branch.endPos.y > maxY      { maxY  = branch.endPos.y }
			if branch.endPos.x > right     { right = branch.endPos.x }
			else if branch.endPos.x < left { left  = branch.endPos.x }
		}
		
		let decreaseHeight : CGFloat = calculateDecrease(current: maxY, target: height)
		let decreaseRight  : CGFloat = calculateDecrease(current: right, target: width/2)
		let decreaseLeft   : CGFloat = calculateDecrease(current: abs(left), target: width/2)
		
		if decreaseHeight > 0.0 || decreaseRight > 0.0 || decreaseLeft > 0.0 {
			if decreaseHeight > decreaseRight && decreaseHeight > decreaseLeft {
				let increase = calculateIncrease(current: height, target: maxY)
				fixScale(decrease: decreaseHeight, increase: increase)
			}
			else if decreaseRight > decreaseLeft {
				let increase = calculateIncrease(current: width/2, target: right)
				fixScale(decrease: decreaseRight, increase: increase)
				
			} else {
				let increase = calculateIncrease(current: width/2, target: abs(left))
				fixScale(decrease: decreaseLeft, increase: increase)
			}
		}
	}
	
	func fixScale (decrease: CGFloat, increase: CGFloat) {
		// 1. Decrease tree size
		let scale = ogBranch.shapeNode.yScale
		let newScale = scale * (1 - decrease)
		
		ogBranch.shapeNode.setScale(newScale)
		
		// 2. Fix tree size reference
		height = height * (1 + increase)
		width  = width  * (1 + increase)
	}
	
	func calculateDecrease (current: CGFloat, target: CGFloat) -> CGFloat {
		if current > target {
			return (current - target) / current
		}
		return 0.0
	}
	
	func calculateIncrease (current: CGFloat, target: CGFloat) -> CGFloat {
		if current < target {
			return (target - current) / current
		}
		return 0.0
	}
	
	// ================== SAVE TREE
	func addToArray (depth key: CGFloat, branch: Branch) {
		if let _ = treeBranchs.index(forKey: key) {
			treeBranchs[key]?.append(branch)
		} else {
			treeBranchs[key] = [branch]
		}
	}
	
	func saveTree() {
		plant.branches = treeBranchs
		
		Model.instance.updatePlant(plant: plant)
	}
}


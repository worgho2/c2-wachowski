//
//  TreeScene.swift
//  waxaski WatchKit Extension
//
//  Created by Kaz Born on 25/10/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import SpriteKit
import Foundation

/*
>>>---------> To make it work:

class InterfaceController: WKInterfaceController {
	// Outlet for the SKScene:
	@IBOutlet weak var scene: WKInterfaceSKScene!

	// Create TreeScene:
	var tree = TreeScene(size: CGSize(width: XX, height: XX))

	func willActivate () {
		super.willActivate()

		// Define Background color for SKScene
		tree.backgroundColor = .black

		// Present TreeScene in the SKScene
		scene.presentScene(tree, transition: .crossFade(withDuration: 0.1))

		// Create the 1st branch
		tree.createTree()
	}
}

>>>---------> To create 1 more layer of branches:
Call Function:
	tree.growNewBranches()

*/

class TreeScene: SKScene {
	
	// [depthOfBranch : [Branches]]
	var treeBranchs : [CGFloat: [Branch]] = [:]
	
	func createTree () {
		self.scaleMode = .aspectFit
		
		createNewBranch(parent: nil, type: "A", depth: 0)
	}
	
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
			// ******************************** Fix for 0 new branches!!
			let types = getChildTypes(parentType: branch.type)
			
			for type in types {
				createNewBranch(parent: branch, type: type, depth: minDepth-1)
			}
		}
	}
	
	func createNewBranch (parent: Branch?, type: Character, depth: CGFloat) {
		// 1. Get all values
		let lineWidth = getLineWidth()
		let iniPos : CGPoint = parent?.endPos! ?? CGPoint(x: self.frame.width/2, y: 0)
		
		var length : CGFloat = 50
		if let _ = parent?.length {
			length = self.getLength(parent: parent!)
		}
		
		var angle : CGFloat = 90
		if let parAngle = parent?.angle {
			if type == "A" {
				angle = parAngle
			} else {
				angle = parAngle + CGFloat.random(in: -50...50)
			}
		}
		
		// 2. Create new branch
		let newBranch = Branch(type: type, initialPos: iniPos, angle: angle, length: length, lineWidth: lineWidth, parent: parent)
		
		// 3. Input new branch in the arrays
		addToArray(depth: depth, branch: newBranch)
		
		// 4. Add Shape Node to view
		self.addChild(newBranch.shapeNode)
	}
	
	func getLength (parent: Branch) -> CGFloat {
		let multiplier = CGFloat.random(in: 0.7...0.9)
		return parent.length * multiplier
	}
	
	// ************************************ MAKE DYNAMIC
	func getLineWidth () -> CGFloat {
		
		return 1
	}
	
	// ************************************
	func getChildTypes (parentType: Character) -> [Character] {
		var out : [Character] = []
		
		switch parentType {
		case "A":
			out = ["A", "B"]
		case "B":
			out = ["E", "C", "D"]
		case "C":
			out = ["D", "B"]
		case "D":
			out = ["E"]
		default:
			out = []
		}
		
		out.shuffle()
		return out
	}
	
	func addToArray (depth key: CGFloat, branch: Branch) {
		if let _ = treeBranchs.index(forKey: key) {
			treeBranchs[key]?.append(branch)
		} else {
			treeBranchs[key] = [branch]
		}
	}
}

class Branch {
	var type		: Character = "A"
	var angle 		: CGFloat 	= 90
	var length      : CGFloat!
	var shapeNode 	: SKShapeNode!
	var iniPos		: CGPoint!
	var endPos		: CGPoint!
	var parent		: Branch?
	
	init (type: Character, initialPos: CGPoint, angle: CGFloat, length: CGFloat, lineWidth: CGFloat, parent: Branch?) {
		self.parent = parent
		self.angle  = angle
		self.iniPos = initialPos
		self.length = length
		endPos = getEndPos(initialPos: initialPos, angle: angle, length: length)
		shapeNode = drawLine(initialPos: initialPos, endPos: endPos, lineWidth: lineWidth)
	}
	
	func drawLine (initialPos: CGPoint, endPos: CGPoint, lineWidth: CGFloat) -> SKShapeNode {
		let path = UIBezierPath()
		path.move(to: initialPos)
		path.addLine(to: endPos)
		
		let node : SKShapeNode = SKShapeNode(path: path.cgPath)
		node.fillColor = .clear
		node.strokeColor = .white
		node.lineWidth = lineWidth
		
		return node
	}
	
	func getEndPos (initialPos: CGPoint, angle: CGFloat, length: CGFloat) -> CGPoint {
		let x = initialPos.x + length * cos(angle * .pi / 180)
		let y = initialPos.y + length * sin(angle * .pi / 180)
		
		return CGPoint(x: x, y: y)
	}
}

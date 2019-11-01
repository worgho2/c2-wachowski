//
//  TreeScene.swift
//  waxaski WatchKit Extension
//
//  Created by Kaz Born on 25/10/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//
/*
>>>---------> TO MAKE WORK:
class InterfaceController: WKInterfaceController {

	@IBOutlet weak var scene: WKInterfaceSKScene!

	var tree = TreeScene(size: CGSize(width: 200, height: 200))

	override func willActivate() {
		super.willActivate()

			// Can change parameters:
		tree.backgroundColor = .darkGray
		scene.presentScene(tree, transition: .crossFade(withDuration: 0.1))

			// Must have exactly like this:
		tree.anchorPoint = CGPoint(x: 0.5, y: 0)
		tree.createTree()
	}
}

>>>---------> TO GROW NEXT LEVEL:
Call funcion:
	tree.growNewBranches()

*/

import SpriteKit
import Foundation

class TreeScene: SKScene {
	
	// [depthOfBranch : [Branches]]
	var treeBranchs : [CGFloat: [Branch]] = [:]
	var ogBranch    : Branch!
	
	var width  : CGFloat = 200
	var height : CGFloat = 200
	
	func createTree () {
		//self.scaleMode = .aspectFit
		
		createNewBranch(parent: nil, type: "A", depth: 0)
		
		width = self.frame.size.width
		height = self.frame.size.height
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
		
		let newBranches : [Branch] = treeBranchs[minDepth-1]!
		
		checkSize(branches: newBranches)
	}
	
	func createNewBranch (parent: Branch?, type: Character, depth: CGFloat) {
		// 1. Get all values
		let lineWidth = getLineWidth()
		let iniPos : CGPoint = parent?.endPos! ?? CGPoint(x: 0, y: 0)
		
		var length : CGFloat = 100
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
		if parent != nil {
			parent?.shapeNode.addChild(newBranch.shapeNode)
		} else {
			self.addChild(newBranch.shapeNode)
			ogBranch = newBranch
		}
	}
	
	func checkSize (branches: [Branch]) {
		var right : CGFloat = 0.0
		var left : CGFloat = 0.0
		var maxY : CGFloat = 0.0
		
		for branch in branches {
			if branch.endPos.y > maxY { maxY = branch.endPos.y }
			if branch.endPos.x > right { right = branch.endPos.x }
			else if branch.endPos.x < left { left = branch.endPos.x }
		}
		
		let decreaseHeight : CGFloat = calculateDecrease(current: maxY, target: height)
		
		let decreaseRight  : CGFloat = calculateDecrease(current: right, target: width/2)
		let decreaseLeft   : CGFloat = calculateDecrease(current: abs(left), target: width/2)
		
		let decreaseWidth = getBiggest(value1: decreaseLeft, value2: decreaseRight)
		
		if decreaseHeight > 0.0 || decreaseWidth > 0.0 {
			if decreaseHeight > decreaseWidth {
				let increase = calculateIncrease(current: height, target: maxY)
				fixScale(decrease: decreaseHeight)
				fixTreeSize(increase: increase)
			}
			else if decreaseRight > decreaseLeft {
				let increase = calculateIncrease(current: width/2, target: right)
				fixScale(decrease: decreaseRight)
				fixTreeSize(increase: increase)
				
			}
			else {
				let increase = calculateIncrease(current: width/2, target: abs(left))
				fixScale(decrease: decreaseLeft)
				fixTreeSize(increase: increase)
			}
		}
	}
	
	func fixScale (decrease: CGFloat) {
		let multiplier = 1.0 - decrease
		let scale = ogBranch.shapeNode.yScale
		let newScale = scale * multiplier
		
		ogBranch.shapeNode.setScale(newScale)
	}
	
	func fixTreeSize (increase: CGFloat) {
		height = height * (1 + increase)
		width  = width  * (1 + increase)
	}
	
	func getBiggest (value1: CGFloat, value2: CGFloat) -> CGFloat {
		if value1 > value2 {
			return value1
		}
		else {
			return value2
		}
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
		shapeNode = drawLine(initialPos: initialPos, lineWidth: lineWidth)
	}
	
	func drawLine (initialPos: CGPoint, lineWidth: CGFloat) -> SKShapeNode {
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

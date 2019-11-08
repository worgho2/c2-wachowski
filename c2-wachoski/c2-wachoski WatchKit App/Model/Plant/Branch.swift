//
//  Branch.swift
//  c2-wachoski WatchKit Extension
//
//  Created by Kaz Born on 08/11/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import SpriteKit

class Branch {
	var type		: Character = "A"
	var angle 		: CGFloat 	= 90
	var thickness   : CGFloat   = 1
	var length      : CGFloat!
	var shapeNode 	: SKShapeNode!
	var iniPos		: CGPoint!
	var endPos		: CGPoint!
	var parent		: Branch?
	
	init (color: UIColor, type: Character, initialPos: CGPoint, angle: CGFloat, length: CGFloat, parent: Branch?) {
		self.parent = parent
		self.angle  = angle
		self.length = length
		self.type   = type
		iniPos      = initialPos
		endPos 	    = getEndPos(initialPos: initialPos, angle: angle, length: length)
		shapeNode   = drawLine(color: color)
		
		// makes sure the parent won't grow for every child
		// only grows once
		if self.parent?.thickness == 1 {
			self.parent?.upgradeThickness()
		}
	}
	
	func getEndPos (initialPos: CGPoint, angle: CGFloat, length: CGFloat) -> CGPoint {
		let x = initialPos.x + length * cos(angle * .pi / 180)
		let y = initialPos.y + length * sin(angle * .pi / 180)
		
		return CGPoint(x: x, y: y)
	}
	
	func drawLine (color: UIColor) -> SKShapeNode {
		let path = UIBezierPath()
		path.move(to: iniPos)
		path.addLine(to: endPos)
		
		let node : SKShapeNode = SKShapeNode(path: path.cgPath)
		node.fillColor = .clear
		node.strokeColor = color
		node.lineWidth = 1
		
		return node
	}
	
	//============ THICKNESS:
	//		--> # is how far the farthest tip is
	//
	//		* Parent is always _AT LEAST_ 1 level higher than children
	//		* Tips are always 1
	//		* Tips are either:
	//			- Last level created
	//			- Type E (doesn't create children)
	//
	//		Ex:
	//				\  /
	//				1\/1
	//			  \  /   /
	//			  1\/2  /1
	//				\  /
	//				3\/2
	//				  \
	//				  4\
	func upgradeThickness () {
		thickness += 1
		
		if parent?.thickness == thickness {
			parent?.upgradeThickness()
		}
		
		// Fix line width:
		let width = thickness * 0.3
		
		shapeNode.lineWidth = width
	}
}

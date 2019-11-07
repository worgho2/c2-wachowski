
import Foundation

protocol Resource{
	func interpretDataFromCircle() -> Int
	func useResource()// used when the resource button is   ssed
	func growthBasedInRatio() -> Int/* uses growthRatio*/ // returnes how much the plant should grow based in circle results.
	
	var growth : (water : Int, sun : Int, fertilizer: Int) {get set}
	
}

extension Resource{
	
}

class Water: Resource{
	var growth: (water: Int, sun: Int, fertilizer: Int)
	
	init(){
		growth = (0,0,0)
	}
	
	func interpretDataFromCircle() -> Int {
		return -1
	}
	
	func useResource() {
		
	}
	
	func growthBasedInRatio() -> Int {
		return -1
	}
}

class Sun: Resource{
	var growth: (water: Int, sun: Int, fertilizer: Int)
	
	init(){
		growth  = (0,0,0)
	}
	
	func interpretDataFromCircle() -> Int {
		return -1
	}
	
	func useResource() {
		
	}
	
	func growthBasedInRatio() -> Int {
		return -1
	}
	
	//
}

class Fertilizer: Resource{
	var growth: (water: Int, sun: Int, fertilizer: Int)
	
	init(){
		self.growth = (0,0,0)
	}
	
	func interpretDataFromCircle() -> Int {
		return -1
	}
	
	func useResource() {
		
	}
	
	func growthBasedInRatio() -> Int {
		return -1
	}
	
	
	//
}

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0..<256)/255, green: .random(in: 0..<256)/255, blue: .random(in: 0..<256)/255, alpha: 1)
    }
}

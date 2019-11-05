import UIKit

extension CGFloat {
    static func random(_ range: ClosedRange<Int>) -> CGFloat {
        return CGFloat(Int.random(in: range))
    }
}

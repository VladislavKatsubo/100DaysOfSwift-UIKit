
import UIKit
import PlaygroundSupport


extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        }
    }
}

let rectangle = UIView()
rectangle.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 256, height: 256))
rectangle.layer.cornerRadius = min(rectangle.frame.size.height, rectangle.frame.size.width) / 2.0
rectangle.backgroundColor = UIColor.brown

rectangle.bounceOut(duration: 10)

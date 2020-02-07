import UIKit

extension UIColor {
    public convenience init(hex: UInt64) {
        self.init(
            red: CGFloat((hex & 0xff000000) >> 24) / 255,
            green: CGFloat((hex & 0x00ff0000) >> 16) / 255,
            blue: CGFloat((hex & 0x0000ff00) >> 8) / 255,
            alpha: CGFloat(hex & 0x000000ff) / 255
        )
        
    }
}

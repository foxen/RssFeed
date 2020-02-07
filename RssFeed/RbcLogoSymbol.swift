import SwiftUI

struct RbcLogoSymbol: View {
    var body: some View {
        GeometryReader { geometry in
            paths(
                width: min(
                    geometry.size.width,
                    geometry.size.height
                ),
                lineWidth: 0.12,
                topLeftColor: 0x92CFAEFF,
                bottomRightColor: 0x2A8288FF
            )
        }
    }
}

fileprivate struct paths: View {
    
    var width, lineWidth: CGFloat
    var topLeftColor: UInt64, bottomRightColor: UInt64
    
    private func triangle(width: CGFloat, flip: CGFloat) -> (inout Path) -> () {{ path in
        
        func point(x: CGFloat, y: CGFloat) -> CGPoint {
            CGPoint(x: width * abs(x - flip), y: width * abs(y - flip))
        }
        
        let hlw = self.lineWidth / 2
        
        path.addLines([
            point(x: hlw, y: 1),
            point(x: 1,   y: hlw),
            point(x: 1,   y: 1)
        ])
    }}
    
    var body: some View {
        ZStack {
            
            Path.init(
                self.triangle(width: self.width , flip: 1.0 )
            ).fill(
                Color(UIColor(hex: self.topLeftColor))
            )

            Path.init(
                self.triangle(width: self.width, flip: 0.0)
            ).fill(
                Color(UIColor(hex: self.bottomRightColor))
            )
        }
    }
}

struct RbcLogoSymbol_Previews: PreviewProvider {
    static var previews: some View {
        RbcLogoSymbol().previewLayout(.fixed(width: 200, height: 200))
    }
}

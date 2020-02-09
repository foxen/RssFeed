import SwiftUI

extension View {
    public func aspectScale(
        srcW: CGFloat,
        srcH: CGFloat,
        dstW: CGFloat,
        dstH: CGFloat
    ) -> some View {
        
        let ratio = srcH / srcW > dstH / dstW ? dstW / srcW : dstH / srcH
        
        return self.frame(
            width: srcW * ratio,
            height: srcH * ratio
        ).frame(width: dstW, height: dstH).clipped()
    }
}

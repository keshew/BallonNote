import SwiftUI

extension Text {
    func Sand(size: CGFloat,
            color: Color = .black)  -> some View {
        self.font(.custom("Quicksand-Regular", size: size))
            .foregroundColor(color)
    }
    
    func SandBold(size: CGFloat,
            color: Color = .black)  -> some View {
        self.font(.custom("Quicksand-Bold", size: size))
            .foregroundColor(color)
    }
}

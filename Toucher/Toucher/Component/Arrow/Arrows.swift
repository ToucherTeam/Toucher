//
//  Arrows.swift
//  Toucher
//
//  Created by Hyunjun Kim on 1/4/24.
//

import SwiftUI

struct Arrows: View {
    @State var scale: CGFloat = 1.0
    @State var fade: Double = 0.2
    @State var isAnimating: Bool = false
    var arrowColor: Color = .white.opacity(0.5)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 36)
            .fill(arrowColor)
            .frame(width: 180, height: 72)
            .overlay(alignment: .trailing) {
                HStack(spacing: 0) {
                    ForEach(0..<3) { index in
                        Image(systemName: "chevron.left")
                            .font(.system(size: 28))
                            .fontWeight(.black)
                            .foregroundColor(.customPrimary)
                            .opacity(self.fade)
                            .scaleEffect(self.scale)
                            .animation(Animation.easeOut(duration: 0.9)
                                .repeatForever(autoreverses: true)
                                .delay(0.3 * Double(3 - index)), value: isAnimating)
                    }
                    Circle()
                        .foregroundColor(.customSecondary)
                        .frame(width: 56, height: 56)
                        .padding(.leading, 19)
                        .padding(.trailing, 8)
                }
            }
            .onAppear {
                self.isAnimating = true
                self.scale = 1.1
                self.fade = 1.0
            }
    }
}

#Preview {
    Arrows()
}

//
//  Arrows.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct Arrows: View {
    
    /// 사이즈 값을 외부에서 넣어 크기를 조절할 수 있습니다. Default는 28 입니다.
    @State var size: CGFloat = 28
    
    @State private var scale: CGFloat = 1.0
    @State private var fade: Double = 0.2
    @State private var isAnimating: Bool = false
        
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                Image(systemName: "chevron.left")
                    .font(.system(size: size))
                    .fontWeight(.black)
                    .foregroundColor(Color("Primary"))
                    .opacity(fade)
                    .scaleEffect(scale)
                    .animation(Animation.easeOut(duration: 0.9)
                        .repeatForever(autoreverses: true)
                        .delay(0.3 * Double(3 - index)), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
            scale = 1.1
            fade = 1.0
        }
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrows()
    }
}

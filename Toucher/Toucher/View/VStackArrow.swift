//
//  VStackArrow.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct VStackArrow: View {
    
    /// 사이즈 값을 외부에서 넣어 크기를 조절할 수 있습니다. Default는 28 입니다.
    var size: CGFloat = 28
    
    @State var scale: CGFloat = 1.0
    @State var fade: Double = 0.2
    @State var isAnimating: Bool = false
    
    var body: some View {
        VStack {
            ForEach(0..<3) { index in
                Image(systemName: "chevron.down")
                    .font(.system(size: size))
                    .fontWeight(.black)
                    .foregroundColor(Color("Primary"))
                    .opacity(self.fade)
                    .scaleEffect(self.scale)
                    .animation(Animation.easeOut(duration: 0.9)
                        .repeatForever(autoreverses: true)
                        .delay(0.3 * Double(3 + index)), value: isAnimating)
            }
        }
        .onAppear {
            self.isAnimating = true
            self.scale = 1.1
            self.fade = 1.0
        }

    }
}

struct VStackArrow_Previews: PreviewProvider {
    static var previews: some View {
        VStackArrow()
    }
}

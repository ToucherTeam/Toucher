//
//  FinishMainButton.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct FinishMainButton: View {
    var isTapped: Bool
    var gesture: GestureType
    var action: () -> Void
    
    var image: String {
        "Secondary" + gesture.rawValue
    }
    
    var body: some View {
        Image(isTapped ? image + "Pressed" : image)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 95)
            .offset(y: isTapped ? 5 : 0)
            .onTapGesture {
                action()
            }
    }
}

#Preview {
    FinishMainButton(isTapped: false, gesture: .doubleTap) {
        
    }
}

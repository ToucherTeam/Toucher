//
//  FinishMainButton.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct FinishMainButton: View {
    var gesture: GestureType
    var selectedGesture: GestureType?
    var action: () -> Void
    
    var image: String {
        "Secondary" + gesture.rawValue
    }
    
    var body: some View {
        Image(gesture == selectedGesture ? image + "Pressed" : image)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 95)
            .offset(y: gesture == selectedGesture ? 5 : 0)
            .onTapGesture {
                action()
            }
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.customBG0.ignoresSafeArea()
        
        FinishMainButton(gesture: .doubleTap, selectedGesture: .doubleTap) {
            
        }
    }
}

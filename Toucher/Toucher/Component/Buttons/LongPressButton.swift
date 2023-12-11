//
//  LongPressButton.swift
//  Toucher
//
//  Created by hyunjun on 12/11/23.
//

import SwiftUI

struct LongPressButton: View {
    @GestureState private var isTapped = false
    private let image = "ToucherButton"
    
    @State var isTapStart = false
    @State var isSuccess = false
    @State var isFail = false

    var body: some View {
        Image(isSuccess ? image + "Success" : isTapped ? image + "Pressed" : image)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 95)
            .offset(y: isTapped || isSuccess ? 5 : 0)
            .gesture(longPress)
            .frame(maxWidth: .infinity)
    }
    
    private var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isTapped) { currentState, gestureState, _ in
                gestureState = currentState
            }
            .onEnded { finished in
                    isSuccess = finished
                    print("isSuccess : \(isSuccess)")
            }
            .onChanged { value in
                isTapStart = value
                print("isTapStart : \(isTapStart)")
            }
            .simultaneously(
                with: TapGesture()
                .onEnded {
                    withAnimation {
                        isFail = true
                        print("isFail : \(isFail)")
                    }
                }
            )
    }
}

#Preview {
    LongPressButton()
}

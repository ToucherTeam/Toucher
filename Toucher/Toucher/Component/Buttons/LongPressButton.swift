//
//  LongPressButton.swift
//  Toucher
//
//  Created by hyunjun on 12/11/23.
//

import SwiftUI

struct LongPressButton: View {
    @GestureState private var isTapped = false
    @State private var isTapStart = false
    @State private var animation = [false, false, false]
    private let image = "ToucherButton"
    
    @Binding var isSuccess: Bool
    @Binding var isFail: Bool

    var body: some View {
        Image(isSuccess ? image + "Success" : isTapped ? image + "Pressed" : image)
            .resizable()
            .scaledToFit()
            .frame(width: 176, height: 165)
            .offset(y: isTapped || isSuccess ? 5 : 0)
            .gesture(longPress)
            .frame(maxWidth: .infinity)
            .overlay {
                if isTapStart && !isSuccess {
                    circleAnimation
                }
            }
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
                withAnimation {
                    isTapStart = value
                }
                if value {
                    withAnimation(.easeInOut(duration: 1)) {
                        animation[0] = true
                    }
                    withAnimation(.easeInOut(duration: 1).delay(0.2)) {
                        animation[1] = true
                    }
                    withAnimation(.easeInOut(duration: 1).delay(0.4)) {
                        animation[2] = true
                    }
                }
                print("isTapStart : \(isTapStart)")
            }
            .simultaneously(
                with: TapGesture()
                .onEnded {
                    withAnimation {
                        isFail = true
                        isTapStart = false
                        animation = [false, false, false]
                        print("isFail : \(isFail)")
                        FirestoreManager.shared.updateViewTapNumber(.longPress, .longTapButtonView)
                    }
                }
            )
    }
    
    private var circleAnimation: some View {
        ZStack {
            Ellipse()
                .stroke(isFail ? Color.customBG2 : Color.customSecondary, lineWidth: 10)
                .frame(width: 230, height: 185)
                .opacity(animation[0] ? 1 : 0)
            Ellipse()
                .stroke(isFail ? Color.customBG1 : Color.customBG2, lineWidth: 10)
                .frame(width: 306, height: 245)
                .opacity(animation[1] ? 1 : 0)
            Ellipse()
                .stroke(isFail ? Color.customBG0 : Color.customBG1, lineWidth: 10)
                .frame(width: 380, height: 304)
                .opacity(animation[2] ? 1 : 0)
        }
    }
}

#Preview {
    LongPressButton(isSuccess: .constant(false), isFail: .constant(false))
}

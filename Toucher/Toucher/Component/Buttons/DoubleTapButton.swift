//
//  DoubleTapButton.swift
//  Toucher
//
//  Created by hyunjun on 12/11/23.
//

import SwiftUI

struct DoubleTapButton: View {
    @GestureState private var isTapped = false
    @State private var count = 0
    private let image = "ToucherButton"
    
    @Binding var isSuccess: Bool
    @Binding var isFail: Bool
    
    var body: some View {
        Image(isSuccess ? image + "Success" : isTapped ? image + "Pressed" : image)
            .resizable()
            .scaledToFit()
            .frame(width: 176, height: 165)
            .offset(y: isTapped || isSuccess ? 5 : 0)
            .gesture(doubleTap)
            .frame(maxWidth: .infinity)
    }
    
    private var doubleTap: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isTapped) { currentState, gestureState, _ in
                withAnimation {
                    gestureState = currentState
                }
            }
            .onChanged { _ in
                checkSuccess()
            }
            .exclusively(
                before: TapGesture()
                    .onEnded {
                        FirestoreManager.shared.updateViewTapNumber(.doubleTap, .doubleTapButtonView)
                        AnalyticsManager.shared.logEvent(name: "DoubleTapButtonView_Fail")
                    }
            )
    }
    
    private func checkSuccess() {
        count += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            count -= 1
        }
        if count >= 2 {
            isFail = false
            isSuccess = true
            AnalyticsManager.shared.logEvent(name: "DoubleTapButtonView_Success")
        } else {
            isSuccess = false
            isFail = true
            FirestoreManager.shared.updateViewTapNumber(.doubleTap, .doubleTapButtonView)
            AnalyticsManager.shared.logEvent(name: "DoubleTapButtonView_Fail")
        }
        
        print("isSuccess : \(isSuccess)")
        print("isFail : \(isFail)")
    }
}

#Preview {
    DoubleTapButton(isSuccess: .constant(false), isFail: .constant(false))
}

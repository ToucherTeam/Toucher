//
//  MainButton.swift
//  Toucher
//
//  Created by Hyunjun Kim on 11/28/23.
//

import SwiftUI

enum MainButtonType: String {
    case none = "None"
    case ready = "Primary"
    case done = "Secondary"
}

enum GestureType: String {
    case doubleTap = "DoubleTap"
    case longPress = "LongPress"
    case swipe = "Swipe"
    case drag = "Drag"
    case pan = "Pan"
    case pinch = "Pinch"
    case rotate = "Rotate"
}

struct MainButton: View {
    @GestureState private var isTapped = false
    @State private var bubbleAnimation = false
    var type: MainButtonType
    var gesture: GestureType
    var action: () -> Void
    
    var image: String {
        type.rawValue + gesture.rawValue
    }
    
    var body: some View {
        Image(isTapped ? image + "Pressed" : image)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 95)
            .gesture(type == .none ? nil : longPress)
            .offset(y: isTapped ? 5 : 0)
            .background {
                if type == .ready {
                    ellipseStroke
                }
            }
            .overlay {
                if type == .ready {
                    startBubble
                }
            }
            .onTapGesture {
                AnalyticsManager.shared.logEvent(name: "\(gesture)_ButtonClicked")
            }
    }
    
    private var ellipseStroke: some View {
        Ellipse()
            .stroke(Color.customBG2, lineWidth: 10)
            .frame(width: 120, height: 113)
    }
    
    private var startBubble: some View {
        ZStack {
            Image("StartBubble")
                .resizable()
                .scaledToFit()
                .frame(width: 92)
            Text("시작")
                .font(.customStart)
                .foregroundColor(.customPrimary)
                .offset(y: -8)
        }
        .offset(y: -83)
        .onAppear {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 2).repeatForever()) {
                    bubbleAnimation.toggle()
                }
            }
        }
        .offset(y: bubbleAnimation ? -3 : 3)
    }
    
    private var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isTapped) { currentState, gestureState, _ in
                withAnimation {
                    gestureState = currentState
                }
            }
            .onChanged { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    action()
                    print("action")
                }
            }
    }
}

#Preview {
    VStack {
        MainButton(type: .ready, gesture: .doubleTap) {
            // action here
        }
        .padding(.bottom, 40)
        MainButton(type: .done, gesture: .doubleTap) {
            // action here
        }
    }
}

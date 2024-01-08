//
//  MainViewModel.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var gestureButtons: [GestureButton] = [
        GestureButton(buttonType: .ready, gestureType: .doubleTap),
        GestureButton(buttonType: .none, gestureType: .longPress),
        GestureButton(buttonType: .none, gestureType: .swipe),
        GestureButton(buttonType: .none, gestureType: .drag),
        GestureButton(buttonType: .none, gestureType: .pan),
        GestureButton(buttonType: .none, gestureType: .pinch),
        GestureButton(buttonType: .none, gestureType: .rotate)
    ]
    @Published var headerGesture: GestureType = .doubleTap
    
    func updateHeaderGesture() {
        if let readyGestureButton = gestureButtons.first(where: { $0.buttonType == .ready }) {
            headerGesture = readyGestureButton.gestureType
        } else {
            print("조건을 충족하는 요소를 찾을 수 없습니다.")
        }
    }
}

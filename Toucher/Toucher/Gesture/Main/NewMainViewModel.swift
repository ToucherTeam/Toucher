//
//  NewMainViewModel.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//
//

import SwiftUI

class NewMainViewModel: ObservableObject {
    @Published var gestureButtons: [GestureButton] = [
        GestureButton(buttonType: .ready, gestureType: .doubleTap),
        GestureButton(buttonType: .none, gestureType: .longPress),
        GestureButton(buttonType: .none, gestureType: .swipe),
        GestureButton(buttonType: .none, gestureType: .drag),
        GestureButton(buttonType: .none, gestureType: .pan),
        GestureButton(buttonType: .none, gestureType: .pinch),
        GestureButton(buttonType: .none, gestureType: .rotate)
    ]
}

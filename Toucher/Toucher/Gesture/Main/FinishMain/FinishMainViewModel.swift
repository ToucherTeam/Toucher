//
//  FinishMainViewModel.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

class FinishMainViewModel: ObservableObject {
    @Published var gestureButtons: [GestureButton] = [
        GestureButton(buttonType: .done, gestureType: .doubleTap),
        GestureButton(buttonType: .done, gestureType: .longPress),
        GestureButton(buttonType: .done, gestureType: .drag),
        GestureButton(buttonType: .done, gestureType: .pan),
        GestureButton(buttonType: .done, gestureType: .pinch),
        GestureButton(buttonType: .done, gestureType: .rotate)
    ]
}

//
//  FinishMainViewModel.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

class FinishMainViewModel: ObservableObject {
    @Published var gestures: [GestureType] = [.doubleTap, .longPress, .swipe, .drag, .pan, .pinch, .rotate]
    @Published var selectedGesture: GestureType?
    @Published var isTapped = false
    
    func selectGesture(gesture: GestureType) {
        if let selectedGesture {
            if selectedGesture == gesture {
                self.selectedGesture = nil
            } else {
                self.selectedGesture = gesture
            }
        } else {
            selectedGesture = gesture
        }
    }
}

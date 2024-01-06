//
//  PinchViewModel.swift
//  Toucher
//
//  Created by hyunjun on 1/5/24.
//

import SwiftUI

class PinchViewModel: ObservableObject {
    @Published var isTapped = false
    @Published var isSuccess = false
    @Published var isFail = false
    @Published var isNavigate = false
    
    func reset() {
        isTapped = false
        isSuccess = false
        isFail = false
    }
}

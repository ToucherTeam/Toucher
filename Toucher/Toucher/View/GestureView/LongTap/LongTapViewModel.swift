//
//  LongTapViewModel.swift
//  Toucher
//
//  Created by Hyunjun Kim on 1/4/24.
//

import SwiftUI

class LongTapViewModel: ObservableObject {
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

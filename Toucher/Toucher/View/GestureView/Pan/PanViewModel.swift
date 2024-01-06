//
//  PanViewModel.swift
//  Toucher
//
//  Created by bulmang on 1/5/24.
//

import Foundation

class PanViewModel: ObservableObject {
    @Published var isSuccess = false
    @Published var isNavigate = false
    @Published var isFail = false
    
    func reset() {
        isSuccess = false
        isFail = false
    }
}

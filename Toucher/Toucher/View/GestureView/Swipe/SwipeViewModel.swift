//
//  SwipeViewMoedl.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/04.
//

import SwiftUI

class SwipeViewModel: ObservableObject {
    
    @Published var isFail = false
    @Published var isNavigate = false
    @Published var isSuccess = false
    
    // MARK: Practice1
    @Published var textIndex = 0
    @Published var checkSuccess = false
    
    // MARK: Practice2
    @Published var btnActive = false
    
    func reset() {
        isFail = false
        isNavigate = false
        isSuccess = false
    }
    
    /// SwipeExampleView 성공 조건 감지
    func checkSuccessCondition(_ array: [Int]) {
        let lastIndex = array.count - 1
        if array[lastIndex] == 0 {
            self.isFail = true
        }
        if array.count >= 2 {
            if array[lastIndex] == 0 && array[lastIndex - 1] == 1 {
                self.isSuccess = true
                self.isFail = false
            } else if array[lastIndex] != array[lastIndex - 1] {
                self.isSuccess = false
                self.isFail = false
            } else {
                self.isSuccess = false
                self.isFail = true
            }
        }
    }
}

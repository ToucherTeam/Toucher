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
    @Published var currentIndex = 0
    
    var messageData =  [
        MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "어제"),
        MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "금요일"),
        MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "수요일")
    ]
    
    func reset() {
        isFail = false
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

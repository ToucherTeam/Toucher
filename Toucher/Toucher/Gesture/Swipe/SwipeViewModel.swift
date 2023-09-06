//
//  SwipeViewMoedl.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/04.
//

import SwiftUI

class SwipeViewModel: ObservableObject {
    
    // MARK: ExampleView
    let deviceWidth = UIScreen.main.bounds.width
    let spacing: CGFloat = 12
    let trailingSpacing: CGFloat = 66
    let swipeContent: [CarouselModel] = [
        .init(color: Color("BG2")),
        .init(color: Color("Secondary")),
        .init(color: Color("Primary"))
    ]
    @Published var currentIndexArray: [Int] = []
    @Published var headerAreaHeight: CGRect = .zero
    @Published var currentIndex = -1
    @Published var tap = false
    
    // MARK: Practice1
    @Published var index = 0
    @Published var checkSuccess = false
    
    // MARK: Practice2
    @Published var messageData =  [
        MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "어제"),
        MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "금요일"),
        MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "수요일")
    ]
    @Published var btnActive = false
    
}

final class AppState : ObservableObject {
    @Published var rootViewId = UUID()
}
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
        .init(color: Color.customBG2),
        .init(color: Color.customSecondary),
        .init(color: Color.customPrimary)
    ]
    @Published var currentIndexArray: [Int] = []
    @Published var headerAreaHeight: CGRect = .zero
    @Published var currentIndex = -1
    @Published var tap = false
    
    // MARK: Practice1
    @Published var index = 0
    @Published var checkSuccess = false
    
    // MARK: Practice2
    @Published var btnActive = false
    
}

final class AppState: ObservableObject {
    @Published var rootViewId = UUID()
}

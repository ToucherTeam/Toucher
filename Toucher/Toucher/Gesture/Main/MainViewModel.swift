//
//  MainViewModel.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/05.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var navigationPath = [MainModel]()
    
    let gestures: [MainModel] = [
        .init(name: "두 번 누르기", image: "Primary", iconName: "double tap icon"),
        .init(name: "길게 누르기", image: "Primary", iconName: "long press icon"),
        .init(name: "살짝 쓸기", image: "Primary", iconName: "swipe icon"),
        .init(name: "끌어오기", image: "Primary", iconName: "drag icon"),
        .init(name: "화면 움직이기", image: "Primary", iconName: "pan icon"),
        .init(name: "확대 축소하기", image: "Primary", iconName: "pinch icon"),
        .init(name: "회전하기", image: "Primary", iconName: "rotate icon")
    ]

}

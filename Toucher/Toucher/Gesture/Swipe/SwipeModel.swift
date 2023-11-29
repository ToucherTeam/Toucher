//
//  SwipeModel.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/06.
//

import SwiftUI

struct CarouselModel: Identifiable {
    let id = UUID()
    let color: Color
}

struct MessageModel: Identifiable, Equatable, Hashable {
    var id = UUID()
    var imageName: String
    var phNumber: String
    var text: String
    var time: String
}

var messageData =  [
    MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "어제"),
    MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "금요일"),
    MessageModel(imageName: "person.circle.fill", phNumber: "+82 10-0000-0000", text: "메세지 내용", time: "수요일")
]

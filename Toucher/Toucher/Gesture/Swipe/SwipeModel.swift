//
//  SwipeModel.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/06.
//

import Foundation
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

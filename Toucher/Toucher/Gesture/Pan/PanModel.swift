//
//  Pan.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/08.
//

import SwiftUI

struct NotificationModel: Identifiable {
    let id = UUID()
    let imageName: String
    let time: String
    let title: String
    let subTitle: String
}

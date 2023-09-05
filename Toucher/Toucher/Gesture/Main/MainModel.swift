//
//  MainViewModel.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/01.
//

import Foundation

struct MainModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var image: String
    let iconName: String
}

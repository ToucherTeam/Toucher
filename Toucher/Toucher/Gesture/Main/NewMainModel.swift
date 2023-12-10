//
//  NewMainModel.swift
//  Toucher
//
//  Created by hyunjun on 12/10/23.
//

import SwiftUI

struct GestureButton: Identifiable {
    var id = UUID()
    var buttonType: MainButtonType
    var gestureType: GestureType
}

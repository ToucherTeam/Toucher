//
//  BackGroundColor.swift
//  Toucher
//
//  Created by bulmang on 2/13/24.
//

import SwiftUI

struct BackGroundColor: View {
    let isFail: Bool
    let isSuccess: Bool
    
    var body: some View {
        if isFail && !isSuccess {
            Color.customSecondary
                .ignoresSafeArea()
        } else {
            Color.white
                .ignoresSafeArea()
        }
    }
}

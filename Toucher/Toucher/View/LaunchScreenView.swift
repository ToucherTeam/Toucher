//
//  LaunchScreenView.swift
//  Toucher
//
//  Created by bulmang on 12/19/23.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.customWhite
                .ignoresSafeArea()
            Image("ToucherLogo")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 100)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LaunchScreenView()
}

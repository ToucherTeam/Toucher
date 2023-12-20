//
//  TapButton.swift
//  Toucher
//
//  Created by bulmang on 12/20/23.
//

import SwiftUI

struct TapButton: View {
    @Binding var isSuccess: Bool
    private let image = "ToucherButton"
    
    var body: some View {
        Image(isSuccess ? image + "Success" : image)
            .resizable()
            .scaledToFit()
            .frame(width: 176, height: 165)
            .offset(y: isSuccess ? 5 : 0)
            .onTapGesture {
                isSuccess = true
            }
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    TapButton(isSuccess: .constant(false))
}

//
//  HelpButton.swift
//  Toucher
//
//  Created by Hyunjun Kim on 11/28/23.
//

import SwiftUI

enum HelpButtonStyle {
    case primary
    case secondary
}

struct HelpButton: View {
    var style: HelpButtonStyle
    var action: () -> Void
    
    var textColor: Color {
        switch style {
        case .primary:
            return .customPrimary
        case .secondary:
            return .customSecondary
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text("도움이 필요하신가요?")
                .font(.customButton)
                .foregroundStyle(textColor)
        }
    }
}

#Preview {
    HelpButton(style: .primary) {
        // action here
    }
}

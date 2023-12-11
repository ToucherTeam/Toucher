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
    
    private var textColor: Color {
        withAnimation {
            switch style {
            case .primary:
                return .customBG1
            case .secondary:
                return .customSecondary
            }
        }
    }
    
    private var backgroundColor: Color {
        withAnimation {
            switch style {
            case .primary:
                return .customPrimary
            case .secondary:
                return .customBG2
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text("도움이 필요하신가요?")
                .font(.customButton)
                .foregroundStyle(textColor)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(backgroundColor)
                }
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    VStack {
        HelpButton(style: .primary) {
            // action here
        }
        HelpButton(style: .secondary) {
            // action here
        }
    }
}

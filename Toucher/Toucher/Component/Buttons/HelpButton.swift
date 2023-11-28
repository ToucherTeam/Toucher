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
    @State private var animation = false
    var style: HelpButtonStyle
    var action: () -> Void
    
    var textColor: Color {
        switch style {
        case .primary:
            return .customBG1
        case .secondary:
            return .customSecondary
        }
    }
    
    var backgroundColor: Color {
        switch style {
        case .primary:
            return .customPrimary
        case .secondary:
            return .customBG2
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text("도움이 필요하신가요?")
                .font(.customButton)
                .foregroundStyle(textColor)
                .padding(.vertical, 21)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(backgroundColor)
                }
                .padding(.horizontal, 16)
                .offset(y: animation ? 0 : 10)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever()) {
                        animation = true
                    }
                }
        }
    }
}

#Preview {
    HelpButton(style: .primary) {
        // action here
    }
}

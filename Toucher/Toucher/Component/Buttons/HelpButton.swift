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
    @State private var animate = false
    @State private var isFullScreenPresented = false
    
    var style: HelpButtonStyle
    var currentViewName: String = "LongTapExampleView"
    
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
        Button {
            isFullScreenPresented.toggle()
        } label: {
            Text("도움이 필요하신가요?")
                .font(.customButton)
                .foregroundStyle(textColor)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(backgroundColor)
                }
                .frame(width: UIScreen.main.bounds.width - 32)
                .padding(.horizontal, 16)
                .offset(y: animate ? -8 : 0)
                .onChange(of: style) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 2).repeatForever()) {
                            animate = true
                        }
                    }
                }
        }
        .fullScreenCover(isPresented: $isFullScreenPresented, content: {
            GuideView(isFullScreenPresented: $isFullScreenPresented, currentViewName: currentViewName)
        })
    }
}

struct HelpButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HelpButton(style: .primary)
            HelpButton(style: .secondary)
        }
    }
}


struct CustomProgressViewStyle: ProgressViewStyle {
    let height: CGFloat = 10
    var foregroundColor: Color = .customSecondary
    var backgroundColor: Color = .customWhite
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 306, height: height)
                    .clipShape(.capsule)
                    .foregroundColor(backgroundColor)
                
                Rectangle()
                    .frame(width: geometry.size.width - 90, height: height)
                    .clipShape(.capsule)
                    .foregroundColor(foregroundColor)
            }
        }
    }
}

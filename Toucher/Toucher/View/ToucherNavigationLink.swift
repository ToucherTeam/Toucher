//
//  ToucherNavigationLink.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct ToucherNavigationLink<Content: View>: View {
    
    let label: String
    let content: Content
    
    init(label: String = "다음", @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        VStack {
            VStackArrow()
            NavigationLink {
                content
            } label: {
                Text(label)
                    .font(.customButton)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(height: 64)
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    }
            }
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom)
    }
}

struct ToucherNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ToucherNavigationLink {
                // View Here
            }
        }
    }
}

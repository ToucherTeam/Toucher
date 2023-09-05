//
//  ToucherNavigationLink.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct ToucherNavigationLink<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationLink {
            content
        } label: {
            Text("다음")
                .font(.customButtonText())
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(height: 64)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
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

//
//  ViewExtension.swift
//  Toucher
//
//  Created by hyunjun on 2023/08/31.
//

import Foundation
import SwiftUI

struct BtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .font(.headline)
            .foregroundColor(.white)
            .background(Color("Primary"))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

struct BtnWhiteStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth:.infinity)
            .frame(height: 58)
            .font(.headline)
            .padding(.horizontal, 16)
            .foregroundColor(Color("Primary"))
            .background(.white)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke((Color("Primary")), lineWidth: 0.5))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

extension View {
    func btnStyle() -> some View {
        self.buttonStyle(BtnStyle())
    }
    
    func btnWhiteStyle() -> some View {
        self.buttonStyle(BtnWhiteStyle())
    }
    
}

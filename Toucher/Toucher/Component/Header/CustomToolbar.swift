//
//  File.swift
//  Toucher
//
//  Created by bulmang on 12/10/23.
//

import SwiftUI

struct CustomToolbar: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    
    var body: some View {
        
            HStack {
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.customGR1)
                    .frame(maxWidth: .infinity)
            }
            .overlay(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(.customPrimary)
                        
                        Text("이전으로")
                            .font(.system(size: 17))
                            .fontWeight(.regular)
                            .foregroundColor(.customPrimary)
                    }
                }
                .padding(.leading, 8)
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.customGR3)
            }
        }
}

#Preview {
    CustomToolbar(title: "두번 누르기")
}

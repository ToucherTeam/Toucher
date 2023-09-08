//
//  SwipeFinalView.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/06.
//

import SwiftUI

struct SwipeFinalView: View {
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        FinalView(gestureTitle: "살짝 쓸기")
            .padding(.bottom, 13)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color("GR3")),
                    alignment: .top
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    CustomToolbar(title: "살짝 쓸기")
                }
            }
            .frame(maxHeight: .infinity)
        
    }
}

struct SwipeFinalView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeFinalView()
    }
}

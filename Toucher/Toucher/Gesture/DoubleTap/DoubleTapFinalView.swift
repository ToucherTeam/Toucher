//
//  DoubleTapFinalView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapFinalView: View {
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        FinalView(gestureTitle: "두 번 누르기")
            .padding(.bottom, 13)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color("GR3")),
                    alignment: .top
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    CustomToolbar()
                }
            }

    }
}

struct DoubleTapFinalView_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTapFinalView()
    }
}

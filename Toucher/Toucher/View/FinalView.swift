//
//  FinalView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct FinalView: View {
//    @Environment(\.presentationMode) var presentationMode
    /// gestureTitle 을 넣으면 Toolbar 와 말풍선에 적용됩니다
    /// navigation 기능을 위한 mainVM 을 받아와야 합니다
    let gestureTitle: String
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        VStack {
            CustomToolbar(title: "\(gestureTitle)")
            
            Text("\(gestureTitle) 학습을\n완료했습니다!")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.top, 30)
                .background(alignment: .top) {
                    Image("Tip")
                        .resizable()
                        .frame(width: 312, height: 158)
                }
                .padding(.top, UIScreen.main.bounds.height * 0.07)

            Image("ch_default")
                .resizable()
                .scaledToFit()
                .frame(width: 168)
                .frame(maxHeight: .infinity)
                        
            Button {
//                if !path.isEmpty {
//                    path.removeLast(path.count - 1)
//                }
                appState.rootViewId = UUID()
            } label: {
                Text("다시하기")
                    .font(.customButton)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                    .frame(height: 64)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(lineWidth: 2)
                    }
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 16)
            Button {
                mainVM.isFinishActive = true
                mainVM.navigationPath = []
            } label: {
                Text("처음으로")
                    .font(.customButton)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(height: 64)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                    }
                    .padding(.horizontal, 16)
            }

        }
    }
}

struct FinalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FinalView(gestureTitle: "길게 누르기")
        }
    }
}

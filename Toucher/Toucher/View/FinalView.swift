//
//  FinalView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct FinalView: View {
    
    /// gestureTitle 을 넣으면 Toolbar 와 말풍선에 적용됩니다
    /// navigation 기능을 위한 mainVM 을 받아와야 합니다
    let gestureTitle: String
    @ObservedObject var mainVM: MainViewModel
    
    var body: some View {
        
        var path = mainVM.navigationPath
        
        VStack {
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

            Image("ch_default")
                .resizable()
                .scaledToFit()
                .frame(width: 168)
                .frame(maxHeight: .infinity)
                        
            Button {
                if !path.isEmpty {
                    path.removeLast(path.count - 1)
                }
            } label: {
                Text("다시하기")
                    .font(.customButtonText())
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
            Button {
                path.removeAll()
            } label: {
                Text("처음으로")
                    .font(.customButtonText())
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(gestureTitle)
                    .font(.customButtonText())
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(height: 64)
                    .frame(maxWidth: UIScreen.main.bounds.width)
            }
        }
    }
}

struct FinalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FinalView(gestureTitle: "길게 누르기", mainVM: MainViewModel())
        }
    }
}

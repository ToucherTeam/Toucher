//
//  FinalView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct FinalView: View {
    
    let text: String
    
    var body: some View {
        VStack {
            Text("\(text) 학습을\n완료했습니다!")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .foregroundColor(Color("BG1"))
                        .shadow(radius: 2)
                }
                .padding(.top, 30)

            Image("ch_default")
                .resizable()
                .scaledToFit()
                .frame(width: 168)
                .frame(maxHeight: .infinity)
                        
            Button {
                
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
                Text(text)
            }
        }
    }
}

struct FinalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FinalView(text: "길게 누르기")
        }
    }
}

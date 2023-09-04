//
//  LongTapFinalView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapFinalView: View {
    var body: some View {
        VStack {
            Text("길게 누르기 학습을\n완료했습니다!")
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
            
            NavigationLink {
                
            } label: {
                Text("다시하기")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke()
                    }
            }
            NavigationLink {
                ContentView()
            } label: {
                Text("처음으로")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("길게 누르기")
            }
        }
        .padding(.horizontal)
    }
}

struct LongTapFinalView_Previews: PreviewProvider {
    static var previews: some View {
        LongTapFinalView()
    }
}

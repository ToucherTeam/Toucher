//
//  DoubleTapFinalView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/01.
//

import SwiftUI

struct DoubleTapFinalView: View {
    
    var body: some View {
        VStack {
            Text("두 번 누르기 학습을\n완료했습니다!")
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
                .foregroundStyle(.gray)
                .frame(maxHeight: .infinity)
            Button {
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
            Button {
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
        .padding(.horizontal)
    }
}

struct DoubleTapFinalView_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTapFinalView()
    }
}

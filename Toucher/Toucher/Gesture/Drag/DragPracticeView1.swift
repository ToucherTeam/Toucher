//
//  DragPracticeView1.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct DragPracticeView1: View {
    @State private var isSuccess = false
    @State private var isTapped = false
    @State var value = 0.0
    
    var body: some View {
        ZStack {
            if isTapped && !isSuccess {
                Color("Secondary_alert").ignoresSafeArea()
            }
            VStack {
                Text(isSuccess ? "잘하셨어요!\n" : isTapped ? "꾹 누른 상태로 옮겨주세요.\n" : "원을 좌우로 움직여주세요.\n")
                    .foregroundColor(isTapped && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                ZStack(alignment: .leading) {
                    Slider(value: $value)
                        .onTapGesture {
                            if !isSuccess {
                                isTapped = true
                            }
                        }
                    Group {
                        Capsule()
                            .foregroundColor(Color(.systemGray5))
                            .frame(height: 30)
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width * value * 0.82 + 40, height: 30)
                            .foregroundColor(.accentColor)
                            .cornerRadius(20)
                        Circle()
                            .foregroundColor(.white)
                            .frame(height: 40)
                            .shadow(radius: 5)
                            .offset(x: UIScreen.main.bounds.width * value * 0.82)
                    }
                    .allowsHitTesting(false)
                    .onChange(of: value) { newValue in
                        if newValue >= 0.1 {
                            isSuccess = true
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 120)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if isSuccess {
                ToucherNavigationLink {
                    DragPracticeView2()
                }
            }
            
        }
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color("GR3")),
                alignment: .top
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                CustomToolbar(  title: "끌어오기")
            }
        }
        .onAppear {
            isSuccess = false
            value = 0
        }
    }
}

struct DragPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        DragPracticeView1()
    }
}

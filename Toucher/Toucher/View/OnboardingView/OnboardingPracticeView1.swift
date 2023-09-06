//
//  OnboardingPracticeView1.swift
//  Toucher
//
//  Created by Yubin on 2023/09/05.
//

import SwiftUI

struct OnboardingPracticeView1: View {
    
    @State private var isActiveNextView = false

    var body: some View {
        VStack(spacing: 62){
            ZStack{
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(Color("BG1"))
                    .frame(height: 99)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal,16)
                    .shadow(radius: 4,x:0,y:0)
                
                Text("잘하셨어요!")
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(Color("Black"))
            }
            Image("ch_button_pressed")
                .resizable()
                .frame(width: 184, height: 184)
                .shadow(radius: 4,x:0,y:0)
            
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
                    // 3초 후에 isActiveNextView를 true로 설정하여 화면 전환
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isActiveNextView = true
                    }
                }
        NavigationLink(
                    destination: OnboardingPracticeView2(),
                    isActive: $isActiveNextView,
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
        

    }
}

struct OnboardingPracticeView1_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPracticeView1()
    }
}

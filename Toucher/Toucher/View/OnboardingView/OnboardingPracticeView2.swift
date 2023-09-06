//
//  OnboardingPracticeView2.swift
//  Toucher
//
//  Created by Yubin on 2023/09/05.
//

import SwiftUI

struct OnboardingPracticeView2: View {
    var body: some View {
        VStack(spacing: 62){
            
            Spacer()
            
            ZStack{
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(Color("BG1"))
                    .frame(height: 201)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal,16)
                    .shadow(radius: 4,x:0,y:0)
                
                Text("아래의 다음 버튼을\n눌러 터치를\n배워보러 갈까요?")
                    .font(.system(size: 34))
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Black"))
            }
            Image("ch_button_pressed")
                .resizable()
                .frame(width: 184, height: 184)
            
            Spacer()
            
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(Color("Primary"))
                    .frame(height: 64)
                    .overlay(){
                        Text("다음")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal,16)
        
                    .navigationBarBackButtonHidden(true)
            
        }
    }
}

struct OnboardingPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPracticeView2()
    }
}

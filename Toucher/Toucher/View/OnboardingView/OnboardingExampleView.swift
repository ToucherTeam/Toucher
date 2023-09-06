//
//  OnboardingExampleView.swift
//  Toucher
//
//  Created by Yubin on 2023/09/05.
//

import SwiftUI

struct OnboardingExampleView: View {
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 62){
                ZStack{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundColor(Color("BG1"))
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal,16)
                        .shadow(radius: 4,x:0,y:0)
                    
                    Text("저를 한 번\n눌러보세요!")
                        .font(.system(size: 34))
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Black"))
                }
                
                NavigationLink(destination: OnboardingPracticeView1()) {
                    Image("ch_button")
                        .resizable()
                        .frame(width: 184, height: 184)
                        .shadow(radius: 4,x:0,y:0)
                        
                }
                
            }
            
        }

    }
}

struct OnboardingExampleView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingExampleView()
    }
}

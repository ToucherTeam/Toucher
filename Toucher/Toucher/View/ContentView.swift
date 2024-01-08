//
//  ContentView.swift
//  Toucher
//
//  Created by hyunjun on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("finish") private var finish = true
    @AppStorage("first") private var isFirst = true
    
    @State private var isSplashActive = true
    @State private var isSuccess = false
    
    var body: some View {
        Group {
            if isSplashActive {
                LaunchScreenView()
            } else if isFirst {
                OnboardingView()
                    .transition(.move(edge: .leading))
            } else {
                NavigationStack {
                    if finish {
                        FinishMainView()
                    } else {
                        MainView()
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.isSplashActive = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

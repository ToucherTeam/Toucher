//
//  ContentView.swift
//  Toucher
//
//  Created by hyunjun on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("finish") private var finish = false
    @AppStorage("first") private var isFirst = true
    
    @State private var isSplashActive = true
    @State private var isSuccess = false
    
    var body: some View {
        Group {
            if isSplashActive {
                SplashView()
            } else if isFirst {
                OnBoardingView()
                    .transition(.move(edge: .leading))
            } else {
                NavigationStack {
                    if finish {
                        FinishMainView()
                    } else {
                        NewMainView()
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

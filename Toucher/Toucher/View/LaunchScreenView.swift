//
//  LaunchScreenView.swift
//  Toucher
//
//  Created by bulmang on 12/19/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.customWhite
                .ignoresSafeArea()
            Image("ToucherLogo")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 100)
        }
        .onAppear {
            signAnonymously()
        }
        .ignoresSafeArea()
    }
    
    private func signAnonymously() {
        guard let user = Auth.auth().currentUser else {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("error \(error.localizedDescription)")
                    return
                }
                guard let user = authResult?.user else { return }
                print("sign in \(user.uid)")
            }
            return
        }
        
        print("log in \(user.uid)")
    }
}

#Preview {
    LaunchScreenView()
}

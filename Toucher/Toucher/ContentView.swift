//
//  ContentView.swift
//  Toucher
//
//  Created by hyunjun on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("finish") private var finish = false
    
    var body: some View {
        NavigationStack {
            if finish {
                FinishMainView()
            } else {
                NewMainView()
            }
        }
    }
}

#Preview {
    ContentView()
}

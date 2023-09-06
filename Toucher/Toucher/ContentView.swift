//
//  ContentView.swift
//  Toucher
//
//  Created by hyunjun on 2023/08/31.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mainVM = MainViewModel()
    @StateObject var appState = AppState()
    
    var body: some View {
        MainView()
            .id(appState.rootViewId)
            .environmentObject(appState)
            .environmentObject(mainVM)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

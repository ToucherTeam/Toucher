//
//  MainView.swift
//  MC2
//
//  Created by 하명관 on 2023/05/07.
//

import SwiftUI

struct MainView: View {
    @State private var navigationPath = [MainViewModel]()
    @State private var showFullStack = false
    
    private let isSE = DeviceManager.shared.iPhoneSE()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(gestures) { gesture in
                        NavigationLink(value: gesture) {
                            LinearGradient(
                                colors: [Color("Primary"), Color("Secondary")],
                                startPoint: UnitPoint(x: 0.09, y: 0.5),
                                endPoint: UnitPoint(x: 1.65, y: 0.5)
                            )
                            .frame(height: isSE ? 77 : 88)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .overlay(
                                HStack {
                                    Image(gesture.iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                    
                                    Text(gesture.name)
                                        .font(.customButtonText())
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 36)
                                    
                                    Image(systemName: "chevron.forward")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                        
                                }
                                    .padding(.horizontal, 18)
                            )
                            .padding(.horizontal, 16)
                            .padding(.bottom, 6)
                        }
                    }
                    .navigationDestination(for: MainViewModel.self) { gesture in
                        VStack(spacing: 0) {
                            customHeader(for: gesture)
                            
                            viewForgesture(gesture)
                        }
                    }
                }
            }
        }
        .accentColor(.red)
        .onAppear {
            UserDefaults.standard.set(true, forKey: "goToMain")
        }
    }
    
    func viewForgesture(_ gesture: MainViewModel) -> AnyView {
        switch gesture.name {
        case "두 번 누르기":
            return AnyView(Color.gray.navigationBarBackButtonHidden())
        case "길게 누르기":
            return AnyView(Color.gray.navigationBarBackButtonHidden())
        case "살짝 쓸기":
            return AnyView(Color.gray.navigationBarBackButtonHidden())
        case "끌어오기":
            return AnyView(Color.gray.navigationBarBackButtonHidden())
        case "화면 움직이기":
            return AnyView(Color.gray.navigationBarBackButtonHidden())
        case "확대 축소하기":
            return AnyView(Color.gray.navigationBarBackButtonHidden())
        case "회전하기":
            return AnyView(Color.gray.navigationBarBackButtonHidden())
        default:
            return AnyView(Color.gray)
        }
    }
    
    @ViewBuilder
    func customHeader(for gesture: MainViewModel) -> some View {
        Button {
            navigationPath = []
        } label: {
            HStack(spacing: 5) {
                
                Image(systemName: "chevron.backward")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Primary"))
                
                Text("이전으로")
                    .font(.system(size: 16))
                    .foregroundColor(Color("Primary"))
                
                Spacer()
                
                Text("\(gesture.name)")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("GR1"))
                
                Spacer()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.vertical, 11)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color("GR3")),
                alignment: .bottom
            )
            .background(Color.clear)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
                .previewDisplayName("iPhone SE")
            
            MainView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
                .previewDisplayName("iPhone 14")
        }
    }
}

//
//  MainView.swift
//  MC2
//
//  Created by 하명관 on 2023/05/07.
//

import SwiftUI

struct TouchGesture: Identifiable,Hashable{
    let id = UUID()
    let name: String
    var image: String
    let subName: String
}

struct MainView: View {
    
    let brands: [TouchGesture] = [
        .init(name: "두 번 누르기", image: "Primary", subName: "Double Tap"),
        .init(name: "길게 누르기", image: "Primary", subName: "Long Tap"),
        .init(name: "살짝 쓸기", image: "Primary", subName: "Swipe"),
        .init(name: "끌어오기", image: "Primary", subName: "Drag"),
        .init(name: "화면 움직이기", image: "Primary", subName: "Pan"),
        .init(name: "확대 축소하기", image: "Primary", subName: "Zoom in, out"),
        .init(name: "회전하기", image: "Primary", subName: "Rotate"),
    ]
    
    @State private var navigationPath = [TouchGesture]()
    
    @State private var showFullStack = false
    
    
    
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack(alignment: .leading,spacing: 0) {
                    ScrollView(showsIndicators: false){
                        ForEach(brands) { brand in
                            NavigationLink(value: brand) {
                                Rectangle()
                                    .foregroundColor(Color("\(brand.image)"))
                                    .frame(height: 115)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(10)
                                    .padding(.horizontal,16)
                                    .shadow(radius: 4,x:0,y:0)
                                    .overlay(
                                        
                                        HStack {
                                            VStack() {
                                                
                                                Text(brand.name)
                                                    .font(.customTitle())
                                                    .foregroundColor(.white)
                                                    .frame(width: 280,alignment: .leading)
                                                
                                                Text(brand.subName)
                                                    .foregroundColor(.white)
                                                    .frame(width: 280,alignment: .leading)
                                                    
                                            }
                                            .padding(.leading,36)
                                            Image(systemName: "chevron.forward")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 11, height: 18)
                                                .foregroundColor(Color.white)
                                                .fontWeight(.bold)
                                                .padding(.trailing,50)
                                        }
                                        
                                    )
                                    .padding(.bottom,12)

                            }
                        }
                    }
                    .navigationDestination(for: TouchGesture.self) { brand in
                        VStack(spacing:0){
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
    
                                    Text("\(brand.name)")
                                        .font(.system(size: 17))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("GR1"))
    
                                    Spacer()
    
                                    Spacer()
                                }
                                
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .padding(.horizontal,8)
                                .padding(.vertical,11)
                                .overlay(
                                                Rectangle()
                                                    .frame(height: 0.5)
                                                    .foregroundColor(Color("GR3")),
                                                alignment: .bottom
                                        )
                                .background(Color.clear)
                                
    
                            }
                            viewForBrand(brand)
                        }
                    }
                }
            }
        }.accentColor(.red)
            .onAppear{
                 UserDefaults.standard.set(true, forKey: "goToMain")
             }
        
        
    }
    func viewForBrand(_ brand: TouchGesture) -> AnyView {
        switch brand.name {
        case "길게 누르기":
            return AnyView(Color.gray)
        case "두 번 누르기":
            return AnyView(Color.gray)
        case "화면 움직이기":
            return AnyView(Color.gray)
        case "끌어오기":
            return AnyView(Color.gray)
        case "살짝 쓸기":
            return AnyView(Color.gray)
        case "확대 축소하기":
            return AnyView(Color.gray)
        case "회전하기":
            return AnyView(Color.gray)
        default:
            return AnyView(Color.gray)
        }
    }
    
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

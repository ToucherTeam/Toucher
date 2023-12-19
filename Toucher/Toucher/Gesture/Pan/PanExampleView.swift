//
//  PanExampleView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/06.
//

import SwiftUI

struct PanExampleView: View {
    @State private var wholeSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    @State private var isTapped = false
    @State private var isSuccess = false
    @State private var navigate = false
    @State private var isFail = false
    @State private var isOneTapped = false
    @State private var scrollOffset: CGFloat = 0
    
    @GestureState private var isPressed = false
    @Namespace var top
    
    private let isSE = DeviceManager.shared.iPhoneSE()
    private let spaceName = "scroll"
    private let notifications: [NotificationModel] = [
        .init(imageName: "Warning", time: "9:41 AM", title: "긴급재난문자", subTitle: "[중앙재난안전대책본부] 안녕하세요." ),
        .init(imageName: "PersonMessage", time: "8:36 AM", title: "1588", subTitle: "(광고) 안녕하세요."),
        .init(imageName: "PersonMessage", time: "8:23 AM", title: "114", subTitle: "[Web발신] 안녕하세요"),
        .init(imageName: "Warning", time: "7:58 AM", title: "긴급재난문자", subTitle: "[중앙재난안전대책본부] 안녕하세요." ),
        .init(imageName: "PersonMessage", time: "7:34 AM", title: "+82 10-0000-0000", subTitle: "안녕하세요. 메세지 내용입니다."),
        .init(imageName: "PersonMessage", time: "7:17 AM", title: "1588", subTitle: "(광고) 안녕하세요."),
        .init(imageName: "Warning", time: "6:55 AM", title: "긴급재난문자", subTitle: "[중앙재난안전대책본부] 안녕하세요." ),
        .init(imageName: "NotiToucher", time: "6:38 AM", title: "Toucher", subTitle: "터치에 세계에 오신 걸 환영합니다!" )
    ]
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary
                    .ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "화면 움직이기")
                
                Text(isFail ? "위로 가볍게 쓸어올리세요." : isSuccess ? "성공!\n" : "밑에서 위로\n쓸어 올려보세요.")
                    .foregroundColor(isFail && !isSuccess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                
                ChildSizeReader(size: $wholeSize) {
                    ScrollViewReader { value in
                        ScrollView {
                            ChildSizeReader(size: $scrollViewSize) {
                                VStack {
                                    ForEach(notifications) { item in
                                        HStack {
                                            Image(item.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                                .padding(.leading)
                                            
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(item.title)
                                                        .bold()
                                                    Spacer()
                                                    Text(item.time)
                                                        .foregroundColor(.customGR1)
                                                        .font(.system(size: 13))
                                                        .fontWeight(.regular)
                                                        .padding(.trailing, 22)
                                                }
                                                Text(item.subTitle)
                                                    .font(.system(size: 15))
                                                    .fontWeight(.regular)
                                            }
                                            Spacer()
                                        }
                                        .frame(height: 66)
                                        .frame(maxWidth: .infinity)
                                        .background {
                                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                                .foregroundColor(Color(.systemGray5))
                                        }
                                        .padding(.horizontal, 14)
                                    }
                                }
                                .id(top)
                                .onAppear {
                                    value.scrollTo(top, anchor: .top)
                                }
                                .background(
                                    GeometryReader { proxy in
                                        Color.clear.preference(
                                            key: ViewOffsetKey.self,
                                            value: -1 * proxy.frame(in: .named(spaceName)).origin.y
                                        )
                                    }
                                )
                                .onPreferenceChange(
                                    ViewOffsetKey.self,
                                    perform: { value in
                                        if value != 0 {
                                            isTapped = true
                                        }
                                        print("offset: \(value)")
                                        print("height: \(scrollViewSize.height)")
                                        
                                        if value >= scrollViewSize.height - wholeSize.height {
                                            print("User has reached the bottom of the ScrollView.")
                                            isSuccess = true
                                        } else {
                                            print("not reached.")
                                        }
                                    }
                                )
                            }
                        }
                        .frame(height: 290)
                    }
                    .coordinateSpace(name: spaceName)
                }
                .onTapGesture(perform: {
                    withAnimation {
                        isFail = true
                    }
                })
                .onChange(
                    of: scrollViewSize,
                    perform: { value in
                        print(value)
                    }
                )
                .padding(.top, 96)
                .frame(maxHeight: isSE ? .infinity : 320)
                
                Spacer()
                
                HelpButton(style: .secondary) {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
            }
            .overlay {
                if isFail || !isSuccess {
                    Arrows()
                        .rotationEffect(Angle(degrees: 90))
                        .allowsHitTesting(false)
                }
            }
            
        }
        .onAppear {
            isTapped = false
            isSuccess = false
            isOneTapped = false
        }
        .overlay {
            if isSuccess {
                ConfettiView()
            }
        }
        .onChange(of: isSuccess) { _ in
            if isSuccess {
                HapticManager.notification(type: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    navigate = true
                }
            }
        }
        .navigationDestination(isPresented: $navigate) {
            PanPracticeView()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct PanExampleView_Previews: PreviewProvider {
    static var previews: some View {
        PanExampleView()
    }
}

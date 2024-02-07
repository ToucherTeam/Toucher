//
//  PanNotificationView.swift
//  Toucher
//
//  Created by hyunjun on 2023/11/06.
//

import SwiftUI

struct PanNotificationView: View {
    @AppStorage("createPan") var createPan = true
    @StateObject private var panVM = PanViewModel()
    
    @State private var wholeSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    @State private var scrollOffset: CGFloat = 0
    
    @Namespace var top
    
    private let selectedGuideVideo: URLManager = .panNotificationView
    private let isSE = DeviceManager.shared.iPhoneSE()
    private let spaceName = "scroll"
    private let scrollSize: CGFloat = 290
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
            if panVM.isFail && !panVM.isSuccess {
                Color.customSecondary
                    .ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "화면 움직이기", isSuccess: panVM.isSuccess)
                
                ZStack {
                    VStack {
                        Text(panVM.isFail ? "위로 가볍게 쓸어올리세요.\n" : panVM.isSuccess ? "성공!\n" : "밑에서 위로\n쓸어 올려보세요.")
                            .foregroundColor(panVM.isFail && !panVM.isSuccess ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .font(.largeTitle)
                            .bold()
                            .padding(.top, 30)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        HelpButton(selectedGuideVideo: selectedGuideVideo, style: panVM.isFail ? .primary : .secondary)
                            .opacity(panVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: panVM.isSuccess)
                    }
                    
                    PanChildSizeReader(size: $wholeSize) {
                        ScrollViewReader { value in
                            ScrollView {
                                PanChildSizeReader(size: $scrollViewSize) {
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
                                            if value >= scrollViewSize.height - wholeSize.height {
                                                panVM.isSuccess = true
                                            } else if value < 0 {
                                                panVM.isFail = true
                                            } else {
                                                panVM.isFail = false
                                            }
                                        }
                                    )
                                }
                            }
                            .frame(height: scrollSize)
                        }
                        .coordinateSpace(name: spaceName)
                    }
                    .onTapGesture {
                        withAnimation {
                            panVM.isFail = true
                        }
                    }
                    .onChange(
                        of: scrollViewSize,
                        perform: { value in
                            print(value)
                        }
                    )
                    .overlay {
                        if panVM.isFail || !panVM.isSuccess {
                            Arrows()
                                .rotationEffect(Angle(degrees: 90))
                                .allowsHitTesting(false)
                        }
                    }
                }
            }
        }
        .modifier(
            FirebaseStartViewModifier(
                create: $createPan,
                isSuccess: panVM.isSuccess,
                viewName: .panNotificationView
            )
        )
        .onAppear {
            panVM.reset()
        }
        .overlay {
            if panVM.isSuccess {
                ConfettiView()
            }
        }
        .modifier(MoveToNextModifier(isNavigate: $panVM.isNavigate, isSuccess: $panVM.isSuccess))
        .navigationDestination(isPresented: $panVM.isNavigate) {
            PanMapView()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    PanNotificationView()
        .environment(\.locale, .init(identifier: "ko"))
}

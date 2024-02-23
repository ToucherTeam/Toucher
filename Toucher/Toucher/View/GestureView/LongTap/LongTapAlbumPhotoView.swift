//
//  LongTapAlbumPhotoView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapAlbumPhotoView: View {
    @StateObject private var longTapVM = LongTapViewModel()
    
    @State private var selectIndex: Int?
    @State private var selectedIndex: Int?
    @State private var scale = 1.0
    
    @GestureState private var isPressed = false
    @Namespace private var name
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    private let firestoreManager = FirestoreManager.shared
    private let selectedGuideVideo: URLManager = .longTapAlbumPhotoView
    
    var body: some View {
        ZStack {
            if longTapVM.isFail && !longTapVM.isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack(spacing: 0) {
                CustomToolbar(title: "길게 누르기", isSuccess: longTapVM.isSuccess, selectedGuideVideo: selectedGuideVideo)
                
                ScrollView {
                    Text(longTapVM.isSuccess ? "성공!\n" : longTapVM.isFail ? "조금 더 길게 꾹 \n눌러주세요!" : "앨범의 사진을 꾹 눌러서\n미리 보아 볼까요?")
                        .foregroundColor(longTapVM.isFail && !longTapVM.isSuccess ? .white : .primary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .font(.customTitle)
                        .minimumScaleFactor(0.5)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 40)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns) {
                        ForEach((1...15), id: \.self) { index in
                            if longTapVM.isSuccess {
                                Rectangle()
                                    .aspectRatio(1, contentMode: .fill)
                                    .overlay {
                                        Image("Album\(index)")
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .clipShape(Rectangle())
                            } else {
                                Rectangle()
                                    .aspectRatio(1, contentMode: .fill)
                                    .overlay {
                                        Image("Album\(index)")
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .clipShape(Rectangle())
                                    .matchedGeometryEffect(id: "Album\(index)", in: name)
                                    .zIndex(selectIndex == index ? 1 : 0)
                                    .scaleEffect(selectIndex == index && isPressed ? 1.2 : 1)
                                    .animation(.easeIn, value: isPressed)
                                    .foregroundStyle(.gray)
                                    .gesture(
                                        LongPressGesture(minimumDuration: 1.0)
                                            .updating($isPressed) { value, gestureState, _ in
                                                gestureState = value
                                            }
                                            .onChanged { _ in
                                                selectIndex = index
                                            }
                                            .onEnded {_ in
                                                withAnimation {
                                                    longTapVM.isSuccess = true
                                                    longTapVM.isTapped = true
                                                    scale = 1
                                                    selectedIndex = index
                                                }
                                                AnalyticsManager.shared.logEvent(name: "LongTapAlubmPhotoView_Success")
                                            }
                                            .simultaneously(with: TapGesture()
                                                .onEnded {
                                                    withAnimation {
                                                        longTapVM.isTapped = true
                                                        longTapVM.isFail = true
                                                        scale = 1
                                                    }
                                                    FirestoreManager.shared.updateViewTapNumber(.longPress, .longTapAlbumPhotoView)
                                                    AnalyticsManager.shared.logEvent(name: "LongTapAlbumView_Fail")
                                                })
                                    )
                            }
                        }
                    }
                    .ignoresSafeArea()
                    .overlay(alignment: .top) {
                        if longTapVM.isSuccess {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundStyle(.ultraThinMaterial)
                                .ignoresSafeArea()
                        }
                    }
                    .overlay(alignment: .top) {
                        if longTapVM.isSuccess {
                            if let selectedIndex {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .aspectRatio(1, contentMode: .fill)
                                    .overlay {
                                        Image("Album\(selectedIndex)")
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .matchedGeometryEffect(id: "Album\(selectedIndex)", in: name)
                                    .offset(y: -50)
                                    .zIndex(1)
                                    .frame(width: 360, height: 360)
                                    .overlay {
                                        if longTapVM.isSuccess {
                                            ConfettiView()
                                        }
                                    }
                            }
                        }
                    }
                }
                .scrollDisabled(true)
                
                .overlay(alignment: .bottom) {
                    HelpButton(selectedGuideVideo: selectedGuideVideo, style: longTapVM.isFail ? .primary : .secondary)
                    .opacity(longTapVM.isSuccess ? 0 : 1)
                    .animation(.easeInOut, value: longTapVM.isSuccess)
                }
            }
        }
        .analyticsScreen(name: "LongTapAlbumPhotoView")
        .modifier(FinishModifier(isNavigate: $longTapVM.isNavigate, isSuccess: $longTapVM.isSuccess))
        .modifier(
            FirebaseEndViewModifier(
                isSuccess: longTapVM.isSuccess,
                viewName: .longTapAlbumPhotoView
            )
        )
        .onAppear {
            longTapVM.reset()
        }
    }
}

#Preview {
    LongTapAlbumPhotoView()
        .environment(\.locale, .init(identifier: "ja"))
}

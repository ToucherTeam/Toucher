//
//  LongTapCameraButtonView.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI

struct LongTapCameraButtonView: View {
    @StateObject private var longTapVM = LongTapViewModel()
    
    @GestureState private var isPressed = false
    
    private let firestoreManager = FirestoreManager.shared
    private let selectedGuideVideo: URLManager = .longTapCameraButtonView
    
    var body: some View {
        ZStack {
            BackGroundColor(isFail: longTapVM.isFail, isSuccess: longTapVM.isSuccess)
            
            VStack {
                CustomToolbar(title: "길게 누르기", isSuccess: longTapVM.isSuccess)
                
                ZStack {
                    VStack {
                        Text(longTapVM.isSuccess ? "성공!\n\n" : longTapVM.isFail ? "조금 더 길게 꾹 \n눌러주세요!\n" : "카메라를 1초 동안\n눌러서 추가 기능을\n알아볼까요?")
                            .foregroundColor(longTapVM.isFail && !longTapVM.isSuccess ? .white : .primary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .font(.customTitle)
                            .padding(.top, 40)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        HelpButton(selectedGuideVideo: selectedGuideVideo, style: longTapVM.isFail ? .primary : .secondary)
                            .opacity(longTapVM.isSuccess ? 0 : 1)
                            .animation(.easeInOut, value: longTapVM.isSuccess)
                    }
                    cameraButton
                        .padding(.bottom)
                        .overlay {
                            if longTapVM.isSuccess {
                                ConfettiView()
                            }
                        }
                }
            }
            .modifier(
                MoveToNextModifier(
                    isNavigate: $longTapVM.isNavigate,
                    isSuccess: $longTapVM.isSuccess
                )
            )
            .navigationDestination(isPresented: $longTapVM.isNavigate) {
                LongTapAlbumPhotoView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
        .modifier(
            FirebaseViewModifier(
                isSuccess: longTapVM.isSuccess,
                viewName: .longTapCameraButtonView
            )
        )
        .onAppear {
            longTapVM.reset()
        }
    }
    
    private var cameraButton: some View {
        Image("Camera")
            .resizable()
            .frame(width: 130, height: 130)
            .foregroundStyle(.gray)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(isPressed ? .black.opacity(0.5) : .clear)
            }
            .scaleEffect(isPressed ? 1.1 : 1)
            .animation(.easeInOut(duration: 1), value: isPressed)
            .gesture(
                LongPressGesture(minimumDuration: 1.0)
                    .updating($isPressed) { value, gestureState, _ in
                        gestureState = value
                    }
                    .onEnded {_ in
                        withAnimation {
                            longTapVM.isSuccess = true
                            longTapVM.isTapped = true
                        }
                    }
                    .simultaneously(with: TapGesture()
                        .onEnded {
                            withAnimation {
                                longTapVM.isTapped = true
                                longTapVM.isFail = true
                            }
                            FirestoreManager.shared.updateViewTapNumber(.longPress, .longTapCameraButtonView)
                        })
            )
            .background(alignment: .topLeading) {
                if longTapVM.isSuccess {
                    VStack {
                        Group {
                            HStack {
                                Text("복사")
                                Spacer()
                                Image(systemName: "doc.on.doc")
                            }
                            Divider()
                            HStack {
                                Text("공유")
                                Spacer()
                                Image(systemName: "square.and.arrow.up")
                            }
                            Divider()
                            HStack {
                                Text("즐겨찾기")
                                Spacer()
                                Image(systemName: "heart")
                            }
                            Divider()
                            HStack {
                                Text("삭제")
                                Spacer()
                                Image(systemName: "trash")
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .padding(10)
                    .frame(width: 200)
                    .background {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .foregroundStyle(Color(.systemGray6))
                    }
                    .offset(y: -180)
                    .transition(.scale)
                }
            }
    }
}

#Preview {
    LongTapCameraButtonView()
        .environment(\.locale, .init(identifier: "ko"))
}

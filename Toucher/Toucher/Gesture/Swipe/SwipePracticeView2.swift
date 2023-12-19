//
//  SwiftPracticeView2.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/06.
//

import SwiftUI

struct SwipePracticeView2: View {
    @StateObject private var navigationManager = NavigationManager.shared
    @StateObject var swipeVM = SwipeViewModel()
    
    @State private var isSuccess = false
    @State private var isFail = false
    
    var body: some View {
        ZStack {
            if isFail && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "살짝 쓸기")
                
                Text(isFail ? "왼쪽으로\n살짝 쓸어보세요.\n" :
                    isSuccess ? "성공!\n\n"
                    : "메시지를 왼쪽으로 밀어서\n삭제해 보세요\n"
                )
                .foregroundColor(isFail && !isSuccess ? Color.customWhite : Color.black)
                .font(.customTitle)
                .multilineTextAlignment(.center)
                .padding(.top, 40)
                Spacer()
                List {
                    ForEach(messageData, id: \.id) { message in
                        HStack {
                            Image(systemName: message.imageName)
                                .foregroundColor(isFail && !isSuccess ? Color.customWhite : Color.customGR1)
                                .font(.system(size: 60))
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(message.phNumber)
                                        .bold()
                                        .foregroundColor(isFail && !isSuccess ? Color.customWhite : Color.black)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    if value.translation.width < 0 {
                                                        isFail = false
                                                    } else {
                                                        if !isSuccess {
                                                            withAnimation {
                                                                isFail = true
                                                            }
                                                        }
                                                    }
                                                }
                                                .onEnded { _ in
                                                    // Handle the end of drag if needed
                                                }
                                        )
                                    Spacer()
                                    Text(message.time)
                                        .foregroundColor(isFail && !isSuccess ? Color.customWhite : Color.black)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(isFail && !isSuccess ? Color.customWhite : Color.black)
                                }
                                Text(message.text)
                                    .foregroundColor(isFail && !isSuccess ? Color.customWhite : Color.black)
                            }
                        }
                        
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                isFail = false
                                isSuccess = true
                                if let index = messageData.firstIndex(where: { $0.id == message.id }) {
                                    messageData.remove(at: index)
                                }
                                
                                print("Deleting conversation")
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "bell.slash.fill")
                            }
                            .tint(.indigo)
                        }
                        .listRowBackground(isFail ? Color.customSecondary : Color.customWhite)
                    }

                }
                .listStyle(.plain)
                Spacer()
                
                HelpButton(style: .secondary) {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
            }
        }
        .allowsHitTesting(!isSuccess)
        .overlay {
            if isSuccess {
                ConfettiView()
            }
        }
        .onChange(of: isSuccess) { _ in
            if isSuccess {
                HapticManager.notification(type: .success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    navigationManager.navigate = false
                    navigationManager.updateGesture()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SwipePracticeView2()
    }
}

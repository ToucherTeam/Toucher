//
//  SwiftPracticeView1.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/05.
//

import SwiftUI

struct SwiftPracticeView1: View {
    @StateObject var swipeVM = SwipeViewModel()
    
    var text = ["왼쪽으로\n밀어볼까요?", "삭제버튼이 나왔어요?\n아래도 밀어볼까요?", "이번엔 메일 읽음\n버튼이 나왔어요!"]
    
    var body: some View {
        ZStack {
            VStack {
                Text(text[swipeVM.index])
                    .font(.customTitle())
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    
                VStack(spacing: 16) {
                    List {
                        HStack {
                            if swipeVM.index == 0 {
                                Spacer()
                                Arrows()}
                        }
                        .swipeActions {
                            Button {
                                
                            } label: {
                                Image(systemName: "trash.fill")
                                    .padding(50)
                            }
                            .tint(.red)
                            .onAppear {
                                swipeVM.index = 1
                                swipeVM.checkSuccess = true
                            }
                            .onDisappear {
                                swipeVM.index = 0
                            }

                        }
                        .frame(height: 100)
                        .listRowBackground(Color("GR5"))
                    }
                    .cornerRadius(20)
                    .scrollDisabled(true)
                    .listStyle(.plain)
                    .frame(height: 120)
                    
                    List {
                        HStack {
                            Arrows()
                                .rotationEffect(.degrees(180))
                            Spacer()
                        }
                        .opacity(swipeVM.index == 1 ? 1 : 0)
                        .animation(.easeInOut)
                        .swipeActions(edge: .leading) {
                            Button {
                            } label: { Image(systemName: "envelope.badge.fill") }.tint(.blue)
                                .onAppear {
                                    swipeVM.index = 2
                                }
                                .onDisappear {
                                    swipeVM.index = 0
                                }
                        }
                        .frame(height: 100)
                        .listRowBackground(Color("GR5"))
                    }
                    .cornerRadius(20)
                    .scrollDisabled(true)
                    .disabled(!swipeVM.checkSuccess)
                    .listStyle(.plain)
                    .frame(height: 120)
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
                        
            if swipeVM.index == 2 {
                NavigationLink {
                    SwiftPracticeView2()
                } label: {
                    Text("다음")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width - 32)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                        }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom)
                .overlay(alignment: .bottom) {
                    VstackArrow()
                        .offset(y: -100)
                }
            }
        }
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color("GR3")),
                alignment: .top
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                CustomToolbar()
            }
        }
    }
}

struct SwipePracticeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SwipeExampleView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (2nd generation)"))
            .previewDisplayName("iPhone SE")
            
            NavigationView {
                SwipeExampleView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
        }
    }
}

struct CustomToolbar: View {
    var body: some View {
        
            HStack {
                Text("")
                Spacer()
                Text("살짝 쓸기")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color("GR1"))
                Spacer()
                Image(systemName: "gearshape")
                    .foregroundColor(.clear)
            }
            .overlay(alignment: .leading) {
                Text("이전으로")
                    .offset(x: -25)
                    .foregroundColor(Color("AccentColor"))
            }
            .frame(maxWidth: .infinity)
        }
    
}

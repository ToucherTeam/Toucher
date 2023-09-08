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
    @State private var isSuceess = false
    @State private var isOneTapped = false
    @State private var scrollOffset: CGFloat = 0
    
    @GestureState private var isPressed = false
    
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
            if isOneTapped && !isSuceess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                Text(isSuceess ? "잘하셨어요!\n" : "밑에서 위로\n쓸어 올려보세요.")
                    .foregroundColor(isOneTapped && !isSuceess ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 30)
                Spacer()
                
                ChildSizeReader(size: $wholeSize) {
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
                                                    .foregroundColor(Color("GR1"))
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
                                        isSuceess = true
                                    } else {
                                        print("not reached.")
                                    }
                                }
                            )
                        }
                    }
                    .frame(height: 320)
                    .coordinateSpace(name: spaceName)
                }
                .onChange(
                    of: scrollViewSize,
                    perform: { value in
                        print(value)
                    }
            )
                .frame(height: 320)
                
                Spacer()
                Group {
                    Text("현재 ")
                    + Text("화면을 상하좌우로")
                        .bold()
                    + Text("\n움직일 때 사용해요.")
                }
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .foregroundColor(isTapped ? .clear : .gray)
                .font(.title)
                .padding(.bottom, 80)
            }
            
        }
        .onAppear {
            isTapped = false
            isSuceess = false
            isOneTapped = false
        }
    }
}

struct PanExampleView_Previews: PreviewProvider {
    static var previews: some View {
        PanExampleView()
    }
}

//
//  TestView.swift
//  Toucher
//
//  Created by 하명관 on 2023/09/08.
//

import SwiftUI

struct TestView: View {
    let spaceName = "scroll"

    @State var wholeSize: CGSize = .zero
    @State var scrollViewSize: CGSize = .zero

    var body: some View {
        ZStack {
            ChildSizeReader(size: $wholeSize) {
                ScrollView {
                    ChildSizeReader(size: $scrollViewSize) {
                        VStack {
                            ForEach(0..<10) { _ in
                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.system(size: 32))
                                        .foregroundStyle(.white, .gray)
                                        .padding(.leading)
                                        .overlay(alignment: .bottomTrailing) {
                                            Image(systemName: "message.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.white)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                                                        .foregroundColor(.green)
                                                        .frame(width: 16, height: 16)
                                                }
                                        }
                                    VStack(alignment: .leading) {
                                        Text("title")
                                            .bold()
                                        Text("message")
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
                                print("offset: \(value)") // offset: 1270.3333333333333 when User has reached the bottom
                                print("height: \(scrollViewSize.height)") // height: 2033.3333333333333

                                if value >= scrollViewSize.height - wholeSize.height {
                                    print("User has reached the bottom of the ScrollView.")
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
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

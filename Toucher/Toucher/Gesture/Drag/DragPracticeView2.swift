//
//  DragPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI
import UniformTypeIdentifiers

struct DragPracticeView2: View {
    @State private var data = ["Camera", "App Store", "Maps", "Wallet", "Clock", "FaceTime", "TV", "Safari"]
    @State private var allowReordering = true
    @State private var isSuccess = false
    @State private var isDroped = false
    @State private var isTried = false
    @State private var isOneTapped = false
    
    @State private var isAnimate = false
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        ZStack {
            if isOneTapped && !isSuccess {
                Color.accentColor.opacity(0.5).ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "끌어오기")
                
                Rectangle().frame(height: 0)
                Spacer().frame(height: 40)
                Text(isSuccess ? "잘하셨어요!\n\n" :
                        isTried || isOneTapped ? "카메라 아이콘을\n꾹 누른 상태로\n 움직여주세요" : "카메라를 3초 누른 뒤\n오른쪽 아래에\n옮겨볼까요?")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .padding(10)
                .foregroundColor(isOneTapped && !isSuccess ? .white : .primary)
                .bold()
                .padding(.top, 30)
                LazyVGrid(columns: columns) {
                    ReorderableForEach($data,
                                       allowReordering: $allowReordering,
                                       isReached: $isSuccess,
                                       isDroped: $isDroped,
                                       isTried: $isTried) { item, _ in
                        Image(item)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .background {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<8) { index in
                            if index != 7 {
                                Rectangle()
                                    .scaledToFit()
                                    .foregroundColor(.clear)
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(isSuccess ? .clear : .customBG2)
                                        .scaleEffect(isAnimate ? 1.6 : 1.4)
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(isSuccess ? .clear : .customSecondary)
                                        .scaleEffect(isAnimate ? 1.4 : 1)
                                }
                                .animation(.easeInOut, value: isSuccess)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                                        isAnimate = true
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .onTapGesture {
                    withAnimation {
                        isOneTapped = true
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if isSuccess {
                ToucherNavigationLink(label: "완료") {
                    FinalView(gestureTitle: "끌어 오기")
                        .padding(.bottom, 13)
                        .overlay(
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(.customGR3),
                            alignment: .top
                        )
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                CustomToolbar(title: "끌어 오기")
                            }
                        }
                }
            }
        }
        .onAppear {
            data = ["Camera", "App Store", "Maps", "Wallet", "Clock", "FaceTime", "TV", "Safari"]
            isSuccess = false
        }
    }
}

public struct ReorderableForEach<Data, Content>: View where Data: Hashable, Content: View {
    @Binding var data: [Data]
    @Binding var allowReordering: Bool
    @Binding var isReached: Bool
    @Binding var isDroped: Bool
    @Binding var isTried: Bool
    
    private let content: (Data, Bool) -> Content
    
    @State private var draggedItem: Data?
    @State private var hasChangedLocation: Bool = false
    
    public init(_ data: Binding<[Data]>,
                allowReordering: Binding<Bool>,
                isReached: Binding<Bool>,
                isDroped: Binding<Bool>,
                isTried: Binding<Bool>,
                @ViewBuilder content: @escaping (Data, Bool) -> Content) {
        _data = data
        _allowReordering = allowReordering
        _isReached = isReached
        _isDroped = isDroped
        _isTried = isTried
        self.content = content
    }
    
    public var body: some View {
        ForEach(data, id: \.self) { item in
            if allowReordering {
                content(item, hasChangedLocation && draggedItem == item)
                    .onDrag {
                        draggedItem = item
                        return NSItemProvider(object: "\(item.hashValue)" as NSString)
                    }
                    .onDrop(of: [UTType.plainText], delegate: ReorderDropDelegate(
                        item: item,
                        data: $data,
                        draggedItem: $draggedItem,
                        hasChangedLocation: $hasChangedLocation,
                        isReached: $isReached,
                        isDroped: $isDroped,
                        isTried: $isTried)
                    )
            } else {
                content(item, false)
            }
        }
    }
    
    struct ReorderDropDelegate<Data>: DropDelegate
    where Data: Equatable {
        let item: Data
        @Binding var data: [Data]
        @Binding var draggedItem: Data?
        @Binding var hasChangedLocation: Bool
        @Binding var isReached: Bool
        @Binding var isDroped: Bool
        @Binding var isTried: Bool
        
        func dropEntered(info: DropInfo) {
            guard item != draggedItem,
                  let current = draggedItem,
                  let from = data.firstIndex(of: current),
                  let indexTo = data.firstIndex(of: item)
            else { return }
            hasChangedLocation = true
            if data[indexTo] != current {
                print(indexTo)
                if current as! String == "Camera" && indexTo == 7 {
                    isReached = true
                } else {
                    isReached = false
                    isTried = true
                }
                withAnimation {
                    data.move(fromOffsets: IndexSet(integer: from),
                              toOffset: (indexTo > from) ? indexTo + 1 : indexTo)
                }
            }
        }
        
        /// + 버튼이 표시되지 않게 하기 위함
        func dropUpdated(info: DropInfo) -> DropProposal? {
            DropProposal(operation: .move)
        }
        
        /// for Protocol
        func performDrop(info: DropInfo) -> Bool {
            return true
        }
    }
}

struct DragPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        DragPracticeView2()
    }
}

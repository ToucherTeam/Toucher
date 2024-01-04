//
//  DragPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI
import UniformTypeIdentifiers

struct DragPracticeView2: View {
    @StateObject private var navigationManager = NavigationManager.shared
    
    @State private var data = ["Camera", "App Store", "Maps", "Wallet", "Clock", "FaceTime", "TV", "Safari"]
    @State private var allowReordering = true
    @State private var isSuccess = false
    @State private var isDroped = false
    @State private var isTried = false
    @State private var isFailed = false
    
    @State private var isAnimate = false
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        ZStack {
            if isFailed && !isSuccess || isDroped && !isSuccess {
                Color.customSecondary.ignoresSafeArea()
            }
            VStack {
                CustomToolbar(title: "끌어오기", isSuccess: isSuccess)
                
                Rectangle().frame(height: 0)
                Text(isSuccess ? "성공!\n\n" : isDroped ? "위치를 오른쪽 가장\n아래로 움직여 주세요\n" :
                        isTried || isFailed ? "카메라 아이콘을\n꾹 누른 상태로\n움직여주세요" : "카메라를 3초 누른 뒤\n오른쪽 아래에\n옮겨볼까요?")
                .multilineTextAlignment(.center)
                .font(.customTitle)
                .foregroundColor(isFailed && !isSuccess || isDroped && !isSuccess ? .white : .primary)
                .padding(.top, 40)
                .padding(.bottom, 40)
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
                                .opacity(isTried ? 1 : 0)
                            }
                        }
                    }
                }
                .padding()
                .onTapGesture {
                    withAnimation {
                        isFailed = true
                    }
                }
                .overlay {
                    if isSuccess {
                        ConfettiView()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                HelpButton(style: isFailed || isDroped ? .primary : .secondary, currentViewName: "DragPracticeView2") {
                    
                }
                .opacity(isSuccess ? 0 : 1)
                .animation(.easeInOut, value: isSuccess)
            }
        }
        .onAppear {
            data = ["Camera", "App Store", "Maps", "Wallet", "Clock", "FaceTime", "TV", "Safari"]
            isSuccess = false
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
    
    struct ReorderDropDelegate<ItemType>: DropDelegate where ItemType: Equatable {
        let item: ItemType
        @Binding var data: [ItemType]
        @Binding var draggedItem: ItemType?
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
                } else if current as! String == "Camera" {
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
            return DropProposal(operation: .move)
        }
        
        /// for Protocol
        func performDrop(info: DropInfo) -> Bool {
            if let current = draggedItem as? String, current == "Camera" {
                if let indexTo = data.firstIndex(of: item) {
                    if indexTo != 7 {
                        withAnimation {
                            isDroped = true
                        }
                    }
                }
            }
            draggedItem = nil
            return true
        }
    }
}

struct DragPracticeView2_Previews: PreviewProvider {
    static var previews: some View {
        DragPracticeView2()
    }
}
//
//  DragPracticeView2.swift
//  Toucher
//
//  Created by hyunjun on 2023/09/05.
//

import SwiftUI
import UniformTypeIdentifiers

struct DragPracticeView2: View {
    @State private var data = ["Clock", "App Store", "Maps", "Wallet", "Camera", "FaceTime", "TV" , "Safari"]
    @State private var allowReordering = true
    @State private var isSuceess = false
    @State private var isDroped = false
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle().frame(height:0)
                Spacer().frame(height: 40)
                Text(isSuceess ? "잘하셨어요!\n\n" : "카메라를 3초 누른 뒤\n화살표가 가리키는\n곳에 옮겨볼까요?")
                    .font(Font.customTitle())
                    .multilineTextAlignment(.center)
                    .padding(10)
                    .bold()
                    .padding(.top, 30)
                LazyVGrid(columns: columns) {
                    ReorderableForEach($data, allowReordering: $allowReordering, isReached: $isSuceess,  isDroped: $isDroped) { item, isDragged in
                        Image(item)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .padding()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if isSuceess {
                NavigationLink {
                    
                } label: {
                    Text("다음")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                        }
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

public struct ReorderableForEach<Data, Content>: View where Data : Hashable, Content : View {
    @Binding var data: [Data]
    @Binding var allowReordering: Bool
    @Binding var isReached: Bool
    @Binding var isDroped: Bool
    
    private let content: (Data, Bool) -> Content
    
    @State private var draggedItem: Data?
    @State private var hasChangedLocation: Bool = false
    
    public init(_ data: Binding<[Data]>,
                allowReordering: Binding<Bool>,
                isReached: Binding<Bool>,
                isDroped: Binding<Bool>,
                @ViewBuilder content: @escaping (Data, Bool) -> Content) {
        _data = data
        _allowReordering = allowReordering
        _isReached = isReached
        _isDroped = isDroped
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
                        isDroped: $isDroped)
                    )
            } else {
                content(item, false)
            }
        }
    }
    
    struct ReorderDropDelegate<Data>: DropDelegate
    where Data : Equatable {
        let item: Data
        @Binding var data: [Data]
        @Binding var draggedItem: Data?
        @Binding var hasChangedLocation: Bool
        @Binding var isReached: Bool
        @Binding var isDroped: Bool
        
        func dropEntered(info: DropInfo) {
            guard item != draggedItem,
                  let current = draggedItem,
                  let from = data.firstIndex(of: current),
                  let to = data.firstIndex(of: item)
            else {
                return
            }
            hasChangedLocation = true
            if data[to] != current {
                print(to)
                if current as! String == "Camera" && to == 7 {
                    isReached = true
                }
                else {
                    isReached = false
                }
                withAnimation {
                    data.move(fromOffsets: IndexSet(integer: from),
                              toOffset: (to > from) ? to + 1 : to)
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

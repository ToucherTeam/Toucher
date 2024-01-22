//
//  NewGuideView.swift
//  Toucher
//
//  Created by bulmang on 1/21/24.
//

import SwiftUI
import AVKit

struct GuideView: View {
    @State private var player = AVPlayer()
    @State private var videoDuration = 0.0
    @State private var totalDuration = 0.0
    
    @Binding var selectedGuideVideo: URLManager
    @Binding var isFullScreenPresented: Bool
    
    let playerDidFinishNotification = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    ProgressView(value: videoDuration, total: totalDuration)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding(.leading, 20)
                        .padding(.trailing, 60)
                        .overlay(alignment: .trailing) {
                            Button(action: {
                                isFullScreenPresented.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            })
                            .padding(.trailing, 20)
                        }
                }
                .onReceive(timer) { _ in
                    guard let item = player.currentItem else {
                        return
                    }
                    self.totalDuration = item.seekableTimeRanges.last?.timeRangeValue.end.seconds ?? 0.0
                    withAnimation {
                        videoDuration = CMTimeGetSeconds(player.currentTime())
                    }
                }
                VideoPlayer(player: player)
                    .onAppear {
                        if let url = URL(string: selectedGuideVideo.videoURL) {
                            player = AVPlayer(url: url)
                            player.play()
                        } else {
                        }
                    }
                    .onReceive(playerDidFinishNotification, perform: { _ in
                        isFullScreenPresented = false
                    })
                    .onDisappear {
                        player.pause()
                    }
            }
        }
    }
}

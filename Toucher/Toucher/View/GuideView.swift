//
//  GuideView.swift
//  Toucher
//
//  Created by bulmang on 12/20/23.
//

import SwiftUI
import WebKit

struct GuideView: View {
    @State var progress = 0.0

    @Binding var isFullScreenPresented: Bool
    
    let currentViewName: String?
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
                
            HStack(alignment: .top) {
                ProgressView(value: progress)
                    .progressViewStyle(BarProgressStyle(isFullScreenPresented: $isFullScreenPresented))
                    .padding(.leading, 15)
                    .task {
                        let totalTime = 3.0
                        let totalSteps = Int(totalTime / 0.1)
                        let increment = 1.0 / Double(totalSteps)
                        
                        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                            withAnimation {
                                self.progress += increment

                                if self.progress >= 1.0 {
                                    isFullScreenPresented = false
                                    self.progress = 0.0
                                    timer.invalidate()
                                }
                            }
                        }
                    }
            }
            .padding(.top, 68)
            
            GifImage(currentViewName ?? "")
                .frame(width: 300,height: 650)
                .padding(.top, 68)
        }
        .ignoresSafeArea()
    }
}

struct BarProgressStyle: ProgressViewStyle {
    @Binding var isFullScreenPresented: Bool
    
    var color: Color = .customSecondary
    var height: Double = 24.0
    
    func makeBody(configuration: Configuration) -> some View {
        
        let progress = configuration.fractionCompleted ?? 0.0
        
        GeometryReader { geometry in
            HStack {
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(Color.white)
                    .frame(height: height)
                    .frame(width: geometry.size.width - 80)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(color)
                            .frame(width: geometry.size.width * progress - 90)
                            .frame(height: 18)
                            .padding(.leading, 5)
                    }
                    
                Spacer()
                
                Button(action: {
                    isFullScreenPresented.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                })
                .padding(.trailing, 30)
            }
        }
    }
}

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            do {
                let data = try Data(contentsOf: url)
                webView.load(
                    data,
                    mimeType: "image/gif",
                    characterEncodingName: "UTF-8",
                    baseURL: url.deletingLastPathComponent()
                )
            } catch {
                print("Error loading gif: \(error)")
            }
        }
        webView.scrollView.isScrollEnabled = false

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

#Preview {
    GuideView(isFullScreenPresented: .constant(false), currentViewName: "DoubleTapExampleView")
}

//
//  FullScreenMediaView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import AVKit
import SwiftUI
import Kingfisher

struct FullScreenMediaView: View {
    let media: PresentedMedia
    @State private var player: AVPlayer?
    
    var body: some View {
        Group {
            switch media {
            case .image(let url):
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .background(Color.black.ignoresSafeArea())
                
            case .video(let url):
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        if player == nil {
                            player = AVPlayer(url: url)
                        }
                        player?.play()
                    }
                    .onDisappear {
                        player?.pause()
                        player?.replaceCurrentItem(with: nil)
                        player = nil
                    }
            }
        }
    }
}

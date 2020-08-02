//
//  CustomViewPlayer.swift
//  Sims School
//
//  Created by João Damazio on 21/07/20.
//  Copyright © 2020 João Damazio. All rights reserved.
//

import SwiftUI
import AVKit

struct VideoView: UIViewRepresentable {
//	@Published hasToPause: Bool
	var videoURL: URL
	   
	func makeUIView(context: Context) -> PlayerView {
		return PlayerView(frame: .zero, url: videoURL)
	}

	func updateUIView(_ playerView: PlayerView, context: Context) {
//		if self.hasToPause {
//			playerView.playerLayer.player?.pause()
//		}
//		else {
//			playerView.playerLayer.player?.pause()
//		}
	}
	
}

struct CustomUIVideoPlayer_Previews: PreviewProvider {
	@State static var videoURL = "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
	
	static var previews: some View {
		VideoView(videoURL: URL(string: videoURL)!)
	}
}


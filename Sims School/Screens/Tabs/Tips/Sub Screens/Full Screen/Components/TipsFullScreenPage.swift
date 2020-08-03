//
//  TipsFullScreenPage.swift
//  Sims School
//
//  Created by João Damazio on 31/07/20.
//  Copyright © 2020 João Damazio. All rights reserved.
//

import SwiftUI

struct TipsFullScreenPage: View {
	@ObservedObject var props: TipsFullScreenPageModel

	init(tip: TipsResponse, isSliding: Bool, currentSlide: Int, isActual: Bool) {
		self.props = TipsFullScreenPageModel(tip: tip, isSliding: isSliding, currentSlide: currentSlide, isActual: isActual)
		
		if self.props.isActual {
			self.props.mediaRequest()
		}
		
		else {
			
		}
	}
	
	func getActualMedia() -> TipsMediasResponse {
		self.props.medias[self.props.currentMedia]
	}
	
	func getBackground() -> AnyView {
		let media = self.getActualMedia()
		
		if let uiImage = media.uiImage, media.isVerticalIMG {
			return AnyView(getVerticalImage(uiImage))
		}
			
		else if let videoView = media.videoView, media.isVerticalVideo {
			return AnyView(getVerticalVideo(videoView))
		}
			
		else {
			let backgroundColors = Gradient(colors: [
				Color(UIColor.hexStringToUIColor(hex: "#cccccc")),
				Color(UIColor.hexStringToUIColor(hex: "#e5e5e5"))
			])
		
			let gradient = LinearGradient(
				gradient: backgroundColors, startPoint: .top, endPoint: .bottom
			)
			
			return AnyView(gradient)
		}
		
	}
	
	func getVerticalImage(_ uiImage: UIImage) -> some View {
		Image(uiImage: uiImage)
			.resizable()
			.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight  - 20)
			.clipped()
			.opacity(0.95)
	}
	
	func getVerticalVideo(_ videoView: VideoView) -> some View {
		videoView
			.frame(width: nil, height: UIScreen.screenHeight - 20, alignment: .center)
			.opacity(0.95)
	}
	
	var failedView: some View {
		TryAgainView(
			text: "There was an error when trying to get the tip.",
			onTryAgain: {
//				self.props.medias[self.props.currentMedia]. = .loading
//
//				let media = self.props.tip.getMedia()
//
//				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//					media.getMediaRequest()
//				}
			},
			color: .white
		)
		.padding(.horizontal)
	}
	
	var loadingView: some View {
		ActivityIndicator(color: .black, transform: CGAffineTransform(scaleX: 3, y: 3))
	}
	
	var successView: some View {
		TipsFullScreenImage(media: self.getActualMedia())
	}
	
	var body: some View {
		let media = self.getActualMedia()
		
		return (
			GeometryReader { geometry in
				VStack {
					TipsFullScreenProgressBar(
						tip: self.props.tip,
						currentMedia: self.props.currentMedia,
						progress: media.progress,
						isVisible: !self.props.isDetectingPress && !self.props.isSliding
					)
					TipsFullScreenBackButton(
						tip: self.props.tip,
						isVisible: !self.props.isDetectingPress && !self.props.isSliding
					)
					TipsFullScreenContainerMedia(
						tip: self.props.tip,
						currentMedia: self.$props.currentMedia,
						currentSlide: self.$props.currentSlide,
						isDetectingPress: self.$props.isDetectingPress,
						onChangeStatus: { value in  self.props.changeStatus(value: value) }) {
							if media.status == .failed {
								self.failedView
							}
							else if media.status == .loading {
								self.loadingView
							}
							else {
								self.successView
							}
					}
					if media.status == .success {
						TipsFullScreenOpenLink(
							link: media.url,
							isVertical: !media.isVerticalIMG && !media.isVerticalVideo,
							isVisible: !self.props.isDetectingPress && !self.props.isSliding
						)
					}
				}
				.background(self.getBackground())
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
				.rotation3DEffect(
					Angle(degrees: Double(geometry.frame(in: .global).minX / 5)),
					axis: (x: 0, y: 10, z: 0)
				)
			}
			.background(Color.black)
		)
	}
}

//struct TipsFullScreenPage_Previews: PreviewProvider {
//	static var previews: some View {
//		TipsFullScreenPage()
//	}
//}

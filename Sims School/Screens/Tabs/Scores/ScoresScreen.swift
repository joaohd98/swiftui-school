//
//  ScoresScreen.swift
//  Sims School
//
//  Created by João Damazio on 14/07/20.
//  Copyright © 2020 João Damazio. All rights reserved.
//

import SwiftUI

struct ScoresScreen: View {
	@FetchRequest(entity: UserEntity.entity(), sortDescriptors: []) var users: FetchedResults<UserEntity>
	@FetchRequest(entity: ScoreEntity.entity(), sortDescriptors: []) var scores: FetchedResults<ScoreEntity>
	@ObservedObject var props: ScoreScreenModel
	
	func viewDidLoad() {
		props.initProps(users: self.users, scores: self.scores)
	}
	
    var body: some View {
		CustomContainerSignIn {
			ScrollView {
				ScoresScreenSemesters()
				ScoresScreenCardScore()
			}
			.onAppear(perform: self.viewDidLoad)
			.navigationBarTitle("Score")
		}
    }
}

struct ScoresScreen_Previews: PreviewProvider {
	static let props = ScoreScreenModel()
	
    static var previews: some View {
		ScoresScreen(props: self.props)
    }
}

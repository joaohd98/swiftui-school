//
//  ClassesScreenSubjectDay.swift
//  Sims School
//
//  Created by João Damazio on 17/07/20.
//  Copyright © 2020 João Damazio. All rights reserved.
//

import SwiftUI

private struct Subject: Hashable {
	let uid = UUID()
	let icon: String
	let title: String
	let message: String
}

struct ClassesScreenSubjectDay: View {
	let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
	var days: [CalendarCourseResponse] = []
	@Binding var dayOfYear: Int
	
	init(calendar: [CalendarResponse], dayOfYear: Binding<Int>) {
		self._dayOfYear = dayOfYear
		
		if days.count == 0 {
			calendar.forEach { month in
				month.weeks.forEach { week in
					week.days.forEach { day in
						self.days.append(day)
					}
				}
			}
		}
	}
	
	private func daysSelection() -> some View {
		let courseSelected = self.days[self.dayOfYear]
		
		let backgroundColors = Gradient(colors: [
			Color(UIColor.hexStringToUIColor(hex: "#29F4D5")),
			Color(UIColor.hexStringToUIColor(hex: "#B7FF00"))
		])
		
		let gradient = RadialGradient(
			gradient: backgroundColors, center: .top, startRadius: 50, endRadius: 200
		)
		.cornerRadius(5)
		
		let isCurrentDay: (_ index: Int) -> Bool = { index in index == courseSelected.weekday }
		let getDay: (_ index: Int) -> String = { index in
			let getCurrentWeekDay: (_ isIncreasing: Bool) -> String = { isIncreasing in
				var indexSelected = self.dayOfYear
				var value = ""
				 
				let size = self.days.count - 1
				let sumValue = isIncreasing ? 1 : -1

				while(isIncreasing ? indexSelected <= size : indexSelected >= 0) {
					let selectedDay = self.days[indexSelected]
					if(selectedDay.weekday == index) {
						value = selectedDay.getDayOfMonth()
						break
					}
					
					indexSelected += sumValue
				}
				
				return value
			}
			
			if(courseSelected.weekday > index) {
				return getCurrentWeekDay(false)
			}
			else if(courseSelected.weekday < index) {
				return getCurrentWeekDay(true)
			}
			else {
				return courseSelected.getDayOfMonth()
			}
		}
		
		
		return (
			HStack(spacing: 0) {
				ForEach(weekdays.indices) { index in
					Button(action:  {
						let value = index - courseSelected.weekday
						self.dayOfYear = self.dayOfYear + value
					}) {
						VStack(spacing: 30) {
							Text(self.weekdays[index])
								.foregroundColor(isCurrentDay(index) ? Color.black : Color(CustomColor.gray))
							Text(getDay(index))
								.foregroundColor(isCurrentDay(index) ? Color.black : Color(CustomColor.gray))
						}
					}
					.frame(maxWidth: .infinity)
					.padding(.vertical, 5)
					.background(isCurrentDay(index) ? gradient : nil)
					.disabled(getDay(index) != "" ? isCurrentDay(index) : true)
				}
			}
			.padding(.top, 10)
			.padding(.bottom, 15)
		)
		
	}
	
	private func dayOff() -> some View {
		VStack(spacing: 30) {
			Spacer()
			Image("garfield-relaxing")
			Text("Enjoy your day off")
				.font(.system(size: 16, weight: .bold))
			Spacer()

		}
	}
	
	private func dayRegular(subjects: [Subject]) -> some View {
		ForEach(subjects.indices, id: \.description) { index in
			Group {
				if subjects[index].title != "" {
					if index > 0 {
						HStack(alignment: .firstTextBaseline, spacing: 20) {
							Rectangle()
								.fill(Color(UIColor { (trait) -> UIColor in return trait.userInterfaceStyle == .dark ? .white : .black}))
								.frame(width: 2, height: 60)
								.padding(.leading, 10)
							Spacer()
						}
					}
					HStack(alignment: .firstTextBaseline, spacing: 20) {
						VStack {
							Image(systemName: subjects[index].icon)
								.resizable()
								.frame(width: 25, height: 25, alignment: .center)
								.padding(.bottom, -15)
						}
						VStack(alignment: .leading, spacing: 5) {
							Text(subjects[index].title)
								.font(.system(size: 16, weight: .semibold))
							Text(subjects[index].message)
								.font(.system(size: 14, weight: .semibold))
						}
						Spacer()
					}
				}
			}
		}
	}
	
	private func dayContent() -> some View {
		let courseSelected = self.days[self.dayOfYear]
		let subjects = [
			Subject(icon: "studentdesk", title: courseSelected.course, message: courseSelected.teacher),
			Subject(icon: "paperplane", title: courseSelected.homework, message: "Grupo de 2 a 4 pessoas"),
			Subject(icon: "paperclip", title: courseSelected.test, message: "Individual"),
		]
		
		return (
			VStack(spacing: 2) {
				if courseSelected.course != "" {
					self.dayRegular(subjects: subjects)
				}
				else {
					self.dayOff()
				}
			}
			.padding()
		)
		
	}
	
	var body: some View {
		ZStack {
			GeometryReader { geometry in
				VStack(spacing: 5) {
					self.daysSelection()
					self.dayContent()
				}
				.padding()
				.frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
			}
		}
	}
}

struct ClassesScreenSubjectDay_Previews: PreviewProvider {
	@State static var calendar: [CalendarResponse] = [CalendarResponse()]
	@State static var dayOfYear: Int = 0
	
	static var previews: some View {
		ClassesScreenSubjectDay(calendar: calendar, dayOfYear: $dayOfYear)
	}
}

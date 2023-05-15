//
//  UberSwiftApp.swift
//  UberSwift
//
//  Created by Javier Bonilla on 5/5/23.
//

import SwiftUI

@main
struct UberSwiftApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}

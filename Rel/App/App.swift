//
//  App.swift
//  Rel
//
//  Created by Yuki Okudera on 2023/08/04.
//

import SwiftUI

@main
struct App: SwiftUI.App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//
//  Microphone_ManagerApp.swift
//  Microphone Manager
//
//  Created by David Morán on 24/12/20.
//

import SwiftUI

@main
struct Microphone_ManagerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

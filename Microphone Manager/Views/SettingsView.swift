//
//  SettingsView.swift
//  Microphone Manager
//
//  Created by David Morán on 28/12/20.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View, Initializable {
    @AppStorage("launchOnStart") var launchOnStart: Bool = false
    @AppStorage("enableKeyBinding") var enableKeyBinding: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            LaunchAtLogin.Toggle()
                .padding(.leading).padding(.trailing)
            Toggle("Enable keybinding (⌥+⌘+M)", isOn: $enableKeyBinding)
                .padding(.leading).padding(.trailing)
        }.padding()
    }
}


//
//  SettingsView.swift
//  Microphone Manager
//
//  Created by David Morán on 28/12/20.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    @AppStorage("launchOnStart") var launchOnStart: Bool = false
    @AppStorage("enableKeyBinding") var enableKeyBinding: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            LaunchAtLogin.Toggle()
                .padding(.leading).padding(.trailing)
            Toggle("Enable keybinding (⌥+⌘+M)", isOn: $enableKeyBinding)
                .padding(.leading).padding(.trailing)
            
            Divider()
                .frame(width: 370, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text("Icon for this app was designed by rawpixel.com / Freepik")
                .padding(.leading).padding(.trailing)
            Text("http://www.freepik.com")
                .padding(.leading).padding(.trailing)
        }.padding()
    }
}


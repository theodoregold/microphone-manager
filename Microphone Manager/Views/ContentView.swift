//
//  ContentView.swift
//  Microphone Manager
//
//  Created by David Morán on 24/12/20.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var hoveringAbout = false
    @State var hoveringPreferences = false
    @State var hoveringQuit = false
    
    @ObservedObject var connectedInputDevicesState: ConnectedInputDevicesState
    
    var body: some View {
        VStack(alignment: .leading) {
            GlobalInputDeviceView(connectedInputDevicesState: connectedInputDevicesState)
                .padding(.top)
            
            Divider()
                   
            List {
                HStack {
                    Text("Default")
                        .padding(.leading).padding(.trailing)
                    Spacer()
                    Text("Name")
                        .padding(.leading).padding(.trailing)
                    Spacer()
                    Text("Muted")
                        .padding(.leading).padding(.trailing)
                }
                Divider()
                ForEach(Array(connectedInputDevicesState.inputDeviceStates), id: \.id) { inputDeviceState in
                    InputDeviceView(inputDeviceState: inputDeviceState)
                }
            }
            
            Divider()
            
            Text("About")
                .buttonStyle(PlainButtonStyle())
                .padding(.leading).padding(.trailing)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    NSApp.sendAction(#selector(AppDelegate.openAboutWindow), to: nil, from:nil)
                }
                .foregroundColor(hoveringAbout ? Color.accentColor : Color.primary)
                .onHover { hovering in
                    self.hoveringAbout = hovering
                }

            
            Divider()
            
            Text("Preferences...")
                .buttonStyle(PlainButtonStyle())
                .padding(.leading).padding(.trailing)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    NSApp.sendAction(#selector(AppDelegate.openPreferencesWindow), to: nil, from:nil)
                }
                .foregroundColor(hoveringPreferences ? Color.accentColor : Color.primary)
                .onHover { hovering in
                    self.hoveringPreferences = hovering
                }

            
            Divider()
            
            Text("Quit")
                .buttonStyle(PlainButtonStyle())
                .padding(.leading).padding(.trailing)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    exit(0)
                }
                .foregroundColor(hoveringQuit ? Color.accentColor : Color.primary)
                .onHover { hovering in
                    self.hoveringQuit = hovering
                }

            
            Divider()
        }
        .frame(width: 380, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    init(connectedInputDevicesState: ConnectedInputDevicesState) {
        self.connectedInputDevicesState = connectedInputDevicesState
    }
}

//
//  ContentView.swift
//  Microphone Manager
//
//  Created by David Morán on 24/12/20.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var connectedInputDevicesState: ConnectedInputDevicesState
    
    var body: some View {
        VStack {
            GlobalInputDeviceView(connectedInputDevicesState: connectedInputDevicesState)
                .padding(.top)
            
            Divider()
            
            Text("Preferences...")
                .buttonStyle(PlainButtonStyle())
                .padding(.leading).padding(.trailing)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    NSApp.sendAction(#selector(AppDelegate.openPreferencesWindow), to: nil, from:nil)
                }
            
            Divider()
            
            List {
                ForEach(Array(connectedInputDevicesState.inputDeviceStates), id: \.id) { inputDeviceState in
                    InputDeviceView(inputDeviceState: inputDeviceState)
                }
            }
            
            Divider()
            
            Text("Quit")
                .buttonStyle(PlainButtonStyle())
                .padding(.leading).padding(.trailing).padding(.bottom)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    exit(0)
                }
        }
    }
    
    init(connectedInputDevicesState: ConnectedInputDevicesState) {
        self.connectedInputDevicesState = connectedInputDevicesState
    }
}

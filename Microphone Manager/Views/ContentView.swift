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
        VStack(alignment: .leading) {
            GlobalInputDeviceView(connectedInputDevicesState: connectedInputDevicesState)
                .padding(.top)
            
            Divider()
            
            Text("About")
                .buttonStyle(PlainButtonStyle())
                .padding(.leading).padding(.trailing)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    NSApp.sendAction(#selector(AppDelegate.openAboutWindow), to: nil, from:nil)
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
            
            Divider()
            
            List {
                ForEach(Array(connectedInputDevicesState.inputDeviceStates), id: \.id) { inputDeviceState in
                    InputDeviceView(inputDeviceState: inputDeviceState)
                }
            }
            //.frame(width: nil, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Divider()
            
            Text("Quit")
                .buttonStyle(PlainButtonStyle())
                .padding(.leading).padding(.trailing).padding(.bottom)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    exit(0)
                }
            
            Divider()
        }
        .frame(width: nil, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    init(connectedInputDevicesState: ConnectedInputDevicesState) {
        self.connectedInputDevicesState = connectedInputDevicesState
    }
}

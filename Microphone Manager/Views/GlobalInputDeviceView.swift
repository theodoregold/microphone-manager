//
//  GlobalInputDeviceView.swift
//  Microphone Manager
//
//  Created by David Morán on 28/12/20.
//

import SwiftUI

struct GlobalInputDeviceView: View {
    @State var hovering = false
    @State var muted: Bool = false
    @ObservedObject var connectedInputDevicesState: ConnectedInputDevicesState
    
    var body: some View {
        VStack{
            HStack {
                Text(muted ? "Unmute all" : "Mute all")
                    .padding(.leading).padding(.trailing)
                Spacer()
                Image(systemName: muted ? "mic.slash.fill" : "mic.fill")
                    .font(.title)
                    .padding(.leading).padding(.trailing)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                muted = !muted
                connectedInputDevicesState.setMute(mute: muted)
            }
            .onReceive(connectedInputDevicesState.$inputDeviceStates) { _ in
                muted = connectedInputDevicesState.isMuted()
            }
        }
        .foregroundColor(hovering ? Color.accentColor : Color.primary)
        .onHover{ hovering in
            self.hovering = hovering
        }
    }
    
    init(connectedInputDevicesState: ConnectedInputDevicesState) {
        self.connectedInputDevicesState = connectedInputDevicesState
    }
}

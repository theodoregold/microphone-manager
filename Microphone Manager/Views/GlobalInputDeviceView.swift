//
//  GlobalInputDeviceView.swift
//  Microphone Manager
//
//  Created by David Morán on 28/12/20.
//

import SwiftUI

struct GlobalInputDeviceView: View {
    @State var muted: Bool = false
    @ObservedObject var connectedInputDevicesState: ConnectedInputDevicesState
    
    var body: some View {
        VStack{
            HStack {
                Text("Desired state")
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
    }
    
    init(connectedInputDevicesState: ConnectedInputDevicesState) {
        self.connectedInputDevicesState = connectedInputDevicesState
    }
}

//
//  InputDeviceView.swift
//  Microphone Manager
//
//  Created by David Morán on 27/12/20.
//

import Foundation

import SwiftUI

struct InputDeviceView: View {
    @ObservedObject var inputDeviceState: InputDeviceState
    
    var body: some View {
        HStack {
            Image(systemName: inputDeviceState.isDefault ? "circle.fill" : "circle")
                .font(.largeTitle)
                .padding(.leading).padding(.trailing)
            Text(inputDeviceState.name)
                .padding(.leading).padding(.trailing)
            Spacer()
            Image(systemName: inputDeviceState.muted ? "mic.slash.fill" : "mic.fill")
                .font(.largeTitle)
                .padding(.leading).padding(.trailing)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            inputDeviceState.muted = !inputDeviceState.muted
        }
    }
}

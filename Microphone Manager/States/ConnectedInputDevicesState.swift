//
//  ConnectedInputDevicesState.swift
//  Microphone Manager
//
//  Created by David Morán on 26/12/20.
//

import Foundation

class ConnectedInputDevicesState : ObservableObject {
    private let connectedInputDevices = ConnectedInputDevices()
    
    var onChange: ((ConnectedInputDevicesState) -> ())?

    @Published var inputDeviceStates : Set<InputDeviceState>
    
    init(onChange: ((ConnectedInputDevicesState) -> ())? = nil) throws {
        self.inputDeviceStates = Set<InputDeviceState>()
        inputDeviceStates = inputDevices2State(try connectedInputDevices.inputDevices())
        self.onChange = onChange
        self.startChecksTimer()
    }
    
    func isMuted() -> Bool {
        for idState in inputDeviceStates {
            if idState.muted == false {
                return false
            }
        }
        
        return true
    }
 
    func setMute(mute: Bool) {
        for idState in self.inputDeviceStates {
            idState.muted = mute
        }
        onChange?(self)
    }
 
    private func inputDevices2State(_ inputDevices: Set<InputDevice>) -> Set<InputDeviceState> {
        var inputDeviceStates = Set<InputDeviceState>()
        for inputDevice in inputDevices {
            if let idState = try? InputDeviceState(inputDevice: inputDevice, onChange:  {_ in
                // Update all views depending on this observable object
                self.inputDeviceStates = self.inputDeviceStates

            }) {
                inputDeviceStates.insert(idState)
            }
        }
        return inputDeviceStates
    }
    
    private func state2InputDevices(_ states: Set<InputDeviceState>) -> Set<InputDevice> {
        return Set<InputDevice>(states.map { state in
            return state.inputDevice
        })
    }
    
    private func startChecksTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.checkForNewDevices()
            self.checkForVolumeChanges()
            self.checkForDefaultDevice()
        }
    }
    
    private func checkForNewDevices() {
        if let inputDevices = try? connectedInputDevices.inputDevices() {
            let current = state2InputDevices(inputDeviceStates)
            
            if current != inputDevices {
                inputDeviceStates = inputDevices2State(inputDevices)
            }
        }
    }
    
    private func checkForVolumeChanges() {
        var changed = false
        for idState in inputDeviceStates {
            if let isDeviceMuted = try? idState.inputDevice.isMuted() {
                if idState.muted != isDeviceMuted {
                    idState.muted = isDeviceMuted
                    changed = true
                }
            }
        }
        
        if changed {
            onChange?(self)
        }
    }
    
    private func checkForDefaultDevice() {
        for idState in inputDeviceStates {
            if let isDefault = try? idState.inputDevice.isDefault() {
                if idState.isDefault != isDefault {
                    idState.isDefault = isDefault
                }
            }
        }
    }
}

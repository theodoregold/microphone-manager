//
//  InputDeviceObservable.swift
//  Microphone Manager
//
//  Created by David Morán on 24/12/20.
//

import Foundation
import CoreAudio

class InputDeviceState : ObservableObject, Hashable, Identifiable {
    static func == (lhs: InputDeviceState, rhs: InputDeviceState) -> Bool {
        return lhs.inputDevice.audioDeviceID == rhs.inputDevice.audioDeviceID
    }
    
    private(set) var inputDevice: InputDevice

    var id : AudioDeviceID {
        return inputDevice.audioDeviceID
    }
    
    var onChange: ((InputDeviceState) -> ())?
    
    @Published var muted : Bool {
        willSet {
            guard (try? self.inputDevice.mute(mute: newValue)) != nil else {
                return
            }
            if newValue {
                guard (try? self.inputDevice.silence()) != nil else {
                    try? self.inputDevice.mute(mute: muted)
                    return
                }
            } else {
                guard (try? self.inputDevice.restoreFromSilence()) != nil else {
                    try? self.inputDevice.mute(mute: muted)
                    return
                }
            }
        }
        didSet {
            onChange?(self)
        }
    }
    
    @Published var name: String {
        didSet {
            onChange?(self)
        }
    }
    
    @Published var isDefault: Bool {
        didSet {
            onChange?(self)
        }
    }
    
    init(inputDevice: InputDevice, onChange: ((InputDeviceState) -> ())? = nil) throws {
        self.inputDevice = inputDevice
        muted = try inputDevice.isMuted() && inputDevice.isSilenced()
        name = inputDevice.name
        isDefault = try inputDevice.isDefault()
        self.onChange = onChange
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(inputDevice.audioDeviceID)
    }
}

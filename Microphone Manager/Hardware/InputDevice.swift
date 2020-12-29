//
//  InputDevice.swift
//  Microphone Manager
//
//  Created by David Morán on 24/12/20.
//

import CoreAudio

class InputDevice : Hashable, Identifiable {
    static let UnknownDeviceName = "Unknown device name"
    
    private(set) var audioDeviceID: AudioDeviceID
    
    var name: String {
        var name: [UInt8] = Array(repeating: 0, count: 128)
        var nameSize: UInt32 = 128
        var nameProp = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyDeviceName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster)

        guard AudioObjectGetPropertyData(
                audioDeviceID,
                &nameProp,
                0,
                nil,
                &nameSize,
                &name) == kAudioHardwareNoError else {
            return InputDevice.UnknownDeviceName
        }
        
        // Convert data to a AudioObjeectID collection
        return String(bytes: name, encoding: .utf8) ?? InputDevice.UnknownDeviceName
    }
    
    static func == (lhs: InputDevice, rhs: InputDevice) -> Bool {
        return lhs.audioDeviceID == rhs.audioDeviceID
    }
    
    init(audioDeviceID: AudioDeviceID) {
        self.audioDeviceID = audioDeviceID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(audioDeviceID)
    }
}

extension InputDevice : Muteable {
    func mute(mute: Bool) throws {
        var muteVal: UInt32 = mute ? 1 : 0;
        let muteSize = UInt32(MemoryLayout<UInt32>.size)
        
        var muteProp = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyMute,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: 0)
        
        guard AudioObjectSetPropertyData(
                audioDeviceID,
                &muteProp,
                0,
                nil,
                muteSize,
                &muteVal) == kAudioHardwareNoError else {
            throw HardwareError.audio
        }
    }
    
    func isMuted() throws -> Bool {
        var muted: UInt32 = 0;
        var mutedSize = UInt32(MemoryLayout<UInt32>.size)
        
        var muteProp = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyMute,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: 0)
        
        guard AudioObjectGetPropertyData(
                audioDeviceID,
                &muteProp,
                0,
                nil,
                &mutedSize,
                &muted) == kAudioHardwareNoError else {
            throw HardwareError.audio
        }

        return muted != 0;
    }
    
    
}

extension InputDevice : VolumeChangeable {
    static private var savedVolumes = [AudioDeviceID:Int32]()
    
    func setVolume(volume: Int32) throws {
        var volume = volume
        let volumeSize = UInt32(MemoryLayout<Int32>.size)
        
        var volumeProp = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar,
            mScope: kAudioObjectPropertyScopeInput,
            mElement: 0)
        
        guard AudioObjectSetPropertyData(
                audioDeviceID,
                &volumeProp,
                0,
                nil,
                volumeSize,
                &volume) == kAudioHardwareNoError else {
            throw HardwareError.audio
        }
    }
    
    func getVolume() throws -> Int32 {
        var volume: Int32 = 0;
        var volumeSize = UInt32(MemoryLayout<Int32>.size)
        
        var volumeProp = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar,
            mScope: kAudioObjectPropertyScopeInput,
            mElement: 0)
        
        guard AudioObjectGetPropertyData(
                audioDeviceID,
                &volumeProp,
                0,
                nil,
                &volumeSize,
                &volume) == kAudioHardwareNoError else {
            throw HardwareError.audio
        }

        return volume;
    }
    
    func silence() throws {
        guard InputDevice.savedVolumes[self.audioDeviceID] == nil else {
            return
        }
        InputDevice.savedVolumes[self.audioDeviceID] = try getVolume()
        try setVolume(volume: 0)
    }
    
    func restoreFromSilence() throws {
        if let volume = InputDevice.savedVolumes[self.audioDeviceID] {
            InputDevice.savedVolumes.removeValue(forKey: self.audioDeviceID)
            try setVolume(volume: volume)
        }
    }
    
    func isSilenced() -> Bool {
        if let _ = InputDevice.savedVolumes[self.audioDeviceID] {
            return true
        }
        
        return false
    }
}

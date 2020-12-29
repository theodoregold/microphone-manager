//
//  ConnectedInputDevices.swift
//  Microphone Manager
//
//  Created by David Morán on 26/12/20.
//

import Foundation
import CoreAudio

class ConnectedInputDevices {
    private static func supportInput(deviceID: AudioObjectID) -> Bool {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreamConfiguration,
            mScope: kAudioObjectPropertyScopeInput,
            mElement: kAudioObjectPropertyElementWildcard
        );
        
        var dataSize: UInt32 = 0
        guard AudioObjectGetPropertyDataSize(deviceID, &propertyAddress, 0, nil, &dataSize) == kAudioHardwareNoError else {
            return false
        }

        // Create a buffer to store buffer list
        let data = UnsafeMutableRawPointer.allocate(byteCount: Int(dataSize), alignment: MemoryLayout<Int>.alignment)
        defer {
            data.deallocate()
        }

        AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, nil, &dataSize, data);
        let bufferList = data.load(as: AudioBufferList.self)
        return bufferList.mNumberBuffers > 0
    }
    
    func inputDevices() throws -> Set<InputDevice> {
        // Property address to get all audio devices
        var propertyAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDevices, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementWildcard);
        
        // Get data size
        var dataSize: UInt32 = 0
        guard AudioObjectGetPropertyDataSize(UInt32(kAudioObjectSystemObject), &propertyAddress, 0, nil, &dataSize) == kAudioHardwareNoError else {
            throw HardwareError.audio
        }
        
        // Create a buffer to store retrieved data
        let data = UnsafeMutableRawPointer.allocate(byteCount: Int(dataSize), alignment: MemoryLayout<AudioObjectID>.alignment)
        defer {
            data.deallocate()
        }
        
        // Retrieve data
        guard AudioObjectGetPropertyData(UInt32(kAudioObjectSystemObject), &propertyAddress, 0, nil, &dataSize, data) == kAudioHardwareNoError else {
            throw HardwareError.audio
        }
        
        // Convert data to a AudioObjeectID collection
        let length = Int(dataSize) / MemoryLayout<AudioObjectID>.size;
        let devicesPtr = data.bindMemory(to: AudioObjectID.self, capacity: length)
        let devicesBuffer = UnsafeBufferPointer(start: devicesPtr, count: length)
        
        // Get all devices with input
        var inputDevices = Set<InputDevice>()
        for deviceID in devicesBuffer {
            if ConnectedInputDevices.supportInput(deviceID: deviceID) {
                inputDevices.insert(InputDevice(audioDeviceID: deviceID))
            }
        }
        
        return inputDevices
    }
}

//
//  VolumeManager.swift
//  Microphone Manager
//
//  Created by David Morán on 24/12/20.
//

import Foundation

protocol VolumeChangeable {
    func setVolume(volume: Int32) throws
    func getVolume() throws -> Int32

    func silence() throws
    func restoreFromSilence() throws
    
    func isSilenced() -> Bool
}

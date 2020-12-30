//
//  DefaultInputDevice.swift
//  Microphone Manager
//
//  Created by David Morán on 31/12/20.
//

protocol DefaultInputDevice {
    func isDefault() throws -> Bool
    func setDefault() throws
}

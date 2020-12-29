//
//  Mutable.swift
//  Microphone Manager
//
//  Created by David Morán on 24/12/20.
//

import Foundation


protocol Muteable {
    func mute(mute: Bool) throws
    func isMuted() throws -> Bool
}

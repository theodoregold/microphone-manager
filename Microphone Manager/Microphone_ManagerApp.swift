//
//  Microphone_ManagerApp.swift
//  Microphone Manager
//
//  Created by David Morán on 24/12/20.
//

import SwiftUI
import HotKey
import AVFoundation
import CoreFoundation
import Foundation

@main
struct Microphone_ManagerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    @AppStorage("enableKeyBinding") var enableKeyBinding: Bool = false
    var connectedInputDevicesState: ConnectedInputDevicesState?
    var popover = NSPopover.init()
    var statusBarItem: NSStatusItem?
    var hotKey: HotKey? = nil
    var preferencesWindow: NSWindow!
    
    @objc func openPreferencesWindow() {
        if nil == preferencesWindow {      // create once !!
            let preferencesView = SettingsView()
            // Create the preferences window and set content
            preferencesWindow = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            preferencesWindow.center()
            preferencesWindow.setFrameAutosaveName("Preferences")
            preferencesWindow.isReleasedWhenClosed = false
            preferencesWindow.contentView = NSHostingView(rootView: preferencesView)
        }
        preferencesWindow.makeKeyAndOrderFront(nil)
    }
    
    func askForPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized: // The user has previously granted access to the camera.
                DispatchQueue.main.async {
                    self.connectedInputDevicesState = try! ConnectedInputDevicesState()
                    self.permissionsGranted()
                }
                return
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.connectedInputDevicesState = try! ConnectedInputDevicesState()
                            self.permissionsGranted()
                        }
                        return
                    } else {
                        exit(0)
                    }
                }
            case .denied: // The user has previously denied access.
                exit(0)

            case .restricted: // The user can't grant access due to restrictions.
                exit(0)
                
            default:
                DispatchQueue.main.async {
                    self.connectedInputDevicesState = try! ConnectedInputDevicesState()
                    self.permissionsGranted()
                }
                return
        }
    }
    
    private func permissionsGranted() {
        let contentView = ContentView(connectedInputDevicesState: self.connectedInputDevicesState!)

        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.behavior = .transient // !!! - This does not seem to work in SwiftUI2.0 or macOS BigSur yet
        popover.animates = false
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: contentView)
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: nil)
        statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
        
        UserDefaults.standard.addObserver(self, forKeyPath: "enableKeyBinding", options: .new, context: nil)
        self.registerHotKey()
   
        self.connectedInputDevicesState!.onChange = {_ in
            if self.connectedInputDevicesState!.isMuted() {
                self.statusBarItem?.button?.image = NSImage(systemSymbolName: "mic.slash.fill", accessibilityDescription: nil)
            } else {
                self.statusBarItem?.button?.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: nil)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        registerHotKey()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        askForPermissions()
    }

    @objc func showPopover(_ sender: AnyObject?) {
        if let button = statusBarItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    @objc func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    @objc func registerHotKey() {
        if enableKeyBinding {
            hotKey = HotKey(key: .m, modifiers: [.command, .option])
            hotKey?.keyDownHandler = {
                if let muted = self.connectedInputDevicesState?.isMuted() {
                    self.connectedInputDevicesState?.setMute(mute: !muted)
                }
            }
        } else {
            hotKey = nil
        }
    }
}

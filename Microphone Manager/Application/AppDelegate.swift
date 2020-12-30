
import Foundation
import SwiftUI
import HotKey
import AVFoundation

class AppDelegate: NSObject, NSApplicationDelegate {
    @AppStorage("enableKeyBinding") var enableKeyBinding: Bool = false
    private var windows: [String: NSWindow] = [:]
    private var hotKey: HotKey?

    var connectedInputDevicesState: ConnectedInputDevicesState?
    var popover = NSPopover.init()
    var statusBarItem: NSStatusItem?
    var preferencesWindow: NSWindow!
    var aboutWindow: NSWindow!
    

    private func permissionsGranted() {
        register()
        
        UserDefaults.standard.addObserver(self, forKeyPath: "enableKeyBinding", options: .new, context: nil)
        self.toggleHotKey()

        self.connectedInputDevicesState!.onChange = {_ in
            if self.connectedInputDevicesState!.isMuted() {
                self.statusBarItem?.button?.image = NSImage(systemSymbolName: "mic.slash.fill", accessibilityDescription: nil)
            } else {
                self.statusBarItem?.button?.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: nil)
            }
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        hideFromDock()
        checkPermissions()
    }
}

extension AppDelegate {
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized:
                DispatchQueue.main.async {
                    self.connectedInputDevicesState = try! ConnectedInputDevicesState()
                    self.permissionsGranted()
                }
                return
            
            case .notDetermined:
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
            case .denied:
                exit(0)

            case .restricted:
                exit(0)
                
            default:
                DispatchQueue.main.async {
                    self.connectedInputDevicesState = try! ConnectedInputDevicesState()
                    self.permissionsGranted()
                }
                return
        }
    }
}

// For opening external windows
extension AppDelegate {
    private func openWindow<T>(windowTitle: String, viewType: T.Type) where T: View, T: Initializable {
        if windows[windowTitle] == nil {
            let view = viewType.init()

            let window = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            window.center()
            window.setFrameAutosaveName(windowTitle)
            window.isReleasedWhenClosed = false
            window.contentView = NSHostingView(rootView: view)
            
            windows[windowTitle] = window
        }
        windows[windowTitle]?.makeKeyAndOrderFront(nil)
    }
    
    @objc func openPreferencesWindow() {
        self.openWindow(windowTitle: "Microphone Manager Preferences...", viewType: SettingsView.self)
    }
    
    @objc func openAboutWindow() {
        self.openWindow(windowTitle: "About", viewType: AboutView.self)
    }
}

// Manage HotKey
extension AppDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "enableKeyBinding" {
            toggleHotKey()
        }
    }
    
    private func toggleHotKey() {
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

// Drop-Down menu
extension AppDelegate {
    private func register() {
        registerPopover()
        registerStatusItem()
    }
    
    private func registerPopover() {
        let contentView = ContentView(connectedInputDevicesState: self.connectedInputDevicesState!)

        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: contentView)
    }
    
    private func registerStatusItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: nil)
        statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
    }
    
    @objc private func showPopover(_ sender: AnyObject?) {
        if let button = statusBarItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    @objc private func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }

    @objc private func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}

// Hide from Dock
extension AppDelegate {
    private func hideFromDock() {
        NSApp.setActivationPolicy(.accessory)
    }
}

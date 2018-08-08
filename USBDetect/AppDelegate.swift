//
//  AppDelegate.swift
//  USBDetect
//
//  Created by Keaton Burleson on 7/23/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Cocoa
import IOKit
import IOKit.usb
import IOKit.hid

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, USBWatcherDelegate, NSUserNotificationCenterDelegate {
    @IBOutlet weak var statusMenu: NSMenu!

    var usbWatcher: USBWatcher? = nil
    var separator: NSMenuItem? = nil
    var visibleDevices: [String:Int] = [:]

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.menu = statusMenu
        statusItem.image = icon

        usbWatcher = USBWatcher(delegate: self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func deviceAdded(_ device: io_object_t) {
        print("Device added: \(device.name()!)")
        showUSBConnectedNotification(deviceName: device.name()!)
        
        if (separator == nil) {
            separator = NSMenuItem.separator()
            statusMenu.addItem(separator!)
        }
        let newItem = NSMenuItem(title: device.name()!, action: nil, keyEquivalent: String())
        statusMenu.addItem(newItem)
        visibleDevices[device.name()!] = statusMenu.index(of: newItem)
    }

    func deviceRemoved(_ device: io_object_t) {
        guard let menuItemIndex = (visibleDevices[device.name()!])
            else{
                print("Menu item not found")
                return
        }
        statusMenu.removeItem(at: menuItemIndex)
        print("Device removed: \(device.name()!)")
    }

    func showUSBConnectedNotification(deviceName: String) -> Void {
        if (!deviceName.contains("Hub") && !deviceName.contains("Internal") && !deviceName.contains("Host") && !deviceName.contains("Simulation")) {
            let notification = NSUserNotification()
            notification.title = "USB Device Connected"
            notification.soundName = NSUserNotificationDefaultSoundName
            notification.subtitle = deviceName
            NSUserNotificationCenter.default.deliver(notification)
        }
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}

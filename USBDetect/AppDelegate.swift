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
    var separator: NSMenuItem? = nil

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var usbWatcher: USBWatcher? = nil
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }


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
    }

    func deviceRemoved(_ device: io_object_t) {
        print("Device removed: \(device.name()!)")
    }

    func showUSBConnectedNotification(deviceName: String) -> Void {
        if (!deviceName.contains("Hub") && !deviceName.contains("Internal")  && !deviceName.contains("Host")) {
            let notification = NSUserNotification()
            notification.title = "USB Device Connected"
            notification.soundName = NSUserNotificationDefaultSoundName
            notification.subtitle = deviceName
            NSUserNotificationCenter.default.deliver(notification)
        }
        
        if (separator == nil){
            separator = NSMenuItem.separator()
            statusMenu.addItem(separator!)
        }
        statusMenu.addItem(withTitle: deviceName, action: nil, keyEquivalent: String())
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

}


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
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.menu = statusMenu
        statusItem.image = icon
        
        let deviceMonitor = USBDetector()
        deviceMonitor.monitorUSBEvent()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    


}


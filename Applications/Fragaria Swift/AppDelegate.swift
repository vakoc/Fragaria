//
//  AppDelegate.swift
//  Fragaria Swift
//
//  Created by Daniele Cattaneo on 04/12/15.
//
//

import Cocoa
import Fragaria


@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {

    
var prefsWindow: MASPreferencesWindowController!
    

func applicationWillFinishLaunching(_ aNotification: Notification) {
    var shc: MGSUserDefaultsController
    var tmp: Set<AnyHashable>
    
    shc = MGSUserDefaultsController.shared()
    tmp = shc.managedProperties as Set<AnyHashable>
    tmp.remove(MGSFragariaDefaultsSyntaxDefinitionName)
    shc.managedProperties = tmp
    shc.isPersistent = true
}
    
    
@IBAction func openPreferences(_ sender: AnyObject) {
    var c: Array<MGSPrefsViewController>
    var color, editor: MGSPrefsViewController
    
    if prefsWindow == nil {
        color = MGSPrefsColourPropertiesViewController()
        editor = MGSPrefsEditorPropertiesViewController()
        c = [color, editor]
        prefsWindow = MASPreferencesWindowController(viewControllers: c)
    }
    prefsWindow.showWindow(self)
}

    
}


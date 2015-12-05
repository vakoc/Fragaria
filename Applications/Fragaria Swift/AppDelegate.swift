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
    

func applicationWillFinishLaunching(aNotification: NSNotification) {
    var shc: MGSUserDefaultsController
    var tmp: Set<NSObject>
    
    shc = MGSUserDefaultsController.sharedController()
    tmp = shc.managedProperties
    tmp.remove(MGSFragariaDefaultsSyntaxDefinitionName)
    shc.managedProperties = tmp
    shc.persistent = true
}
    
    
@IBAction func openPreferences(sender: AnyObject) {
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


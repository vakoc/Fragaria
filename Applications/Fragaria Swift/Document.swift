//
//  Document.swift
//  Fragaria Swift
//
//  Created by Daniele Cattaneo on 04/12/15.
//
//

import Cocoa
import Fragaria


class Document: NSDocument {
    
    
@IBOutlet var fragaria: MGSFragariaView!;


override init() {
    super.init()
}


override func windowControllerDidLoadNib(aController: NSWindowController) {
    super.windowControllerDidLoadNib(aController)
    fragaria.syntaxDefinitionName = "Objective-C"
    fragaria.syntaxColoured = true
    fragaria.showsLineNumbers = true
    fragaria.string = "// This is the future"
    self.undoManager = fragaria.undoManager
    MGSUserDefaultsController.sharedController().addFragariaToManagedSet(fragaria)
}
    
    
deinit {
    MGSUserDefaultsController.sharedController().removeFragariaFromManagedSet(fragaria)
}


override class func autosavesInPlace() -> Bool {
    return true
}

    
override var windowNibName: String? {
    return "Document"
}

    
override func dataOfType(typeName: String) throws -> NSData {
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
}

    
override func readFromData(data: NSData, ofType typeName: String) throws {
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
}


}


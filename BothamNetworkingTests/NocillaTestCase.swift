//
//  NocillaTestCase.swift
//  BothamNetworking
//
//  Created by Pedro Vicente Gomez on 20/11/15.
//  Copyright © 2015 GoKarumi S.L. All rights reserved.
//

import Foundation
import XCTest
import Nocilla

class NocillaTestCase: XCTestCase {

    let nocilla: LSNocilla = LSNocilla.sharedInstance()

    override func setUp() {
        super.setUp()
        nocilla.start()
    }

    override func tearDown() {
        nocilla.clearStubs()
        nocilla.stop()
        super.tearDown()
    }

    func fromJsonFile(fileName: String) -> String {
        let classBundle = NSBundle(forClass: self.classForCoder)
        let path = classBundle.pathForResource(fileName, ofType: "json")
        let absolutePath =  path ?? ""
        do {
            return try String(contentsOfFile: absolutePath, encoding: NSUTF8StringEncoding)
        } catch _ {
            print("Error trying to read file \(absolutePath). The file does not exist")
            return ""
        }
    }

}
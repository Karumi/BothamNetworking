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

    func fromJsonFile(_ fileName: String) -> String {
        let classBundle = Bundle(for: self.classForCoder)
        let path = classBundle.path(forResource: fileName, ofType: "json")
        let absolutePath =  path ?? ""
        do {
            return try String(contentsOfFile: absolutePath, encoding: String.Encoding.utf8)
        } catch _ {
            print("Error trying to read file \(absolutePath). The file does not exist")
            return ""
        }
    }

}

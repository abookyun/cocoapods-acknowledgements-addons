//
//  AppTests.swift
//  AppTests
//
//  Created by Ben on 14/05/2019.
//  Copyright © 2019 bcylin. All rights reserved.
//

import XCTest

final class AppTests: XCTestCase {

  func testAcknowledgementsPlist() {
    let resourcePath = URL(string: Bundle.main.resourcePath!)!
    let plistPath = resourcePath.appendingPathComponent("Pods-App-metadata.plist")

    let dictionary = NSDictionary(contentsOfFile: plistPath.absoluteString)!
    let acknowledgements = (dictionary["specs"] as! [[String: Any]]).map { $0["name"] } as? [String]

    XCTAssertEqual(acknowledgements, ["Alamofire", "CPDAcknowledgements", "Crypto", "Strongify"])
  }

}
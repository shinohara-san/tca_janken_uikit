//
//  Tests.swift
//  Tests
//
//  Created by shinohara.yuki.2250 on 2023/03/25.
//

import XCTest
@testable import tca_janken_uikit
import ComposableArchitecture

final class Tests: XCTestCase {
    func testJudge() {
        var result = judge(mine: .gu, computer: .choki)
        XCTAssertEqual(.win, result)
        result = judge(mine: .gu, computer: .gu)
        XCTAssertEqual(.draw, result)
        result = judge(mine: .gu, computer: .pa)
        XCTAssertEqual(.lose, result)
        // choki, pa
    }

    func testDrawComputerHand() {
        var img = drawComputerHand(.gu)
        XCTAssertEqual(UIImage(named:"janken_gu")!, img)
        img = drawComputerHand(.choki)
        XCTAssertEqual(UIImage(named:"janken_choki")!, img)
        img = drawComputerHand(.pa)
        XCTAssertEqual(UIImage(named:"janken_pa")!, img)
    }
}

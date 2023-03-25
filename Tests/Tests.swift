//
//  Tests.swift
//  Tests
//
//  Created by shinohara.yuki.2250 on 2023/03/25.
//

import XCTest
@testable import tca_janken_uikit
import ComposableArchitecture

@MainActor
final class Tests: XCTestCase {
    var store: TestStore<Janken.State, Janken.Action, Janken.State, Janken.Action, ()>? = nil

    override func setUpWithError() throws {
        store = TestStore(
            initialState: Janken.State(),
            reducer: Janken()
        )
    }

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

    func testJudge() async {
        await store?.send(.judge(myHand: .gu, comHand: .choki)) {
            $0.score = 1
            $0.isShowingAlert = false
            $0.alertMessage = nil
        }
    }

    func testAlert() async {
        await store?.send(.showAlert(message: "勝ち！")) {
            $0.isShowingAlert = true
            $0.alertMessage = "勝ち！"
        }

        await store?.send(.dismissAlert) {
            $0.isShowingAlert = false
            $0.alertMessage = nil
            $0.image = UIImage(named: "janken_top")
        }
    }

    func testReset() async {
        await store?.send(.showActionSheet) {
            $0.isShowingActionSheet = true
        }

        await store?.send(.dismissActionSheet) {
            $0.isShowingActionSheet = false
        }

        await store?.send(.showActionSheet) {
            $0.isShowingActionSheet = true
        }

        await store?.send(.resetScore) {
            $0 = Janken.State()
        }
    }
}

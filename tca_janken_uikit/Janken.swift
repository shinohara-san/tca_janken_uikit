//
//  Janken.swift
//  tca_janken_uikit
//
//  Created by shinohara.yuki.2250 on 2023/03/25.
//
import UIKit
import ComposableArchitecture

struct Janken: ReducerProtocol {

    struct State: Equatable {
        var image = UIImage(named: "janken_top")
    }

    enum Action: Equatable {
        case myHandTapped(Hand)
        case judge(myHand: Hand, comHand: Hand)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .myHandTapped(let myHand):
            let comHand = makeComputerHand()
            state.image = drawComputerHand(comHand)
            return .send(.judge(myHand: myHand, comHand: comHand))
        case .judge(let myHand, let comHand):
            let result = judge(mine: myHand, computer: comHand)
            switch result {
            case .win:
                print("win")
            case .lose:
                print("lose")
            case .draw:
                print("draw")
            }
            return .none
        }
    }
}

enum Hand: Int, Equatable {
    case gu
    case choki
    case pa
}

func makeComputerHand() -> Hand {
    Hand(rawValue: Int.random(in: 0...2))!
}

func drawComputerHand(_ hand: Hand) -> UIImage {
    let img: UIImage
    switch hand {
    case .gu:
        img = UIImage(named:"janken_gu")!
    case .choki:
        img = UIImage(named:"janken_choki")!
    case .pa:
        img = UIImage(named:"janken_pa")!
    }
    return img
}

func judge(mine: Hand, computer: Hand) -> JankenResult {
    if mine == computer {
        return .draw
    }

    if mine.rawValue == 0 {
        if computer.rawValue == 1 {
            return .win
        } else {
            return .lose
        }
    }

    if mine.rawValue == 1 {
        if computer.rawValue == 0 {
            return .lose
        } else {
            return .win
        }
    }

    if mine.rawValue == 2 {
        if computer.rawValue == 0 {
            return .win
        } else {
            return .lose
        }
    }

    fatalError("Unexpected judge")
}

enum JankenResult {
    case win, lose, draw
}

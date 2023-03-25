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
        var result = UIImage(named: "janken_top")
    }

    enum Action: Equatable {
        case guTapped
        case chokiTapped
        case paTapped
        case judge
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
      switch action {
      case .guTapped:
        return .none
      case .chokiTapped:
        return .none
      case .paTapped:
        return .none
      case .judge:
          return .none
      }
    }
}

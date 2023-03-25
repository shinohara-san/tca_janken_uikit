//
//  ViewController.swift
//  tca_janken_uikit
//
//  Created by shinohara.yuki.2250 on 2023/03/25.
//

import UIKit
import Combine
import ComposableArchitecture

class JankenViewController: UIViewController {

    private let viewStore: ViewStoreOf<Janken> = ViewStore(Store(initialState: Janken.State(), reducer: Janken())) // TODO: should be injected through init
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewStore.publisher
            .map { $0.image }
            .assign(to: \.image, on: imageView)
            .store(in: &cancellables)
    }

    @IBAction private func didTapGu(_ sender: UIButton) {
        viewStore.send(.myHandTapped(.gu))
    }

    @IBAction private func didTapChoki(_ sender: UIButton) {
        viewStore.send(.myHandTapped(.choki))
    }

    @IBAction private func didTapPa(_ sender: UIButton) {
        viewStore.send(.myHandTapped(.pa))
    }
}


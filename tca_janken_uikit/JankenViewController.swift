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

    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewStore.publisher
            .map { $0.image }
            .assign(to: \.image, on: imageView)
            .store(in: &cancellables)
        
        self.viewStore.publisher
            .map(\.isShowingAlert)
            .removeDuplicates()
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in self?.presentAlert() })
            .store(in: &cancellables)

        self.viewStore.publisher
            .map { "現在の得点: \($0.score)" }
            .assign(to: \.text, on: scoreLabel)
            .store(in: &cancellables)

        self.viewStore.publisher
            .map(\.isShowingActionSheet)
            .removeDuplicates()
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in self?.presentActionSheet()})
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

    @IBAction func didTapReset(_ sender: UIButton) {
        viewStore.send(.showActionSheet)
    }

    private func presentAlert() {
        let alert = UIAlertController(title: "結果",
                                      message: viewStore.state.alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in self.viewStore.send(.dismissAlert) }))
        present(alert, animated: true)
    }

    private func presentActionSheet() {
        let sheet = UIAlertController(title: "得点のリセット",
                                      message: "この操作は戻せません",
                                      preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "リセットする",
                                      style: .destructive,
                                      handler: { _ in self.viewStore.send(.resetScore) }))

        sheet.addAction(UIAlertAction(title: "しない",
                                      style: .default,
                                      handler: { _ in self.viewStore.send(.dismissActionSheet) }))

        present(sheet, animated: true)
    }
}


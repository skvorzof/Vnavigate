//
//  HomeViewController.swift
//  Vnavigate
//
//  Created by Dima Skvortsov on 03.02.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    private let coordinator: HomeCoordinator
    private let viewModel: HomeViewModel

    init(coordinator: HomeCoordinator, viewModel: HomeViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewModel()
        viewModel.changeState(.initial)
    }

    private func configureViewModel() {
        viewModel.updateState = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .initial:
                break
            case .loading:
                break
            case .loaded:
                break
            case .error(let error):
                print(error)
            }
        }
    }
}

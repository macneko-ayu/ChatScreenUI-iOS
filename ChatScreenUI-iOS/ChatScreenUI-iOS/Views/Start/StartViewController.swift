//
//  StartViewController.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/23.
//  Copyright © 2018年 macneko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StartViewController: UIViewController {

    @IBOutlet weak private var transitionButton: UIButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sample"

        transitionButton.rx.tap.subscribe { [weak self] _ in
            self?.mockTransition()
        }
        .disposed(by: disposeBag)
    }

    private func mockTransition() {
        // usersをInjectionする
        let mockUsers = [
            User(id: 1, name: "macneko"),
            User(id: 2, name: "Leno")
        ]
        let dependency = ChatScreenViewController.Dependency(users: mockUsers)
        let viewController = ChatScreenViewController.make(withDependency: dependency)
        navigationController?.pushViewController(viewController, animated: true)
    }

}

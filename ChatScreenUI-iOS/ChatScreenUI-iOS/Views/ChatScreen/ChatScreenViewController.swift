//
//  ChatScreenViewController.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/08.
//  Copyright © 2018年 macneko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatScreenViewController: UIViewController {

    @IBOutlet private weak var inputMessageView: InputMessageView!
    @IBOutlet private weak var inputVIewHeightConstraint: NSLayoutConstraint!

    var viewModel: InputMessageViewModel?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelSetup()
    }

    private func viewModelSetup() {
        let viewModel = InputMessageViewModel(inputText: inputMessageView.textView.rx.text.orEmpty.asDriver())

        viewModel.isInputtedMessage.drive(onNext: { [weak self] isInputted in
            guard let self = self else { return }
            self.inputMessageView.sendButton.isEnabled = isInputted
            self.inputMessageView.placeholderLabel.isHidden = isInputted
            if !isInputted {
                let defaultInputViewHeight: CGFloat = 44
                self.inputVIewHeightConstraint.constant = defaultInputViewHeight
            }
        })
        .disposed(by: disposeBag)

        inputMessageView.textView.rx.observeWeakly(CGSize.self, "contentSize")
            .skip(1)
            .subscribe(onNext: { [weak self] contentSize in

            guard let self = self else { return }
            guard let contentSizeHeight = contentSize?.height else { return }

            let maxInputViewHeight: CGFloat = UIScreen.main.bounds.height / 4
            let padding: CGFloat = 27

            if self.inputVIewHeightConstraint.constant < maxInputViewHeight - padding {
                self.inputVIewHeightConstraint.constant = contentSizeHeight + padding
            }

            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
        .disposed(by: disposeBag)

        self.viewModel = viewModel
    }
}

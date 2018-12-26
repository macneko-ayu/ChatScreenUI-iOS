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

final class ChatScreenViewController: UIViewController, DependencyInjectable {

    struct Dependency {
        let users: [User]
    }

    private var users: [User]!

    static func make(withDependency dependency: Dependency) -> ChatScreenViewController {
        //swiftlint:disable:next force_cast
        let viewController = UIStoryboard(name: "ChatScreen", bundle: nil).instantiateInitialViewController() as! ChatScreenViewController
        viewController.users = dependency.users
        return viewController
    }

    @IBOutlet private weak var inputMessageView: InputMessageView!
    @IBOutlet private weak var inputVIewHeight: NSLayoutConstraint!
    @IBOutlet private weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.keyboardDismissMode = .onDrag
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.estimatedRowHeight = TextMessageCell.defaultHeight
            tableView.rowHeight = UITableView.automaticDimension
            tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            TextMessageCell.register(to: tableView)
        }
    }

    private var viewModel: ChatScreenViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat screen"
        setupViewModel()
        setupRx()
    }
}

extension ChatScreenViewController {

    private func setupViewModel() {
        guard let textView = inputMessageView.textView,
            let sendButton = inputMessageView.sendButton else { return }
        let viewModel = ChatScreenViewModel(
            input: (
                inputtingText: textView.rx.text.orEmpty.asDriver(),
                sendButtonTap: sendButton.rx.tap.asDriver()
            ),
            dependency: users
        )
        self.viewModel = viewModel
    }

    private func setupRx() {
        self.viewModel?.inputMessageViewModel.isInputtedMessage.drive(onNext: { [weak self] isInputted in
            guard let self = self else { return }
            self.inputMessageView.sendButton.isEnabled = isInputted
            self.inputMessageView.placeholderLabel.isHidden = isInputted
            if !isInputted {
                let defaultInputViewHeight: CGFloat = 44
                self.inputVIewHeight.constant = defaultInputViewHeight
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

                if self.inputVIewHeight.constant < maxInputViewHeight - padding {
                    self.inputVIewHeight.constant = contentSizeHeight + padding
                    self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x,
                                                           y: self.tableView.contentOffset.y + padding)
                }

                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                guard let self = self else { return }
                guard let userInfo = notification.userInfo else { return }
                guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let keyboardFrame = value.cgRectValue
                self.inputViewBottom.constant = keyboardFrame.height
                UIView.animate(withDuration: 0.3, animations: {
                    if self.inputMessageView.textView.text.count == 0 {
                        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x,
                                                               y: self.tableView.contentOffset.y + keyboardFrame.height)
                    }
                    self.view.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.inputViewBottom.constant = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)

        viewModel?.messageTableViewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: TextMessageCell.reuseIdentifier, cellType: TextMessageCell.self)) { [weak self] _, element, cell in
                guard let currentUser = self?.viewModel?.currentUser() else { return }
                cell.configure(message: element, isCurrentUser: element.user == currentUser)
            }
            .disposed(by: disposeBag)

        viewModel?.messageTableViewModel.items.asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] messages in
                if messages.count > 0 {
                    self?.tableView.reloadData()
                    DispatchQueue.main.async {
                        self?.tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: false)
                    }
                }
            })
            .disposed(by: disposeBag)

        // サンプル用にMockのメッセージ群を追加
        viewModel?.messageTableViewModel.addMockMessages()
    }
}

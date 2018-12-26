//
//  ChatScreenViewModel.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/14.
//  Copyright © 2018年 macneko. All rights reserved.
//

import RxSwift
import RxCocoa

class ChatScreenViewModel {

    typealias Input = (
        inputtingText: Driver<String>,
        sendButtonTap: Driver<Void>
    )

    let inputMessageViewModel: InputMessageViewModel
    let messageTableViewModel: MessageTableViewModel
    private let users: [User]

    init(input: Input,
         dependency users: [User]) {
        self.users = users
        self.inputMessageViewModel = InputMessageViewModel(input: input.inputtingText)
        self.messageTableViewModel = MessageTableViewModel(
            input: (
                sendButtonTap: input.sendButtonTap,
                inputtedMessage: self.inputMessageViewModel.inputtedMessage
            ),
            dependency: self.users[0]
        )
    }
}

extension ChatScreenViewModel {
    func currentUser() -> User {
        return users[0]
    }
}

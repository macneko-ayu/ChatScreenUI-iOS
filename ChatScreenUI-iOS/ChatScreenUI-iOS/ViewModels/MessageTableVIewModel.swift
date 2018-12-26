//
//  MessageTableViewModel.swift
//  ChatScreenUI-iOS
//
//  Created by Kojiro Yokota on 2018/12/18.
//  Copyright © 2018年 macneko. All rights reserved.
//

import RxSwift
import RxCocoa

class MessageTableViewModel {

    typealias Input = (
        sendButtonTap: Driver<Void>,
        inputtedMessage: BehaviorRelay<String>
    )

    private let _items = BehaviorRelay<[Message]>(value: [])
    let items: Observable<[Message]>

    private let disposeBag = DisposeBag()

    init(input: Input,
         dependency currentUser: User) {
        self.items = _items.asObservable()
        setupRx(input: input, currentUser: currentUser)
    }
}

extension MessageTableViewModel {

    private func setupRx(input: Input, currentUser: User) {
        input.sendButtonTap
            .drive(onNext: { [weak self] _ in

                let inputtedMessage = input.inputtedMessage.value
                guard let itemsCount = self?._items.value.count,
                 !inputtedMessage.isEmpty else { return }

                let message = Message(id: itemsCount, user: currentUser, createdAt: Date(), text: inputtedMessage)
                self?.addMessage(message: message)
            })
            .disposed(by: disposeBag)
    }

    // Mock用のMessageを作成
    func addMockMessages() {
        let currentUser = User(id: 1, name: "macneko")
        let otherUser = User(id: 2, name: "Leno")

        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm:ss"

        let messages = [
            Message(id: 1, user: otherUser, createdAt: dateFormater.date(from: "2018/12/20 12:00:00") ?? Date(), text: "こんにちは、macneko!"),
            Message(id: 2, user: currentUser, createdAt: dateFormater.date(from: "2018/12/20 12:10:00") ?? Date(), text: "こんにちは、Leno!"),
            Message(id: 3, user: otherUser, createdAt: dateFormater.date(from: "2018/12/21 09:00:00") ?? Date(), text: "おなかがすいたのでご飯をください"),
            Message(id: 4, user: currentUser, createdAt: dateFormater.date(from: "2018/12/21 13:00:00") ?? Date(), text: "さっき食べたよね？"),
            Message(id: 5, user: otherUser, createdAt: dateFormater.date(from: "2018/12/22 08:00:00") ?? Date(), text: "おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。おなかがすいたのでご飯をください。"),
            Message(id: 6, user: currentUser, createdAt: dateFormater.date(from: "2018/12/22 08:21:00") ?? Date(), text: "さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？さっき食べたよね？"),
            Message(id: 7, user: currentUser, createdAt: dateFormater.date(from: "2018/12/22 09:00:00") ?? Date(), text: "あげるから静かにしてなさい")
        ]
        _items.accept(messages)
    }

    func addMessage(message: Message) {
        var originalItems = _items.value
        originalItems.append(message)
        _items.accept(originalItems)
    }
}

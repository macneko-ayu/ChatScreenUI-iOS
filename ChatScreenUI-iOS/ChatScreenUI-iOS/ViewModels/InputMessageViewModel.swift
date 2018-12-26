//
//  InputMessageViewModel.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/15.
//  Copyright © 2018年 macneko. All rights reserved.
//

import RxSwift
import RxCocoa

class InputMessageViewModel {

    let isInputtedMessage: Driver<Bool>
    let inputtedMessage = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()

    init(input inputtingText: Driver<String>) {
        self.isInputtedMessage = inputtingText.map { $0.count > 0 }.asDriver()

        inputtingText.asObservable()
            .bind(to: inputtedMessage)
            .disposed(by: disposeBag)
    }
}

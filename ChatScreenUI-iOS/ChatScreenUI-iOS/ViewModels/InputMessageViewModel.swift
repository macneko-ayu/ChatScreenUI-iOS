//
//  InputMessageViewModel.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/15.
//  Copyright © 2018年 macneko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct InputMessageViewModel {

    let isInputtedMessage: Driver<Bool>

    init(inputText: Driver<String>) {
        self.isInputtedMessage = inputText.map { $0.count > 0 }.asDriver()
    }
}

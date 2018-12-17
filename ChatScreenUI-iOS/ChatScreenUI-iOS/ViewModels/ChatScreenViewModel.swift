//
//  ChatScreenViewModel.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/14.
//  Copyright © 2018年 macneko. All rights reserved.
//

import RxSwift
import RxCocoa

struct ChatScreenViewModel {

    let inputMessageViewModel: InputMessageViewModel

    init(input inputText: Driver<String>) {
        self.inputMessageViewModel = InputMessageViewModel(input: inputText)
    }
}

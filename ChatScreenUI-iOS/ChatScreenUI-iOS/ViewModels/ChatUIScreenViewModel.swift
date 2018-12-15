//
//  ChatUIScreenViewModel.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/14.
//  Copyright © 2018年 macneko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ChatUIScreenViewModel {

    let isEmpty: Driver<Bool>


    init(inputText: Driver<String>) {
        self.isEmpty = inputText.map { $0.count == 0 }.asDriver()
    }

}

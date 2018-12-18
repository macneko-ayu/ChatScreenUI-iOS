//
//  User.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/18.
//  Copyright © 2018年 macneko. All rights reserved.
//

import Foundation

struct User: Equatable {
    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

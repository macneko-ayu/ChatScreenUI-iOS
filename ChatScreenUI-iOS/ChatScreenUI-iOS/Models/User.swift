//
//  User.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/18.
//  Copyright © 2018年 macneko. All rights reserved.
//

import Foundation

struct User {
    
    let id: Int
    let name: String
    let icon: UserIcon

    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.icon = UserIcon(initials: self.name)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

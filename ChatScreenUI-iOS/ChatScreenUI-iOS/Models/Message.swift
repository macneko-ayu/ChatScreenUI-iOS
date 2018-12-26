//
//  Message.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/18.
//  Copyright © 2018年 macneko. All rights reserved.
//

import Foundation

enum MessageKind {
    case text(String)
}

struct Message {
    let id: Int
    let user: User
    let createdAt: Date
    let kind: MessageKind

    private init(id: Int, user: User, createdAt: Date, kind: MessageKind) {
        self.id = id
        self.user = user
        self.createdAt = createdAt
        self.kind = kind
    }

    init(id: Int, user: User, createdAt: Date, text: String) {
        self.init(id: id, user: user, createdAt: createdAt, kind: .text(text))
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}

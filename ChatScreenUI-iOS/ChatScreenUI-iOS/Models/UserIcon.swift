//
//  UserIcon.swift
//  ChatScreenUI-iOS
//
//  Created by Kojiro Yokota on 2018/12/18.
//  Copyright © 2018年 macneko. All rights reserved.
//

import Foundation

struct UserIcon {
    let initials: String

    init(initials: String = "?") {
        self.initials = String(initials.prefix(1))
    }
}

//
//  DependencyInjectable.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/23.
//  Copyright © 2018年 macneko. All rights reserved.
//

protocol DependencyInjectable {
    associatedtype Dependency
    static func make(withDependency dependency: Dependency) -> Self
}

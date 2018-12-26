//
//  TextMessageCell.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/19.
//  Copyright © 2018年 macneko. All rights reserved.
//

import UIKit

class TextMessageCell: UITableViewCell {

    @IBOutlet weak var initialContainerView: UIView! {
        didSet {
            initialContainerView.layer.cornerRadius = cornerRadius
        }
    }
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var messageContaierView: UIView! {
        didSet {
            messageContaierView.layer.cornerRadius = cornerRadius
        }
    }
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet var initialContainerViewLeading: NSLayoutConstraint!
    @IBOutlet var initialContainerViewTrailing: NSLayoutConstraint!
    @IBOutlet var messageContainerViewLeading: NSLayoutConstraint!
    @IBOutlet var messageContainerViewTrailing: NSLayoutConstraint!
    @IBOutlet var timeLabelLeading: NSLayoutConstraint!
    @IBOutlet var timeLabelTrailing: NSLayoutConstraint!

    static let nibName = "TextMessageCell"
    static let reuseIdentifier = "TextMessageCell"

    let cornerRadius: CGFloat = 15
    let green = UIColor(red: 0, green: 200/255, blue: 0, alpha: 1)

    static let defaultHeight: CGFloat = 44

    private var message: Message?
    private var isCurrentUser: Bool = false

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if isCurrentUser {
            NSLayoutConstraint.deactivate([initialContainerViewLeading,
                                           messageContainerViewLeading,
                                           timeLabelLeading])
            NSLayoutConstraint.activate([initialContainerViewTrailing,
                                         messageContainerViewTrailing,
                                         timeLabelTrailing])
        } else {
            NSLayoutConstraint.deactivate([initialContainerViewTrailing,
                                           messageContainerViewTrailing,
                                           timeLabelTrailing])
            NSLayoutConstraint.activate([initialContainerViewLeading,
                                         messageContainerViewLeading,
                                         timeLabelLeading])
        }
    }
}

extension TextMessageCell {

    static func register(to tableView: UITableView) {
        let nib = UINib(nibName: self.nibName, bundle: Bundle(for: self))
        tableView.register(nib, forCellReuseIdentifier: "TextMessageCell")
    }

    func configure(message: Message, isCurrentUser: Bool) {
        self.message = message
        self.isCurrentUser = isCurrentUser

        initialLabel.text = message.user.icon.initials

        switch message.kind {
        case .text(let text):
            messageLabel.text = text
        }

        let fomatter = DateFormatter()
        fomatter.locale = Locale(identifier: "ja_JP")
        fomatter.dateStyle = .medium
        fomatter.timeStyle = .short
        timeLabel.text = fomatter.string(from: message.createdAt)

        if isCurrentUser {
            messageContaierView.backgroundColor = green
            initialContainerView.backgroundColor = green
            timeLabel.textAlignment = .right
        } else {
            messageContaierView.backgroundColor = UIColor.lightGray
            initialContainerView.backgroundColor = UIColor.lightGray
            timeLabel.textAlignment = .left
        }

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

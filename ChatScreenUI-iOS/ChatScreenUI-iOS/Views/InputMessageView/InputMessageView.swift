//
//  InputMessageView.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/09.
//  Copyright © 2018年 macneko. All rights reserved.
//

import UIKit

class InputMessageView: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var roundView: UIView! {
        didSet {
            roundView.layer.cornerRadius = 15
            roundView.layer.borderColor = UIColor.lightGray.cgColor
            roundView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var textView: UITextView! {
        didSet {
            let verticalInset = (textView.frame.height - textView.font!.pointSize) / 2
            let horizontalInset: CGFloat = 10
            textView.textContainerInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        }
    }
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
}

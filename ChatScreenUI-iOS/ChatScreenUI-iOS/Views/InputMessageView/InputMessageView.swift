//
//  InputMessageView.swift
//  ChatScreenUI-iOS
//
//  Created by 横田孝次郎 on 2018/12/09.
//  Copyright © 2018年 macneko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class InputMessageView: UIView {

    @IBOutlet weak private var backgroundView: UIView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var roundView: UIView! {
        didSet {
            roundView.layer.cornerRadius = 15
            roundView.layer.borderColor = UIColor.lightGray.cgColor
            roundView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var textView: UITextView! {
        didSet {
            let horizontalInset: CGFloat = 10
            textView.textContainerInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        }
    }
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.setImage(UIImage(named: "button-send-disable"), for: .normal)
            sendButton.setImage(UIImage(named: "button-send-enable"), for: .selected)
        }
    }
    @IBOutlet weak var placeholderLabel: UILabel!

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupRx()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        setupRx()
   }
}

extension InputMessageView {
    private func configure() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        //swiftlint:disable:next force_cast
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }

    private func setupRx() {
        sendButton.rx.tap.subscribe { [weak self] _ in
            self?.textView.text = ""
        }
        .disposed(by: disposeBag)
    }
}

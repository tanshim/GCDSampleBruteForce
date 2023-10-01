//
//  Extensions.swift
//  GCDSampleBruteForce
//
//  Created by Sultan on 17.08.2023.
//

import Foundation
import UIKit

extension String {
    var digits: String { return "0123456789" }
    var lowercase: String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase: String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters: String { return lowercase + uppercase }
    var digitsAndLetters: String { return digits + letters }
    var printable: String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

extension UITextField {
    func setLeftIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 25, y: 2.5, width: 25, height: 25))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 30, y: 0, width: 55, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }

    func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame:
                                    CGRect(x: 0, y: 0, width: padding,
                                           height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

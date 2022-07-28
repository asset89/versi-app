//
//  RoundedTextField.swift
//  versi-app
//
//  Created by Asset Ryskul on 16.07.2022.
//

import UIKit

class RoundedTextField: UITextField {
    override func awakeFromNib() {
        
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2784313725, green: 0.462745098, blue: 0.9019607843, alpha: 1)])
        attributedPlaceholder = placeholder
        layer.cornerRadius = layer.frame.height / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 71/255, green: 118/255, blue: 230/255, alpha: 1).cgColor
        backgroundColor = UIColor.white
        super.awakeFromNib()
        
    }
}

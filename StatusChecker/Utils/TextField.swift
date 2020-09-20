//
//  TextField.swift
//  StatusChecker
//
//  Created by Aurélien Haie on 24/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    // MARK: Properties
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    // MARK: - Lifecycle funcs
    
    init(withPlaceholder placehldr: String?) {
        super.init(frame: .zero)
        placeholder = placehldr
        clearButtonMode = .always
        backgroundColor = .appLightGray
        layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}

//
//  TextField.swift
//  PickWithMe
//
//  Created by Thomas Neuteboom on 23/03/2020.
//  Copyright © 2020 The App Capital. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    /// The horizontal padding left and right.
    let horizontalInset: CGFloat = 15.0
    
    /// The vertical padding top and bottom.
    let verticalInset: CGFloat = 15.0
    
    /// Returns the drawing rectangle for the text field’s text.
    ///
    /// - Parameter forBounds: The bounding rectangle of the receiver.
    override func textRect(forBounds: CGRect) -> CGRect
    {
        return forBounds.insetBy(dx: self.horizontalInset , dy: self.horizontalInset)
    }
    
    /// Returns the rectangle in which editable text can be displayed.
    ///
    /// - Parameter forBounds: The bounding rectangle of the receiver.
    override func editingRect(forBounds: CGRect) -> CGRect
    {
        return forBounds.insetBy(dx: self.horizontalInset , dy: self.horizontalInset)
    }
    
    /// Returns the drawing rectangle for the text field’s placeholder text
    ///
    /// - Parameter forBounds: The bounding rectangle of the receiver.
    override func placeholderRect(forBounds: CGRect) -> CGRect
    {
        return forBounds.insetBy(dx: self.horizontalInset, dy: self.horizontalInset)
    }
    
}

//
//  UIViewExtension.swift
//  ToDoApp
//
//  Created by 김지현 on 2022/08/08.
//

import Foundation
import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

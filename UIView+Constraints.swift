//
//  ConstraintsUtils.swift
//  bottom-sheet
//
//  Created by Bruno Lorenzo on 9/20/20.
//  Copyright © 2020 blorenzo. All rights reserved.
//

import UIKit

extension UIView {
    
    private func prepareView() {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func fillToSuperView(_ superView: UIView) {
        prepareView()
        
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}

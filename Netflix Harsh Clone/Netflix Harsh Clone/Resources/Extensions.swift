//
//  Extensions.swift
//  Netflix Harsh Clone
//
//  Created by My Mac Mini on 20/12/23.
//

import UIKit

extension String{
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    
    
}
 
 

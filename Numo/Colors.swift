//
//  Colors.swift
//  


import Foundation
import UIKit

class Colors {
    
    // coded out various colors that we tested to see which we preferred most
    let cyan = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor
    let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor
    let darkBlue = UIColor(red: 27.0/255.0, green: 37.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor
    let lighterBlue = UIColor(red: 0.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor
    
    let gl: CAGradientLayer
    
    init() {
        gl = CAGradientLayer()
        gl.colors = [ cyan , lighterBlue ]
        gl.locations = [ 0.0, 1.0 ]
    }
}
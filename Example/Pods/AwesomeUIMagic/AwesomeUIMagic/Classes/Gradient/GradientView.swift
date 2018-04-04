//
//  GradientView.swift
//  AwesomeUIMagic
//
//  Created by Evandro Harrison Hoffmann on 2/9/18.
//

import UIKit

@IBDesignable
open class GradientView: UIView {
    
    // MARK: - Inspectables
    
    @IBInspectable open var gradientTopColor: UIColor = UIColor.clear {
        didSet{
            addGradientLayer(gradientTopColor, middle: gradientMiddleColor, bottomColor: gradientBottomColor)
        }
    }
    
    @IBInspectable open var gradientMiddleColor: UIColor = UIColor.clear {
        didSet{
            addGradientLayer(gradientTopColor, middle: gradientMiddleColor, bottomColor: gradientBottomColor)
        }
    }
    
    @IBInspectable open var gradientBottomColor: UIColor = UIColor.clear {
        didSet{
            addGradientLayer(gradientTopColor, middle: gradientMiddleColor, bottomColor: gradientBottomColor)
        }
    }
    
    // MARK: - Gradient
    
    open func addGradientLayer(_ topColor: UIColor, middle: UIColor, bottomColor: UIColor){
        //remove sublayers
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                if let gradientLayer = sublayer as? CAGradientLayer {
                    gradientLayer.removeFromSuperlayer()
                }
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        gradientLayer.colors = [topColor.cgColor, middle.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Layouting
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradientLayer(gradientTopColor, middle: gradientMiddleColor, bottomColor: gradientBottomColor)
    }
}

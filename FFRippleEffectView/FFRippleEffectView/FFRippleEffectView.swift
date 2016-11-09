//
//  FFRippleEffectView.swift
//  FFRippleEffectView
//
//  Created by Artem Kalmykov on 09.11.16.
//  Copyright © 2016 Faifly. All rights reserved.
//

import UIKit

open class FFRippleEffectView: UIView
{
    @IBInspectable public var rippleColor: UIColor = .blue
    @IBInspectable public var borderColor: UIColor = .blue
    @IBInspectable public var rippleTrailColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
    @IBInspectable public var continiousRipples: Bool = true
    @IBInspectable public var ripplesInterval: Double = 2.2
    @IBInspectable public var cornerRadius: CGFloat = 0.0
    @IBInspectable public var image: UIImage?
    
    public var tapHandler: (() -> ())?
    public var imageView: UIImageView = UIImageView()
    
    override open func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    public func setupView()
    {
        self.setupImageView()
        self.startContiniousRipplesIfNeeded()
        
        self.layer.cornerRadius = self.cornerRadius
    }
    
    private func setupImageView()
    {
        self.addSubview(self.imageView)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = self.cornerRadius
        self.imageView.image = self.image
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.isUserInteractionEnabled = false
        self.imageView.backgroundColor = .clear
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    private func startContiniousRipplesIfNeeded()
    {
        guard self.continiousRipples else
        {
            return
        }
        
        Timer.scheduledTimer(timeInterval: self.ripplesInterval, target: self, selector: #selector(self.onContiniousRipple), userInfo: nil, repeats: true)
    }
    
    @objc private func onTap()
    {
        if let handler = self.tapHandler
        {
            handler()
        }
        
        self.animateRipple()
    }
    
    @objc private func onContiniousRipple()
    {
        self.animateRipple()
    }
    
    private func animateRipple()
    {
        let pathFrame = CGRect(x: -self.bounds.midX, y: -self.bounds.midY, width: self.bounds.size.width, height: self.bounds.size.height)
        let path = UIBezierPath(roundedRect: pathFrame, cornerRadius: self.imageView.layer.cornerRadius)
        
        let shapePosition = self.convert(self.center, from: self.superview)
        
        let circleShape = CAShapeLayer()
        circleShape.path = path.cgPath
        circleShape.position = shapePosition
        circleShape.fillColor = self.rippleTrailColor.cgColor
        circleShape.opacity = 0.0
        circleShape.strokeColor = self.rippleColor.cgColor
        circleShape.lineWidth = 2.0
        
        self.layer.insertSublayer(circleShape, at: 0)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2.5, 2.5, 1.0))
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 2.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        circleShape.add(animation, forKey: nil)
    }
}

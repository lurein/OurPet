//
//  CollectionViewCell.swift
//  OurPet
//
//  Created by Enoka Jayamanne on 7/14/18.
//  Copyright © 2018 Lurein Perera. All rights reserved.
//

import UIKit
import CoreMotion

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var walkedTodayLabel: UILabel!
    @IBOutlet weak var morningFedLabel: UILabel!
    @IBOutlet weak var eveningFedLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    
    var activateShadowBinary: Int = 0
    private static let kInnerMargin: CGFloat = 20.0
    
    // Core Motion Manager
    private let motionManager = CMMotionManager()
   
    // Shadow View
    private weak var shadowView: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: CollectionViewCell.kInnerMargin,
                                              y: CollectionViewCell.kInnerMargin,
                                              width: bounds.width - (2 * CollectionViewCell.kInnerMargin),
                                              height: bounds.height - (2 * CollectionViewCell.kInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        // Roll/Pitch Dynamic Shadow
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
                if let motion = motion {
                    let pitch = motion.attitude.pitch * 10 // x-axis
                    let roll = motion.attitude.roll * 10 // y-axis
                    if self.activateShadowBinary == 1 {
                       self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
                    }
                    
                }
            })
        }
    }
    
    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.35
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
    
    // This resets the image when we reuse the cell
    override func prepareForReuse() {
        super.prepareForReuse()
        self.petImage.image = UIImage(named: "dog_avatar2")
        self.petImage.sd_cancelCurrentImageLoad()
    }
}

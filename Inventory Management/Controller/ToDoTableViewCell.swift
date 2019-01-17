//
//  ToDoTableViewCell.swift
//  Inventory Management
//
//  Created by Ganesh Balaji Pawar on 11/01/19.
//  Copyright © 2019 Ganesh Balaji Pawar. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet var cellBackgroundView: UIView!
    @IBOutlet var statusColorView: UIView!
    
    @IBOutlet var typeImageView: UIImageView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var analystLabel: UILabel!
    @IBOutlet var dueTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusColorView.roundCorners([.topLeft, .bottomLeft], radius: 50)
        cellBackgroundView.layer.cornerRadius = 10
        
        cellBackgroundView.layer.masksToBounds = false
        cellBackgroundView.layer.shadowColor = UIColor.black.cgColor
        cellBackgroundView.layer.shadowOpacity = 0.5
        cellBackgroundView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cellBackgroundView.layer.shadowRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

//
//  KelimeTableViewCell.swift
//  SozlukUygulamasi
//
//  Created by İlker Kaya on 30.11.2022.
//

import UIKit

class KelimeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ingilizcelabel: UILabel!
    
    
    
    @IBOutlet weak var turkcelabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

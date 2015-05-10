//
//  DataCellView.swift
//  


import UIKit

class DataCellView: UITableViewCell {
    
    @IBOutlet weak var Data: UITextView! = UITextView()
    
    init(style:UITableViewCellStyle!, reuseIdentifier:String){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: (NSCoder!)){
        super.init(coder:aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
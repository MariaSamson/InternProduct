//
//  TableDetailViewController.swift
//  FinalProject
//
//  Created by Maria Andreea on 16.03.2022.
//

import UIKit

class TableDetailViewController: UIViewController  {

    var labelText: String!
    var tagText : String!
    var img : UIImage!
    var descrip : String!

    @IBAction func closeButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var closeB: UIButton!
    @IBOutlet weak var tagDetails: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var descripDetail: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        detail.text = labelText
        descripDetail.text = descrip
        tagDetails.text = tagText
        imageDetail.image = img

        descripDetail.isUserInteractionEnabled = false

        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height

        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        scrollView.contentSize = CGSize(width: screenWidth, height: 900)

        scrollView.addSubview(closeB)
        scrollView.addSubview(tagDetails)
        scrollView.addSubview(detail)
        scrollView.addSubview(imageDetail)
        scrollView.addSubview(descripDetail)

        NSLayoutConstraint(item: tagDetails as Any, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: tagDetails as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true
        NSLayoutConstraint(item: tagDetails as Any, attribute: .top, relatedBy: .lessThanOrEqual, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 750).isActive = true
        NSLayoutConstraint(item: tagDetails as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        NSLayoutConstraint(item: detail as Any, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 45).isActive = true
        NSLayoutConstraint(item: detail as Any, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: closeB as Any, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 3).isActive = true

        NSLayoutConstraint(item: imageDetail as Any, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: imageDetail as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350).isActive = true
        NSLayoutConstraint(item: imageDetail as Any, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: imageDetail!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220).isActive = true

        NSLayoutConstraint(item: descripDetail as Any, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 4).isActive = true
        NSLayoutConstraint(item: descripDetail as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth-8).isActive = true
        NSLayoutConstraint(item: descripDetail as Any, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 300).isActive = true
        NSLayoutConstraint(item: descripDetail as Any, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 460).isActive = true

          view.addSubview(scrollView)

    }

}

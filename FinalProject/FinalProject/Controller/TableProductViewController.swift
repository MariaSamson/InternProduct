//
//  TableProductViewController.swift
//  FinalProject
//
//  Created by Maria Andreea on 14.03.2022.
//

import UIKit



class TableProductViewController: UIViewController, UITextFieldDelegate {



    @IBOutlet weak var filteringText: UITextField!{
        didSet{
            filteringText.addTarget(self, action: #selector(TableProductViewController.textFieldDidChange(_:)), for: .editingChanged)
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        filteringList.products.removeAll()
        for product in productItem.products {
            if product.title.contains(filteringText.text!) || product.tags.contains(filteringText.text!) || product.description.contains(filteringText.text!) || filteringText.text == " " {
                filteringList.products.append(product)
            }
        }
        tableView.reloadData()
        collectionView.reloadData()
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func customBtn(_ sender: ArrowButton) {
        if sender.direction == .up {
            sortDescendingFunc()
            sortDescendingFilteredItemsFunc()
            sender.direction = .down
        }else if sender.direction == .down {
            sortAscendingFunc()
            sortAscendingFilteredItemsFunc()
            sender.direction = .up
        }
        self.tableView.reloadData()
        self.collectionView.reloadData()


    }


    struct Constant {
        static let productCellIdentifier = "ProductCell"
        static let collectionCellIdentifier = "Cell"
        static let productIdentifier = "ShowProduct"
    }

    var vSpinner : UIView?
    private var dictionaryArr = [String : Any]()
    private var productItem : Response!
    private var filteringList : Response! = Response(status: "", products: [])
    private let codableParsing = true
    private let urlSession = URLSession(configuration: .default)
    var labelDetailText = ""
    var detailTags : [String]!
    var imageDetail = ""
    var descripDetail = ""
    static var settingButton = SettingsViewController.setting


    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true

     }

    override func viewDidAppear(_ animated: Bool) {
        switchViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false


        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.productCellIdentifier)
        collectionView.register(UINib(nibName: "ProductCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: Constant.collectionCellIdentifier)
        self.showSpinner(onView: self.view)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = layout

        DispatchQueue.main.async { [self] in
             let data = try! Data(contentsOf: URL(string: "http://localhost:8080/products?loginToken=\(ProductsViewController.sendersMessage)")!)
             do {
              if self.codableParsing {
                  self.productItem = try self.codableDeserialization(for: data)
              }else{
                  self.dictionaryArr = try self.dictionaryDeserialization(for: data)
               }
             }
              catch {
                 print("Data serialization error:")
               }

               self.removeSpinner()
               self.tableView.reloadData()
               self.collectionView.reloadData()

          }
    }

    func sortDescendingFunc(){
        productItem.products.sort(by: {$0.date > $1.date})
    }

    func sortAscendingFunc(){
        productItem.products.sort(by: {$0.date < $1.date})
    }

    func sortDescendingFilteredItemsFunc(){
        filteringList.products.sort(by: {$0.date > $1.date})
    }
    func sortAscendingFilteredItemsFunc(){
        filteringList.products.sort(by: {$0.date < $1.date})
    }

    
    func switchViews(){
        let defaults = UserDefaults.standard
        switch  defaults.object(forKey: "product")as? Int ?? SettingsViewController.setting {
        case 0 :    tableView.isHidden = false
                    collectionView.isHidden = true
        case 1:     tableView.isHidden = true
                    collectionView.isHidden = false
        default : break
        }
        defaults.set(SettingsViewController.setting, forKey: "product")
    }

    private func codableDeserialization(for data: Data) throws -> Response {
        let jsonDecoder = JSONDecoder()
        let products = try jsonDecoder.decode(Response.self, from: data)
        return products
     }

    private func dictionaryDeserialization(for data: Data) throws -> [String: Any] {
        guard let dataArr = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            print("Data serialization error: Unexpected format received !")
            return [String : Any]()
        }
        return dataArr
    }
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
        
    }


 }
extension UITableView {
       func setEmptyView(title: String, message: String) {
       let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
       let titleLabel = UILabel()
       let messageLabel = UILabel()
       titleLabel.translatesAutoresizingMaskIntoConstraints = false
       messageLabel.translatesAutoresizingMaskIntoConstraints = false
       titleLabel.textColor = UIColor.black
       titleLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 18)
       messageLabel.textColor = UIColor.black
       messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
       emptyView.addSubview(titleLabel)
       emptyView.addSubview(messageLabel)
       titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
       titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
       messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
       messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
       messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
       titleLabel.text = title
       messageLabel.text = message
       messageLabel.numberOfLines = 0
       messageLabel.textAlignment = .center
       self.backgroundView = emptyView
       self.separatorStyle = .none
     }
}

extension TableProductViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filteringList.products.count > 0 {
            self.tableView.setEmptyView(title: "", message: "")
            return codableParsing ? self.filteringList.products.count : dictionaryArr.count
        }else if self.productItem == nil{
            return 0
        }else if filteringText.text == ""{
              return self.productItem.products.count
        }else if filteringList.products.count == 0 , productItem.products.count > 0{
            self.tableView.setEmptyView(title: "Oups..", message: "There's nothing to be shown here")
            return 0
        }else{
            self.tableView.setEmptyView(title: "", message: "")
            return codableParsing ? self.productItem.products.count : dictionaryArr.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185.0;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        labelDetailText = productItem!.products[indexPath.row].title
        descripDetail = productItem!.products[indexPath.row].description
        imageDetail = productItem!.products[indexPath.row].image
        detailTags = productItem!.products[indexPath.row].tags
        performSegue(withIdentifier: "ShowElement", sender: self)
    }
}

extension TableProductViewController: UITableViewDataSource {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowElement" {
            let vc = segue.destination as! TableDetailViewController
            vc.labelText =  labelDetailText
            vc.descrip = descripDetail
            vc.tagText = detailTags?.joined(separator: ",")
            vc.img = imageDetail.toImage()
           }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productCell = tableView.dequeueReusableCell(withIdentifier: Constant.productCellIdentifier, for: indexPath) as? ProductTableViewCell else {
            print("UI error: Cell deque resulted in unexpected instance!")
            return UITableViewCell()
        }

        var tag: [String]?
        var titleProduct: String?
        var description : String?

        if filteringList.products.count > 0
        {
            let product = filteringList!.products[indexPath.row]
            tag = product.tags
            titleProduct = product.title
            description = product.description
            productCell.productImage?.image = product.image.toImage()

        } else if codableParsing {
            let product = productItem!.products[indexPath.row]
            tag = product.tags
            titleProduct = product.title
            description = product.description
            productCell.productImage?.image = product.image.toImage()
        }

        productCell.title.text = titleProduct
        productCell.productDescription.text = description
        productCell.productTag.text = tag!.joined(separator: ",")
        return productCell
      }
    }

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
extension TableProductViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        onView.addSubview(spinnerView)
        vSpinner = spinnerView
    }

    func removeSpinner() {
         vSpinner?.removeFromSuperview()
         vSpinner = nil
    }
}

extension TableProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.filteringList.products.count > 0 {
           return codableParsing ? self.filteringList.products.count : dictionaryArr.count
        } else if self.productItem == nil {
            return 0
        }else if filteringText.text == "" {
            return self.productItem.products.count
        }else if filteringList.products.count == 0 , productItem.products.count > 0{
          self.tableView.setEmptyView(title: "Oups..", message: "There's nothing to be shown here")
          return 0
        }else {
            return codableParsing ? self.productItem.products.count : dictionaryArr.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}


extension TableProductViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        labelDetailText = productItem!.products[indexPath.row].title
        descripDetail = productItem!.products[indexPath.row].description
        imageDetail = productItem!.products[indexPath.row].image
        detailTags = productItem!.products[indexPath.row].tags
        performSegue(withIdentifier: "ShowElement", sender: self)
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.collectionCellIdentifier, for: indexPath) as? ProductCollectionViewCell else {
            print("UI error: Cell deque resulted in unexpected instance!")
            return UICollectionViewCell()
        }
        var tag: [String]?
        var titleProduct: String?
        var description : String?

        if filteringList.products.count > 0
        {
           let product = filteringList!.products[indexPath.row]
           tag = product.tags
           titleProduct = product.title
           description = product.description
           cell.collectionImage?.image = product.image.toImage()

        }else if codableParsing {
            let product = productItem!.products[indexPath.row]
            tag = product.tags
            titleProduct = product.title
            description = product.description
            cell.collectionImage?.image = product.image.toImage()
        }

        cell.collectionTitle.text = titleProduct
        cell.collectionDescription.text = description
        cell.tagsCollection.text = tag?.joined(separator: ",")
        return cell
    }
}


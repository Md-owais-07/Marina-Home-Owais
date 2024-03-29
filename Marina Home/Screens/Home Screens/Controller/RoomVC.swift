//
//  RoomVC.swift
//  Marina Home
//
//  Created by Codilar on 12/04/23.
//
//MARK: START MHIOS-1185
// Added a button in RoomVC.storyboard same as btnDetail
// Resize the button to full width.
//MARK: END MHIOS-1185
import UIKit

class RoomVC: AppUIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,RoomBannerProtocol,ProductCardDelegate {
    
    func redirectToLoginPage() {
        self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
    }
    
    var products:Products
    var identifer:String?=""
    @IBOutlet var lblTitle: UILabel!
    var roomCatArray: [Room] = []
    var bottonCatArray: [Room] = []
    var currentRoom:Room?
    var roomtite:String = ""
    var selectedCategory: ShopByRoom?
    @IBOutlet var mainCollction: UICollectionView!
    @IBOutlet weak var tblRoom: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    init() {
        self.products = Products()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.products = Products()
       super.init(coder: aDecoder)
    }
    func parse(jsonData: Data) {
       do {
           let movieData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
           let decodedData = try JSONDecoder().decode([Room].self,
                                                      from: jsonData)
           DispatchQueue.main.async {
           self.roomCatArray = decodedData
              // self.selectedCategory = self.roomCatArray[0].shop_by_room[0]
               self.bottonCatArray = []
               for i in self.roomCatArray
               {
                   if(i.identifier==self.identifer)
                   {
                       self.currentRoom = i
                       self.selectedCategory = i.shop_by_room[0]
                   }
                   else
                   {
                       self.bottonCatArray.append(i)
                   }
               }
               self.mainCollction.reloadData()
           }
       } catch {
           print("decode error")
       }
   }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text =   self.roomtite.uppercased()
        ProductCVC.register(for: self.mainCollction)
        backActionLink(self.btnBack)
            /* self.apiProducts(){ response in
            DispatchQueue.main.async {
                print(response)
                self.products = response as Products
                self.tblRoom.reloadData()
            }*/
       
          self.GeRoomItems(fromURLString: AppInfo.shared.roomURL) { (result) in
              switch result {
              case .success(let data):
                  self.parse(jsonData: data)
                  
              case .failure(let error):
                  print(error)
              }
          }
                
        }
        // Do any additional setup after loading the view.
    
    override func viewWillAppear(_ animated: Bool) {
        UserData.shared.goTocartStatus = false
        //MARK START{MHIOS-1181}
        self.mainCollction.reloadData()
        //MARK END{MHIOS-1181}
    }

    
    // MARK: - Collection
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         if(self.bottonCatArray.count>0)
         {
             return 3
         }
         else
         {
             return 2
         }
         
     }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         switch section {
         case 0:
             return 1
         case 1:
             return  self.selectedCategory?.products.count ?? 0
         default:
             return self.bottonCatArray.count
         }
         return 0
     }
    
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          switch indexPath.section {
          case 0:
              
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomMainBannerCVC", for: indexPath) as! RoomMainBannerCVC
              if(self.roomCatArray.count>0)
              {
                  self.lblTitle.text = self.currentRoom!.main_title.uppercased()
                  cell.category = self.currentRoom!.shop_by_room
                  cell.pageControl.numberOfPages = self.currentRoom!.shop_by_room.count
                  
              }
              cell.lblSubTitle.text = self.selectedCategory?.sub_title
             // self.lblTitle.text =
              cell.collectionBanner.reloadData()
              cell.detailDelegate = self
              self.mainCollction.layoutIfNeeded()
             return cell
          case 1:
              
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVC_id", for: indexPath) as? ProductCVC else { return UICollectionViewCell() }
              var p:Product = (self.selectedCategory?.products[indexPath.row])!
              cell.lblName.font = AppFonts.LatoFont.Regular(13)
              cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
              cell.productDelegate = self
              cell.tag = indexPath.row
              cell.file = p.image!//"https://marinahome.org/media/catalog/product"+
              cell.imageArrayRec = p.image!
              cell.setImages(sliderImages: [])
              cell.lblName.text = p.name
              let price = Double(p.price ?? "0")
              let priceAct = Double(p.price ?? "0")
              let priceString = String(format: "%.2f", price!)
              let priceDouble = Double(priceString)
              cell.lblActualPrice.isHidden = true
              cell.pageControl.isHidden = true
              let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
             
              let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(p.price ?? "") AED")
             
                  attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              print("\(appDelegate.wishList)")
              print("productID\(String(describing: p.id))")
              let productInfo:String = "\(p.id )"
              //MARK START{MHIOS-1181}
              let productId = Int("\(p.id ?? "0")") ?? 0
              cell.productId = productId
              //MARK END{MHIOS-1181}
              //MARK START{MHIOS-1029}
              ///var result = appDelegate.wishList.contains(productInfo)
              let productSKU:String = "\(p.sku ?? "" )"
              cell.sku = productSKU
              //MARK START{MHIOS-1181}
              let modelToCheck = WishlistIDsModel(product_id: productId, sku: productSKU)
              //MARK END{MHIOS-1181}
              var result =  UserData.shared.wishListIdArray.contains(where: { $0 == modelToCheck })
              //MARK END{MHIOS-1029}
                  if(result == true)
                  {
                      //cell.btnLike.isEnabled = false
                      cell.btnLike.setImage(UIImage(named: "liked"), for: .normal)
                  }
                  else
                  {
                      //cell.btnLike.isEnabled = true
                      cell.btnLike.setImage(UIImage(named: "like_button"), for: .normal)
                  }
              ///print("SANTHOSH IMAGE URL IS : \(url)")
             DispatchQueue.main.async {
                   let flowLayout = UICollectionViewFlowLayout()
                   flowLayout.scrollDirection = .horizontal
                 flowLayout.itemSize = CGSize(width: 128, height: 128)
                   cell.collectionImages.collectionViewLayout = flowLayout
                 cell.collectionImages.reloadData()
              }
              
              var specialPrice = ""
              var specialToDate = ""
              var specialFromDate = ""
              for item in p.customAttributes ?? [] {
                  switch item.value {
                  case .string(let stringValue):
                      print(item.attribute_code)
                      print("String value: \(stringValue)")
                      
                      if item.attribute_code == "special_price" {
                          ///specialPrice = "\(stringValue ?? "")"
                          print("SANTHOSH TS value: \(stringValue)")
                          if let floatNumber = Float(stringValue) {
                              let spPriceVal = Double(floatNumber)
                              specialPrice = formatNumberToThousandsDecimal(number: spPriceVal )
                              cell.lblOfferPrice.text = specialPrice + " AED"
                          }
                      }
                      if item.attribute_code == "special_from_date"{
                          specialFromDate = "\(stringValue ?? "")"
                          //productPriceLbl.text = "\(item.value ?? "")"
                          print("special_from_date")
                          print("\(stringValue ?? "")")
                      }
                      if item.attribute_code == "special_to_date"{
                          specialToDate = "\(stringValue ?? "")"
                          print("special_to_date")
                          print("\(stringValue ?? "")")
                          //productPriceLbl.text = "\(item.value ?? "")"
                      }
                      
                  case .stringArray(let stringArrayValue):
                      print("String array value: \(stringArrayValue)")
                  case .none:
                      print("")
                      
                  }
              }
              print("TEST price")
              print("SANTHOSH : ",specialPrice)
              
              var productPrice = 0.0
              if let floatNumber = Float(p.price ?? "0.00") {
                  productPrice = Double(floatNumber)
              }
              
              if let floatNumber = Float(p.special_price ?? "0.00") {
                  let specialPriceDouble = Double(floatNumber)
                  specialPrice = formatNumberToThousandsDecimal(number: specialPriceDouble )

              }
              specialToDate = p.special_to_date ?? ""
              specialFromDate = p.special_from_date ?? ""
              
              let specialPriceFlag = checkSpecialPrice(specialPrice: specialPrice, specialToDate: specialToDate, specialFromDate: specialFromDate)
              if specialPriceFlag
              {
                  let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                  let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatNumberToThousandsDecimal(number: productPrice) + " AED" )")
                  attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                  
                  cell.lblOfferPrice.text = specialPrice + " AED"
                  cell.lblActualPrice.attributedText = attributeString
                  cell.lblActualPrice.isHidden = false
                  cell.lblOfferPrice.isHidden = false
                  cell.lblActualPrice.font = AppFonts.LatoFont.Bold(13)
                  cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
              }
              else
              {
                  cell.lblOfferPrice.isHidden = true
                  cell.lblActualPrice.font = AppFonts.LatoFont.Bold(13)
                  cell.lblOfferPrice.font = AppFonts.LatoFont.Bold(13)
                  let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                  let attributeString: NSMutableAttributedString = NSMutableAttributedString(string:"\(formatNumberToThousandsDecimal(number: productPrice) + " AED")")
                  attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: 0))
                  
                  cell.lblActualPrice.attributedText = attributeString
                  cell.lblActualPrice.isHidden = false
              }
              
              //////cell.lblActualPrice.attributedText = attributeString
              self.mainCollction.layoutIfNeeded()
             return cell
               //let product:Item = self.products.items![indexPath.row]
               //cell.setNeedsDisplay()
               //cell.lblName.text = product.name
              // cell.lblPri
          default:
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBannerCell", for: indexPath) as! HomeBannerCell
              let room:Room = self.bottonCatArray[indexPath.row]
              //MARK: START MHIOS-1179
              if self.selectedCategory?.products.count ?? 0 > 0
              {
                  if indexPath.row == 0
                  {
                      cell.viewSeperator.isHidden = false
                      cell.bannerTopHeight.constant = 50
                  }
                  else
                  {
                      cell.viewSeperator.isHidden = true
                      cell.bannerTopHeight.constant = 0
                  }
              }
             else
              {
                  cell.viewSeperator.isHidden = true
                  cell.bannerTopHeight.constant = 0
              }
              //MARK: END MHIOS-1179
              cell.lblTitle3.isHidden = true
              cell.lblTitle2.isHidden = true
              cell.lblTitle1.text = room.main_title
              cell.lblTitle1.font = AppFonts.PlayfairFont.SemiBold(28)
              cell.lblTitle1.textAlignment = .center
              if room.shop_by_room[0].image != ""
              {
                  let url = URL(string: "\(room.shop_by_room[0].image ?? "")")!///\(AppInfo.shared.imageURL)
                  print("SANTHOSH IMAGE URL IS : \(url)")
                  cell.imgBanner.kf.setImage(with:url.downloadURL )
              }
              self.mainCollction.layoutIfNeeded()
              cell.btnDetail.tag = indexPath.row
              cell.btnDetail.addTarget(self, action: #selector(self.changeroom(_:)), for: .touchUpInside)
              return cell
          }
          
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let height = self.view.frame.size.height
            let width = self.view.frame.size.width
//         let banner:ShopByRoom = self.category[indexPath.row]
//         let url = URL(string: "\(AppInfo.shared.imageURL)\(banner.image ?? "")")!
//         ///cell.imgBanner.kf.setImage(with:url.downloadURL )
//         let imageHeight = sizeOfImageAt(url: url)
//         print(indexPath.row)
//         print("SANTHSOSH IMAGE SIZE : ",imageHeight)
//         print("SANTHSOSH IMAGE URL : ",url)
         //imageHeight!+60
         let imageHeight = (width/5)*6 + 60
         switch indexPath.section {
         case 0:
             return CGSize(width: self.view.frame.width, height:imageHeight)
         case 1:
             var cellWidth = width/2
             cellWidth = cellWidth-9
             return CGSize(width:cellWidth, height: cellWidth+72)
         default:
             //MARK: START MHIOS-1179
             if self.selectedCategory?.products.count ?? 0 > 0
             {
                 if indexPath.row == 0
                 {
                     return CGSize(width: self.view.frame.width, height:323)
                 }
                 else
                 {
                     return CGSize(width: self.view.frame.width, height:273)
                 }
             }
            else
             {
                return CGSize(width: self.view.frame.width, height:273)
             }
             //MARK: END MHIOS-1179
                // in case you you want the cell to be 40% of your controllers view
             
         }
     }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case 0:
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 1:
            if collectionView.numberOfItems(inSection: section) == 1 {
                return UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 0)
            }
            else
            {
                return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
            }
            
            ///return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
     // MARK UICollectionViewDelegate
     
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if(indexPath.section==1)
          {
            //MARK: MHIOS-1187
            //Code deleted related to redirect to the product details screen.
         }
          
     }
    
    func sizeOfImageAt(url: URL) -> CGFloat? {
        // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        
        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }
        
        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
           let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return height //CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
   
    func changeProducts(Room:ShopByRoom)
    {
        self.selectedCategory = Room
        DispatchQueue.main.async {
            self.mainCollction.reloadData()
            self.mainCollction.layoutIfNeeded()
        }
    }
    @objc func changeroom(_ sender: UIButton) {
        let Vc = AppController.shared.Room
        let cat = self.bottonCatArray[sender.tag]
        Vc.identifer = cat.identifier
        self.navigationController?.pushViewController(Vc, animated: true)
       
    }
    func openDetail(tag:Int,sectionSelected:Int)
    {
        
            let nextVC = AppController.shared.productDetailsImages
            nextVC.productId = "\(self.selectedCategory?.products[tag].sku ?? "")"
            nextVC.hidesBottomBarWhenPushed = false
            self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    //MARK START{MHIOS-1029}
    func addToWishList(productId:String,tag:Int,sku:String)
    {
        if UserData.shared.isLoggedIn
        {
            self.apiAddToWishlist(id: productId){ responseData in
                DispatchQueue.main.async {
                    print(responseData)
                    if responseData{
                        //MARK START{MHIOS-1181}
                        UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:Int(productId) ?? 0,sku: sku))
                         //MARK END{MHIOS-1181}
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.wishList.append(productId)
                        //self.collectionPLP.reloadData()
                        self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
                    }
                }
            }
        }
        else
        {
            
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.wishList.append(productId)
            UserData.shared.wishListIdArray.append(WishlistIDsModel(product_id:Int(productId) ?? 0,sku: sku))
            print("SANTHOSH WISHLIST G LIST \(UserData.shared.wishListIdArray)")
            self.toastView(toastMessage: "Added to wishlist successfully!",type: "success")
//                self.showAlert(message: "Please log in or register to view your wishlist.", hasleftAction: true,rightactionTitle: "Continue", rightAction: {
//                    self.navigationController?.pushViewController(AppController.shared.loginRegister, animated: true)
//                }, leftAction: {
//                    //print("SANTHOSH WISHLIST G LIST \(appDelegate.wishLists[0])")
//                })
            
        }
    }
    //MARK END{MHIOS-1029}
    func removeWishList(productId:String,tag:Int)
    {
        if UserData.shared.isLoggedIn
        {
            self.apiRemoveProduct(id: productId){ responseData in
                DispatchQueue.main.async {
                    print(responseData)
                    if responseData{
                        //MARK START{MHIOS-1181}
                        UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(productId) ?? 0 }
                        //MARK END{MHIOS-1181}
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.wishList = appDelegate.wishList.filter{$0 != productId }
                        self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
                    }
                }
            }
        }
        else
        {
            //MARK START{MHIOS-1029}
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.wishList = appDelegate.wishList.filter{$0 != productId }
            UserData.shared.wishListIdArray =  UserData.shared.wishListIdArray.filter { $0.product_id != Int(productId) ?? 0 }
            self.toastView(toastMessage: "Successfully removed from wishlist!",type: "success")
            //MARK END{MHIOS-1029}
        }
    }
        
}
/*extension RoomVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section==1)
        {
            return 30
        }
        return 0
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 500
        default:
            return 450
        }
        return 450
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblRoom.frame.width, height: 30))
        headerView.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.tblRoom.frame.width, height: 21))
           
            label.textAlignment = .left
            label.text = "The Minimal-Natural Room"
        label.font = .boldSystemFont(ofSize: 17)
            headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(with: RoomBannerTableCell.self, for: indexPath)
    
           // cell.collectionBanner.register(HomeBannerCell.self, forCellWithReuseIdentifier: "HomeBannerCell")
            cell.collectionBanner.translatesAutoresizingMaskIntoConstraints = false
            cell.collectionBanner.contentInsetAdjustmentBehavior = .never
            cell.collectionBanner.reloadData()
           
            //cell.collectionBanner.backgroundColor = .systemPurple

                
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(with: RoomItemTableCell.self, for: indexPath)
            
           // cell.collectionBanner.register(HomeBannerCell.self, forCellWithReuseIdentifier: "HomeBannerCell")
            cell.collectionBanner.translatesAutoresizingMaskIntoConstraints = false
            cell.collectionBanner.contentInsetAdjustmentBehavior = .never
            cell.collectionBanner.reloadData()
            cell.products = self.products;
            //cell.collectionBanner.backgroundColor = .systemPurple

            return cell
       
           
        default:
            let cell = tableView.dequeueReusableCell(with: HomeCell.self, for: indexPath)
            if(indexPath.row != 0)
            {
                cell.imgLogo.isHidden = true
            }
            else
            {
                cell.imgLogo.isHidden = false
            }
           // cell.collectionBanner.register(HomeBannerCell.self, forCellWithReuseIdentifier: "HomeBannerCell")
            //cell.collectionBanner.translatesAutoresizingMaskIntoConstraints = false
            //cell.collectionBanner.contentInsetAdjustmentBehavior = .never
            cell.collectionBanner.reloadData()
            //cell.btnDetail.addTarget(self, action: #selector(self.DetailAction(_:)), for: .touchUpInside)
            //cell.collectionBanner.backgroundColor = .systemPurple

                
            return cell
        }
       
    }
    
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.prepareForReuse()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.view.frame.self.height
    }
    
    @objc func DetailAction(_ sender: UIButton) {
           self.navigationController?.pushViewController(AppController.shared.Room, animated: true)
       }
 
}*/

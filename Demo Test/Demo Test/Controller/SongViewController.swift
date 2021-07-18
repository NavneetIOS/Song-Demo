//
//  SongViewController.swift
//  Demo Test
//
//  Created by MAC-21 on 16/07/21.
//

import UIKit
import SDWebImage

class SongViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblNotification: UITableView!
    var refreshControl: UIRefreshControl!
    var arraynotification = [Any]()
    var vSpinner : UIView?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.LoadingStart()
            self.navigationItem.title = "Song List"
            refreshControl = UIRefreshControl()
            tblNotification.addSubview(refreshControl)
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(sortArray), for: .valueChanged)
            refreshControl.backgroundColor = UIColor.white
            refreshControl.tintColor = UIColor(red: 168.0/255, green: 47.0/255, blue: 134.0/255, alpha: 1.0)
            arraynotification = [Any]()
            tblNotification.estimatedRowHeight = 100
            tblNotification.rowHeight = UITableView.automaticDimension
            CustomerNotificationListApi ()
        }
    
    @objc func sortArray() {
        self.refreshControl.endRefreshing()
        self.CustomerNotificationListApi ()
            
    }
    
        
        func CustomerNotificationListApi () {
            self.view.endEditing(true)
            let parameterDictionary = NSMutableDictionary()
            
            print(parameterDictionary)
            
            let methodName = "search?term=Michael+jackson"
            
            DataManager.getAPIResponse(parameterDictionary , methodName: methodName){(responseData,error)-> Void in
            self.arraynotification = DataManager.getVal(responseData?["results"]) as! [Any]
            print(self.arraynotification)
            self.tblNotification.reloadData()
            self.LoadingStop()
            
        }
            
            //else {
                    //self.view.makeToast(message: message)
             //   }
               // self.clearHud()
            }
    
    

    //////// Table view delegate and Datasource/////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraynotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowData", for: indexPath) as! ShowDataCell
            let dict = DataManager.getVal(self.arraynotification[indexPath.row]) as! NSDictionary
            cell.lblArtist.text = (dict.value(forKey: "artistName") as! String)
            //cell.lbldate.text = (dict.value(forKey: "country") as! String)
            cell.lbltitle.text = (dict.value(forKey: "collectionName") as? String)
            
            let image = (dict.value(forKey: "artworkUrl100") as! String)
            cell.imguser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imguser.startAnimating()
            let url = URL.init(string: image)
            cell.imguser.sd_setImage(with: url, placeholderImage: UIImage.init(named: "No_Image_Available"), options: .refreshCached, completed: { (img, error, cacheType, url) in
             })
            cell.imguser.stopAnimating()
        
            return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let dict = DataManager.getVal(self.arraynotification[indexPath.row]) as! NSDictionary
       let userDefaults = UserDefaults.standard
       userDefaults.setValue(dict, forKey: "song")
       userDefaults.synchronize()
       let obj = self.storyboard?.instantiateViewController(withIdentifier: "SongdetailViewController") as! SongdetailViewController
       self.navigationController?.pushViewController(obj, animated: true)
        
    }
}





//
//  SongdetailViewController.swift
//  Demo Test
//
//  Created by MAC-21 on 16/07/21.
//

import UIKit
import SDWebImage

class SongdetailViewController: UIViewController {
    
    var songdict = NSDictionary()
    @IBOutlet weak var imgArtist:UIImageView!
    @IBOutlet weak var lblArtist:UILabel!
    @IBOutlet weak var lbldiscription:UILabel!
    @IBOutlet weak var lblCountry:UILabel!
    @IBOutlet weak var lblcurrency:UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Song Detail"
        let defaults = UserDefaults.standard
        songdict = defaults.object(forKey: "song")! as! NSDictionary
        
        let strAritest = songdict.value(forKey: "artistName")
        lblArtist.text = strAritest as? String
        let strcurrency = songdict.value(forKey: "trackName")
        lblCountry.text = (strcurrency as? String)
        
        let strcountry = songdict.value(forKey: "country")
        lblcurrency.text = (strcountry as? String)
        
        let strdisc = songdict.value(forKey: "description")
        lbldiscription.text = (strdisc as? String)
        
        let image = songdict.value(forKey: "artworkUrl100")
        imgArtist.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgArtist.startAnimating()
        let url = URL.init(string: image as! String)
        imgArtist.sd_setImage(with: url, placeholderImage: UIImage.init(named: "No_Image_Available"), options: .refreshCached, completed: { (img, error, cacheType, url) in
         })
        print(songdict)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

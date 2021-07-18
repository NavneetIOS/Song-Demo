import Foundation

import SystemConfiguration


extension NSDictionary{
    
    private func httpStringRepresentation(value: Any) -> String {
        switch value {
        case let boolean as Bool:
            return boolean ? "true" : "false"
        default:
            return "\(value)"
        }
    }
    
    func dataFromHttpParameters() -> NSData? {
        
        var parameterArray = [String]()
        for (key, value) in self {
            let string = httpStringRepresentation(value: value)
            if let escapedString = string.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) {
                parameterArray.append("\(key)=\(escapedString)")
            }
        }
        let parameterString = parameterArray.joined(separator: "&")
        #if DEBUG
        print(parameterString)
        #endif
        return parameterString.data(using: String.Encoding.utf8) as NSData?
    }
    
}



class DataManager {
    
    class func isConnectedToNetwork()->Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
        
    }
    
    class func getVal(_ param:Any!) -> AnyObject {
        
        // let objectClass : AnyClass! = object_getClass(param)
        // let className = objectClass.description()
        
        if param == nil
        {
            return "" as AnyObject
        }
        else if param is NSNull
        {
            return "" as AnyObject
        }
        else if param is NSNumber
        {
            let aString:String = "\(param!)"
            return aString as AnyObject
        }
        else if param is Double
        {
            return "\(param)" as AnyObject
        }
        else
        {
            return param as AnyObject
        }
    }
    
    class func getVal(_ param:AnyObject!,typeObj:AnyObject) -> AnyObject {
        
        // let objectClass : AnyClass! = object_getClass(param)
        // let className = objectClass.description()
        
        if param == nil
        {
            return typeObj
        }
        else if param is NSNull
        {
            return typeObj
        }
        else if param is NSNumber
        {
            return typeObj
        }
        else if param is Double
        {
            return typeObj
        }
        else
        {
            return typeObj
        }
        
    }
    
   
    class func getValForIndex(_ arrayValues:AnyObject!,index:Int) -> AnyObject {
        ////print("getVal = \(arrayValues)")
                let arrayVal: AnyObject! = getVal(arrayValues)
        
        if arrayVal is NSArray || arrayVal is NSMutableArray
        {
            let arr = arrayValues as! NSArray
            if index < arr.count {
                return arr.object(at: index) as AnyObject
            }else{
                return "" as AnyObject
            }
        }
        else
        {
            return "" as AnyObject
        }
    }
    
    
    class func JSONStringify(_ value: AnyObject, prettyPrinted: Bool = false) -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
        if JSONSerialization.isValidJSONObject(value) {
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        return ""
    }
    

    class func getAPIResponse(_ parameterDictionary :NSMutableDictionary,methodName:String, success: @escaping ((_ iTunesData: NSDictionary?,_ error:NSError?) -> Void)) {
        
        var request: NSMutableURLRequest!
        
        let apiPath = "\(Config().API_URL)\(methodName)"
        #if DEBUG
          print(apiPath)
        #endif
      
        
        request = NSMutableURLRequest(url: NSURL(string: apiPath)! as URL)
        
        request.httpMethod = "GET"
        request.httpBody = parameterDictionary.dataFromHttpParameters() as Data?
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                //3
                success(urlData,error)
            }
        })
    }


    class func randomStringWithLength (_ len : Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for i in 0 ..< len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    class func getOtherAPI(_ str:NSString,success:( (_ itunesdata:Data,_ error:NSError ) -> Void )){
        //println(str)
        
    }
    
    class func getSubmitAPIResponse(_ parameterDictionary :NSDictionary,MethodName: String, success: @escaping ((_ iTunesData: NSDictionary?,_ error:NSError?) -> Void)) {
        let MethodURL = Config().API_URL+MethodName
        print(MethodURL)
        let deviceToken = DataManager.getVal(Config().AppUserDefaults.object(forKey: "deviceToken")) as! String
        let  parameterDic  =  ["data":parameterDictionary,"device_type":"2","device_id":deviceToken ,"device_token":deviceToken] as [String : Any];
        
        var request: NSMutableURLRequest!
        request = NSMutableURLRequest(url: URL(string: MethodURL)!)
        request.httpBody = parameterDictionary.dataFromHttpParameters() as Data?
        request.httpMethod = "POST"
        
        loadDataFromURL(request, completion:{(data, error) -> Void in
             #if DEBUG
            print(request)
            print(data!)
            #endif
            if let urlData = data {
                success(urlData,error)
            }
        })
    }
    
    class func loadDataFromURL(_ request: NSMutableURLRequest, completion:@escaping (_ data: NSDictionary?, _ error: NSError?) -> Void) {
        // Use NSURLSession to get data from an NSURL
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
        {(response, data, error) in
            //print(error)
            if let responseError = error {
                #if DEBUG
                Config().printData(responseError as NSObject)
                #endif
                var jsonResult  = NSDictionary()
                jsonResult = ["status":"error","message":responseError.localizedDescription]
                //  jsonResult = ["status":"error","message":"Make sure your device is connected to the internet."]
                completion(jsonResult, responseError as NSError?)
            } else if let httpResponse = response as? HTTPURLResponse {
                Config().printData(httpResponse.statusCode as NSObject)
                if httpResponse.statusCode != 200 {
                    let base64String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    #if DEBUG
                    Config().printData(base64String!)
                    #endif
                    var jsonResult  = NSDictionary()
                    jsonResult = ["status":"error","message":base64String!]
                    //  jsonResult = ["status":"error","message":"There is a problem with server, kindly try again."]
                    completion(jsonResult, nil)
                } else {
                    let base64String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    #if DEBUG
                    Config().printData(base64String!)
                    #endif
                    var jsonResult  = NSDictionary()
                    
                    let decodedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    if((try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) != nil){
                        
                        jsonResult  = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    } else {
                        #if DEBUG
                        Config().printData(decodedString!)
                        #endif
                        jsonResult = ["status":"error","message":decodedString!]
                        //  jsonResult = ["status":"error","message":"There is a problem with server, kindly try again."]
                    }
                    #if DEBUG
                    Config().printData(jsonResult)
                    #endif
                    completion(jsonResult, nil)
                }
            }
        }
        //loadDataTask.resume()
    }
    
}


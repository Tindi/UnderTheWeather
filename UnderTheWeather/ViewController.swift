//
//  ViewController.swift
//  UnderTheWeather
//
//  Created by Kitish on 07/06/2017.
//  Copyright © 2017 Kitish. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationMgr = CLLocationManager()
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelCondition: UILabel!
    
    @IBOutlet weak var labelMax: UILabel!
    @IBOutlet weak var labelMin: UILabel!
    
    var MyLong: String = ""
    var MyLat: String = ""
    
    var name: String = ""
    var country: String = ""
    var maxTemp: String = ""
    var minTemp: String = ""
    var currentTemp: Float = 0.0
    var condition: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Under The Weather"
        
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let result = formatter.stringFromDate(date)
        labelDate.text = result
        
        // Get Location
        getCurrentLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentLocation() {
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        locationMgr.delegate = self
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.distanceFilter = 200
        
        if CLLocationManager.locationServicesEnabled() {
            locationMgr.startUpdatingLocation()
        }
    }
    
    func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "Fetching Weather..."
    }
    
    func hideLoadingHUD() {
        MBProgressHUD.hideHUDForView(self.view!, animated: true)
    }
    
    func showAlertWithMessage(message: String!) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        alertController.addAction(cancel)
        
        if self.presentedViewController == nil {
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    
    // retrieve the last location of the user
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let lastLocation:CLLocation = locations[0] as CLLocation {
        manager.stopUpdatingLocation()
            
            self.MyLat = String(format: "%.6f", lastLocation.coordinate.latitude)
            self.MyLong = String(format: "%.6f", lastLocation.coordinate.longitude)
        
            getWeather(MyLat, lon: MyLong)
        }
       
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        
        print("error\(error)")
        
        if error.domain == kCLErrorDomain  {
            
         if CLError(rawValue: error.code) == CLError.Denied {
            
             showAlertWithMessage("Access to location or ranging has been denied by the user. Go to  Settings > General > Reset > Reset Local Warnings. ")
            
            } else  if CLError(rawValue: error.code) == CLError.LocationUnknown {
            
            showAlertWithMessage("Unknown Location.")
            
         } else {
            
             showAlertWithMessage("Unknown Core Location Error.")
            
            }
            
        }
        
    }
    
    enum CLError : Int {
        case LocationUnknown
        case Denied
        case NetworkError
    }
    
    func getWeather(lat: String, lon: String) {
        showLoadingHUD()
        
        // GET Request
        Alamofire.request(.GET, Endpoints.API + "lat=\(lat)" + "&lon=\(lon)")
            .validate()
            .responseJSON { response in
                print(response.result)
                print(response.request)
                
                switch response.result {
                case .Success(_):
                    
                    print("Status Code: \(response.response?.statusCode)")
                    self.hideLoadingHUD()
                    
                    if response.response?.statusCode == 200 {
                        
                        if let data = response.result.value {
                            let json = JSON(data)
                            print("JSON: \(json)")
                            
                            
                            self.name = json["name"].stringValue
                            self.country = json["sys"]["country"].stringValue
                            
                            self.currentTemp = json["main"]["temp"].floatValue
                            self.maxTemp = json["main"]["temp_max"].stringValue
                            self.minTemp = json["main"]["temp_min"].stringValue
                            
                            let weatherList = json["weather"].arrayValue
                            
                            for item in weatherList {
                                self.condition = item["description"].stringValue
                            }
                            
                            self.labelTemp.text = NSString(format:"\(self.currentTemp)%@C", "\u{00B0}") as String
                            self.labelLocation.text = self.name + ", " + self.country
                            self.labelCondition.text = self.condition
                            self.labelMax.text = NSString(format:"Max: \(self.maxTemp)%@C", "\u{00B0}") as String
                            self.labelMin.text = NSString(format:"Min: \(self.minTemp)%@C", "\u{00B0}") as String
                            
                        }
                        
                    } else {
                        
                        self.hideLoadingHUD()
                        
                        if let data = response.data {
                            let json = JSON(data:data)
                            print("Error: \(json)")
                            
                            let error_message = json["message"].stringValue
                            self.showAlertWithMessage(error_message)
                            
                        }
                    }
                    break
                    
                case .Failure(let error):
                    
                    self.hideLoadingHUD()
                    if let err = error as? NSURLError where err == .NotConnectedToInternet {
                          self.showAlertWithMessage("No Internet Connection. Kindly check your connection and try again.")
                    } else {
                        print(error)
                    }
                }
                
        }
        
        
    }


}


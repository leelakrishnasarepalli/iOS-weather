
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, changeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "4162f01cfeeefce1fb7eb398c3d22e52"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        
    }
    
    
    func getWeatherData(url : String, parmeters : [String : String]){
        Alamofire.request(url, method: .get, parameters: parmeters).responseJSON{
            response in
            if response.result.isSuccess{
                let wetherResponse : JSON = JSON(response.result.value!)
                print(wetherResponse)
                self.updateWeatherData(json : wetherResponse)
            }else{
                print("Error \(response.result.error!)")
                self.cityLabel.text = "Connection issue"
            }
        }
       
    }
    
    
    func updateWeatherData(json : JSON){
        if let tempResult = json["main"]["temp"].double{
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.wetherIconName = weatherDataModel.updateWeatherIcon(condition : weatherDataModel.condition)
            updateUIWithWeatherData()
            
        }else{
            cityLabel.text = "Weather Unavailable"
        }
        
    }

    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.wetherIconName)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let parms : [String : String] = ["lat" : String(latitude), "lon" : String(longitude), "appid" : APP_ID]
            
            getWeatherData(url : WEATHER_URL, parmeters : parms)
            
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavailable"
    }
    
    @IBAction func changeCity(_ sender: UIButton) {
        performSegue(withIdentifier: "changeCityName", sender: self)
        
    }
    
    func userEnteredACityName(city : String){
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parmeters: params)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destVC = segue.destination as! ChangeCityViewController
            destVC.delegate2 = self
        }
        
    }
    
    
    
    
}



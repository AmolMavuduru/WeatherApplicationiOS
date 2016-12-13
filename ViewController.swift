//
//  ViewController.swift
//  Whats the Weather
//
//  Created by Amol on 12/7/16.
//  Copyright © 2016 Amol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var userInput: UITextField!

    @IBOutlet var weatherData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func submitInput(_ sender: UIButton) {
        
        let city: String = userInput.text!.replacingOccurrences(of: " ", with: "-")
        
        var weatherSite = "http://www.weather-forecast.com"
        var addedString = "/locations/" + city + "/forecasts/latest"
        
        
        if let url = URL(string: weatherSite + addedString)
        {
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest)
          {
            data, response, error in
            
            var message = "";
            
            
            if error != nil
            {
                print(error)
            }
            else
            {
                if let unwrappedData = data
                {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                   // print(dataString) //Prints the data from the website (as HTML code)
                    
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator)
                    {
                        if contentArray.count > 1
                        {
                           stringSeparator = "</span>"
                            
                           let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                                if(newContentArray.count > 1)
                                {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°");
                                    print(message);
                                }
                            
                        }
                    }
                    
                    
                    
                }
             }
            
            if(message == "")
            {
                message = "The weather in the location you have entered could not be found. Please try again";
            }
            DispatchQueue.main.sync(execute: {
                
                self.weatherData.text = message; //Must use self to refer to weatherData in the ViewController
            })
            
           }
            task.resume();
            
        }
        else
        {
            weatherData.text = "The weather in the location you have entered could not be found. Please try again."
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Below is the code for configuring the keyboard and allowing the user to close it when necessary

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder() //close the keyboard
        
        return true
        
    }

}


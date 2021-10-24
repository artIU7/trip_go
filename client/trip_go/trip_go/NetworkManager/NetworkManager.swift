//
//  NetworkManager.swift
//  trip_go
//
//  Created by Артем Стратиенко on 24.10.2021.
//

import Foundation
import RealmSwift

func fetch_ya_api( urlString : String ) {
    
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data,response,error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let preload = json as! [String:Any]
                print("json response decoder")
                
                let title_list   =  preload["title"] as! String
                
                let code_list    =  preload["code"] as!  String
                
                let lat_list     =  preload["lat"] as! Double
                
                let lng_list     =  preload["lng"] as! Double
                
                print(code_list)
                
                temp_uid_city = code_list
                
                /*
                let feature = preload["features"] as! NSArray
          //      print(feature)
                for element in feature {
         //           print(element)
                  let respone = element as! [String:Any]
                  let properties = respone["properties"] as! [String:Any]
                  let attribute = properties["Attributes"] as! [String:Any]
                  
                    let nameStation = attribute["NameOfStation"] as! String
                    let eventStation = attribute["ModeOnEvenDays"] as! String
                    let nameExitStation = attribute["Name"] as! String
                    let lattitudeExit = attribute["Latitude_WGS84"] as! String
                    let longitudeExit = attribute["Longitude_WGS84"] as! String
                }*/
            } catch {
                print(error)
            }
        }.resume()
    }
    
func fetch_ya_api_planer( urlString : String ) {
    
        guard let url = URL(string: urlString) else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data,response,error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let preload = json as! [String:Any]
                print("json response decoder")
                
                let title_list   =  preload["title"] as! String
                
                let code_list    =  preload["code"] as!  String
                
                let lat_list     =  preload["lat"] as! Double
                
                let lng_list     =  preload["lng"] as! Double
                
                print(code_list)
                
                temp_uid_city = code_list
                
                /*
                let feature = preload["features"] as! NSArray
          //      print(feature)
                for element in feature {
         //           print(element)
                  let respone = element as! [String:Any]
                  let properties = respone["properties"] as! [String:Any]
                  let attribute = properties["Attributes"] as! [String:Any]
                  
                    let nameStation = attribute["NameOfStation"] as! String
                    let eventStation = attribute["ModeOnEvenDays"] as! String
                    let nameExitStation = attribute["Name"] as! String
                    let lattitudeExit = attribute["Latitude_WGS84"] as! String
                    let longitudeExit = attribute["Longitude_WGS84"] as! String
                }*/
            } catch {
                print(error)
            }
        }.resume()
    }
    


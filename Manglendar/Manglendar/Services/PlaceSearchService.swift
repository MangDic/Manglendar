//
//  PlaceSearchService.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/11.
//

import Foundation
import CoreLocation
import Alamofire
import RxCocoa

class PlaceSearchService: NSObject, CLLocationManagerDelegate {
    static let shared = PlaceSearchService()
    
    var placeRelay = BehaviorRelay<[PlaceData]>(value: [])
    var locationManager = CLLocationManager()
    var currentLatitude: CGFloat = 0.0
    var currentLogiture: CGFloat = 0.0
    
    let headers: HTTPHeaders = [
        "Authorization": "KakaoAK 70187c8bbe5201f141ba7d33b3869969"
    ]
    
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        // 델리게이트 설정
        locationManager.delegate = self
        // 거리 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 사용 허용 알림
        locationManager.requestWhenInUseAuthorization()
        // 위치 사용을 허용하면 현재 위치 정보를 가져옴
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        else {
            print("위치 서비스 허용 off")
        }
    }
    
    func searchPlace(place: String) {
        var resultList = [PlaceData]()
        
        let parameters: [String: Any] = [
            "query": "keyword",
            "page": 1,
            "size": 15,
            "x": "\(currentLogiture)",
            "y": "\(currentLatitude)",
            "sort": "distance"
        ]
        
        var updatedParameters = parameters
        updatedParameters["query"] = place
        
        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get,
                   parameters: updatedParameters, headers: headers)
        .responseData(completionHandler: { [weak self] response in
            guard let `self` = self else { return }
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let searchResult = try decoder.decode(PlaceSearchResult.self, from: data)
                    resultList = searchResult.documents
                    self.placeRelay.accept(resultList)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLatitude = location.coordinate.latitude
            currentLogiture = location.coordinate.longitude
        }
    }
}



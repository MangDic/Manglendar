//
//  NavigationService.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/12.
//

import Foundation
import WebKit
import SwiftyJSON
import Alamofire

class NavigationView: UIView, UIWebViewDelegate {
    
    var webView = WKWebView()
    var placeData: PlaceData?
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(placeData: PlaceData) {
        self.placeData = placeData
        setupWebView2()
    }
    
    private func setupLayout() {
        webView.layer.borderColor = #colorLiteral(red: 0.9257166181, green: 0.9257166181, blue: 0.9257166181, alpha: 1)
        webView.layer.borderWidth = 1
        webView.layer.cornerRadius = 4
        
        addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupWebView() {
        guard let placeData = placeData else { return }
        webView.navigationDelegate = self
        let encodedPlace = placeData.place_name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStr = "https://map.kakao.com/?q=\(encodedPlace!)&latitude=\(placeData.y)&longitude=\(placeData.x)"
        
        print(urlStr)
        let myUrl = URL(string: urlStr)
        let myRequest = URLRequest(url: myUrl!)
        webView.load(myRequest)
    }
    
    private func setupWebView2() {
        guard let placeData = placeData else { return }
        webView.navigationDelegate = self
        
        let transportMode = "transit"
        let startLocation = "내위치"
        
        let baseUrl = "https://m.map.kakao.com/actions/routeView?"
        let encodedPlaceName = placeData.place_name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlStr = baseUrl + "ep=\(placeData.x),\(placeData.y)&endLoc=\(encodedPlaceName)"
        
        if let myUrl = URL(string: urlStr) {
            let myRequest = URLRequest(url: myUrl)
            webView.load(myRequest)
        }
    }
}

extension NavigationView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let currentURL = webView.url {
            print("Current URL: \(currentURL)")
        }
        // script를 사용해서 상단바의 요소에 접근합니다.
        let script = """
                    const daumHead = document.querySelector('#daumHead');
                    const daumWrap = document.querySelector('#daumWrap');
                    daumHead.style.display = 'none';
                    daumWrap.style.paddingTop = '0';
                """
        
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print("Error hiding top bar: \(error.localizedDescription)")
            } else {
                print("Top bar hidden successfully")
                
            }
        }
    }
}

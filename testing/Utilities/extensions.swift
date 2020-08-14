//
//  extensions.swift
//  testing
//
//  Created by Familia Fonseca López on 06/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T:UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
    }
    
    @discardableResult
    public func addBlur(style: UIBlurEffect.Style = .extraLight) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        addSubview(blurBackground)
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return blurBackground
    }
}

extension UIColor {
   class var navColor : UIColor { UIColor(named: "navColor")! }
}
extension UIImage {
    var base64 : String {
        guard let data : Data = self.pngData() as
            Data? else { return "" }
        return data.base64EncodedString()
    }
}

extension String {
    func getURLImage(completion: @escaping(Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let data = ImageCache.shared.getMyObject(for: self as NSString) {
                completion(data)
                debugPrint("fetch from local cache")
            } else {
                guard let url = URL(string: self) else { completion(nil);return }
                let urlRequest = URLRequest(url: url)
                debugPrint("fetch from url server and save in cache")
                URLSession.shared.asyncRequest(request: urlRequest, completion: { data, response, error in
                    completion(data)
                    guard let myImageData = data else { return }
                    ImageCache.shared.cacheMy(object: myImageData, for: self)
                })
            }
        }
    }
}

extension URLSession {
    
    func syncRequest(request: URLRequest, completion: @escaping(Data?, URLResponse?, Error?) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        let task = self.dataTask(with: request) { data, response, error in
            semaphore.signal()
            completion(data, response, error)
            
        }
        task.resume()
        semaphore.wait()
        
    }
    
    func asyncRequest(request: URLRequest, completion: @escaping(Data?, URLResponse?, Error?) -> Void) {
        let task = self.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
        
    }
}

extension String {
    func prepareForFilter() -> String {
        return folding(options: .caseInsensitive, locale: .current)
            .folding(options: .regularExpression, locale: .current)
            .folding(options: .diacriticInsensitive, locale: .current)
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: ".", with: "")
    }
}

extension UIImageView {
    
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    
    func setImage(from data: Data?) {
        guard let data = data,
        let image = UIImage(data: data) else { return }
        self.image = image
    }
    
    func asyncImage(from url: String?) {
        url?.getURLImage(completion: { data in
            DispatchQueue.main.async { [weak self] in
                self?.setImage(from: data)
            }
        })
    }
    
    func getImage(from url: String) {
        image =  #imageLiteral(resourceName: "placeholderImage")
        DispatchQueue.global(qos: .userInteractive).async {
            if let imageBase64Array = UserDefaults.standard.value(forKey: url) as? [String],
            let data = Data(base64Encoded: imageBase64Array.first ?? ""),
            let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
                return
            }
            if let imageBase64 = UserDefaults.standard.value(forKey: url) as? String,
            let data = Data(base64Encoded: imageBase64),
            let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
                return
            }
            if let image: UIImage = ImageCache.shared.getImage(for: url) {
                DispatchQueue.main.async { [weak self] in
                    debugPrint("fetch from local cache")
                    self?.image = image
                }
            } else {
                
                debugPrint("fetch from url server and save in cache")
                DispatchQueue.main.async { [weak self] in
                    let activityView = UIActivityIndicatorView(style: .gray)
                    guard let url = URL(string: url) else { return }
                    self?.addSubview(activityView)
                    activityView.center = self?.center ?? .zero
                    activityView.startAnimating()
                    activityView.color = .white
                    DispatchQueue.global(qos: .userInteractive).async {
                        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async { [weak self] in
                                    self?.image = image
                                    if let data = image.base64.data(using: .utf8) {
                                        ImageCache.shared.cacheMy(object: data, for: url.absoluteString)
                                        
                                    }
                                    activityView.stopAnimating()
                                    activityView.removeFromSuperview()
                                    
                                }
                            } else {
                                DispatchQueue.main.async { [weak self] in
                                    activityView.stopAnimating()
                                    activityView.removeFromSuperview()
                                    self?.image = #imageLiteral(resourceName: "placeholderImage")
                                }
                            }
                        })
                        task.resume()
                    }
                }
                
            }
        }
    }
    
    func getAsyncImage(from url:String,completion: @escaping(UIImage?) -> Void) {
        image = #imageLiteral(resourceName: "placeholderImage")
        DispatchQueue.global(qos: .userInteractive).async {
            if let image : UIImage = ImageCache.shared.getImage(for: url){
                DispatchQueue.main.async {
                    [weak self] in
                    debugPrint("image fetched from cache")
                    self?.image = image
                    completion(image)
                }
            }
            else
            {
                debugPrint("image fetched by url from server")
                DispatchQueue.main.async { [weak self] in
                    let activityView = UIActivityIndicatorView(style: .gray)
                    guard let url = URL(string: url) else { return }
                    self?.addSubview(activityView)
                    activityView.center = self?.center ?? .zero
                    activityView.startAnimating()
                    activityView.color = .white
                    DispatchQueue.global(qos: .userInteractive).async {
                        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async { [weak self] in
                                    self?.image = image
                                    if let data = image.base64.data(using: .utf8) {
                                        ImageCache.shared.cacheMy(object: data, for: url.absoluteString)
                                    }
                                    activityView.stopAnimating()
                                    activityView.removeFromSuperview()
                                    completion(image)
                                }
                            } else {
                                DispatchQueue.main.async { [weak self] in
                                    activityView.stopAnimating()
                                    activityView.removeFromSuperview()
                                    self?.image = #imageLiteral(resourceName: "placeholderImage")
                                    completion(nil)
                                }
                            }
                        })
                        task.resume()
                    }
                }
            }
        }
    }
}

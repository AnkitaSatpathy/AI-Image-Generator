//
//  ViewController.swift
//  ImageAi
//
//  Created by Ankita Satpathy on 14/11/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var promptTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func generateImageFromPrompt(prompt: String) {
        let apiKey = ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "prompt": prompt,
            //"max_tokens": 100,
            "model": "dall-e-2",
            "size": "256x256",
            "n":1
        ]

        let apiUrl = "https://api.openai.com/v1/images/generations"
        //"https://api.openai.com/v1/engines/davinci/generate"

        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonResponse = value as? [String: Any],
                       let imageUrlString = jsonResponse["image"] as? String,
                       let imageUrl = URL(string: imageUrlString) {
                        self.downloadImage(from: imageUrl)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }

    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                print("Failed to download image:", error?.localizedDescription ?? "Unknown error")
            }
        }.resume()
    }

    @IBAction func btnTapped(_ sender: Any) {
        guard let promt = promptTextview.text else { return }
        generateImageFromPrompt(prompt: promt)
    }
    
}


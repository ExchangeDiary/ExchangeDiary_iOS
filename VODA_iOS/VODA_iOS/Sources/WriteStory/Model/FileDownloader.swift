//
//  FileDownloader.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/09/07.
//

import UIKit

public class FileDownloader: NSObject {
    public static let shared = FileDownloader()
    
    private override init() {
        super.init()
    }
    
    func downloadFileFromUrl(from downloadUrl: URL, to destinationUrl: URL) {
        URLSession.shared.downloadTask(with: downloadUrl, completionHandler: { [weak self] (location, response, error) in
            guard let location = location, error == nil,
                  let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                return
            }
            do {
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                print("File moved to document folder")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }).resume()
    }
}

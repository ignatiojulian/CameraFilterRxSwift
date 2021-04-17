//
//  FilterService.swift
//  CameraFilter
//
//  Created by Ignatio Julian on 17/04/21.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filterImage in
                observer.onNext(filterImage)
            }
            return Disposables.create()
        }
    }
    
    func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        let sourceImage = CIImage(image: inputImage)
        
        filter.setValue(sourceImage, forKey: kCIInputImageKey)
        
        if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
            let processingImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            completion(processingImage)
        }
    }
}

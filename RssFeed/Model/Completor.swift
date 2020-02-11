import Foundation

struct Completor {
   
   var onComplete: (()->Void)?
   var onError: ((Error)->Void)?
   var onSuccess: (()->Void)?
   var onImagesComplete: (()->Void)?
    
    func complete() {
        if let onComplete = self.onComplete {
            onComplete()
        }
    }
    func error(_ e: Error) {
        if let onError = self.onError {
            onError(e)
        }
    }
    func success() {
        if let onSuccess = self.onSuccess {
            onSuccess()
        }
    }
    func imagesComplete() {
        if let onImagesComplete = self.onImagesComplete {
            onImagesComplete()
        }
    }
    func successfullyComplete() {
        success()
        complete()
    }
    func unsuccessfullyComplete(_ e: Error) {
        error(e)
        complete()
    }
}

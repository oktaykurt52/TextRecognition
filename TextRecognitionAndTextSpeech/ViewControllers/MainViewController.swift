//
//  ViewController.swift
//  TextRecognitionAndTextSpeech
//
//  Created by Oktay on 9.12.2019.
//  Copyright © 2019 Oktay Kurt. All rights reserved.
//

import UIKit
import Vision

class MainViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectedImageForRecognition: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    // MARK: - Stored Properties
    var finalTextForSpeech = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = "Welcome! Let's pick a image before we start"
    }
    
    // MARK: - Functions
    // func decleration with image and recognition level parameters
    func performOCR(on image: UIImage?, recognitionLevel: VNRequestTextRecognitionLevel)  {
        // We set the image in cgImage format
        guard let image = image?.cgImage else { return }
        // And we define the Vision ImageRequestHandler
        let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
        // Then we define the Vision Text recognition request with error handling parameters
        let request = VNRecognizeTextRequest  { (request, error) in
            // Error handling
            if let error = error {
                print(error)
                return
            }
            // 'Observations' are the all rows that recognized texts and we store them in '[VNRecognizedTextObservation]' array
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            // We start a for loop for handling the every line of observed texts and we set them into our 'finalTextForSpeech' input
            for currentObservation in observations {
                let topCandidate = currentObservation.topCandidates(1)
                if let recognizedText = topCandidate.first {
                    // NOTE: TextRecognition performs until no textLine left to observe. So we use '+=' operator to store every text line that we observed
                    self.finalTextForSpeech += recognizedText.string
                }
                
            }
            // Print for debugging
            print(self.finalTextForSpeech)
            // Activity indicator for process
            self.activityIndicator.stopAnimating()
            
        }
        // Request's 'TextRecognition' recognition level (Accurate and Fast)
        request.recognitionLevel = recognitionLevel
        // Performing the TextRecognition request
        try? requestHandler.perform([request])
    }
    // MARK: - Actions
    @IBAction func takePhoto(_ sender: Any) {
        // TODO: Image picking action has started
        // Present a action sheet for imagePicking alternatives
        let imagePickerActionSheet =
            UIAlertController(title: "Photo picking alternatives", message: nil, preferredStyle: .actionSheet)
        // We control with a 'isSourceTypeAvailable' class func if camera is available or not
        // NOTE: If we use a simulator, Camera will not be available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // 1
            let pickWithCamera = UIAlertAction (
                title: "Camera",
                style: .default) { (alert) -> Void in
                    // TODO: Image picker configuration
                    // 1.1
                    self.activityIndicator.startAnimating()
                    // 1.2
                    let imagePicker = UIImagePickerController()
                    // 1.3
                    imagePicker.delegate = self
                    // 1.4
                    imagePicker.sourceType = .camera
                    // 1.5
                    imagePicker.allowsEditing = false
                    // 1.6
                    self.present(imagePicker, animated: true, completion: {
                        // 1.7
                        self.activityIndicator.stopAnimating()
                    })
                    
            }
            // 1.8
            imagePickerActionSheet.addAction(pickWithCamera)
            
        }
        
        // 2
        let pickFromLibrary = UIAlertAction(
            title: "Library",
            style: .default) { (alert) -> Void in
                // TODO: Image picker configuration
                // 2.1
                self.activityIndicator.startAnimating()
                // 2.2
                let imagePicker = UIImagePickerController()
                // 2.3
                imagePicker.delegate = self
                // 2.4
                imagePicker.sourceType = .photoLibrary
                // 2.5
                imagePicker.allowsEditing = false
                // 2.6
                self.present(imagePicker, animated: true, completion: {
                    // 2.7
                    self.activityIndicator.stopAnimating()
                })
                
        }
        // 2.8
        imagePickerActionSheet.addAction(pickFromLibrary)
        // 3
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        // 4
        present(imagePickerActionSheet, animated: true)
        
    }
}
// Extension area
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // TODO: Add more code here...
        // The image that picked from imagePickerController (with a guard statement)
        // NOTE: We will have a 'defined but never used' warning for selectedPhoto because we fill our image with our test object from assets folder so pay no attention
        guard let selectedPhoto = info[.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }
        // We use our test image from assests for text recognition (Not the image of picker)
        selectedImageForRecognition.image = UIImage(named: "Test7")
        // Activity indicator starts
        activityIndicator.startAnimating()
        // We inform the user about process with a label
        self.statusLabel.text = "Please wait while image is processing..."
        // Dismiss view and perform recognition and segue for the final viewController
        dismiss(animated: true) {
            self.performOCR(on: UIImage(named: "Test7"), recognitionLevel: .accurate)
            self.performSegue(withIdentifier: "GoToListeningScene", sender: self.finalTextForSpeech)
        }
        
        
        
    }
    // The override func for passing the data to destination viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToListeningScene" {
            if let destination = segue.destination as? ListeningViewController {
                destination.finalTextForSpeech = finalTextForSpeech
            }
        }
    }
    
}



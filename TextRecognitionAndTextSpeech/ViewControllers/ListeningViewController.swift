//
//  ListeningViewController.swift
//  TextRecognitionAndTextSpeech
//
//  Created by Oktay on 10.12.2019.
//  Copyright © 2019 Oktay Kurt. All rights reserved.
//

import UIKit
import AVFoundation

class ListeningViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Stored Properties
    var finalTextForSpeech = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = "Here is the recognized text of test object!"
        
        textView.text = finalTextForSpeech
    }
    
    // MARK: - Functions
    
}

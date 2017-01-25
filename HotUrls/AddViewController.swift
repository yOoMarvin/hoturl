//
//  AddViewController.swift
//  HotUrls
//
//  Created by Marvin Messenzehl on 22.01.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import UIKit
import Speech

class AddViewController: UIViewController {
    
    var delegate: HotUrlDelegate?

    
    //speech input handled in controller here... 
    //should not be done in real world up but is ok for this purpose
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    //outlets for Audio Button elements
    @IBOutlet weak var nameAudioBtn: UIButton!
    @IBOutlet weak var urlAudioBtn: UIButton!
    
    //Outlets for text field elements
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    
    //button actions
    @IBAction func nameButtonTapped(_ sender: Any) {
        speechInput(forField: nameInput, andButton: nameAudioBtn)
    }
    
    @IBAction func urlButtonTapped(_ sender: Any) {
        speechInput(forField: urlInput, andButton: urlAudioBtn)
    }
    
    //save action
    @IBAction func saveTapped(_ sender: Any) {
        guard let name = nameInput.text,
            let url = urlInput.text else {
            print("name or url not set")
            return
        }
        //let hotUrl = HotUrl(name: name, url: url, comment: comment)
        delegate?.hotUrlAdded(withName: name, andUrl: url)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    //error function for showing error as an alert
    private func showError(_ errorMsg: String) {
        let alert = UIAlertController(title: "Fehler", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    //help functions for changing the button graphic when recording
    private func setRecordingImage(forButton: UIButton){
        forButton.setImage(UIImage(named:"micro-recording"), for: .normal)
    }
    private func setDefaultImage(forButton: UIButton){
        forButton.setImage(UIImage(named:"micro-default"), for: .normal)
    }
    private func resetButtons() {
        setDefaultImage(forButton: nameAudioBtn)
        setDefaultImage(forButton: urlAudioBtn)
    }
    
    
    private func speechInput(forField: UITextField, andButton: UIButton) {
        //if audio is running, stop it
        if audioEngine.isRunning{
            audioEngine.stop()
            recognitionRequest?.endAudio()
            //set default image, when recording is stopped
            setDefaultImage(forButton: andButton)
        } else {
            //start recording process, set button to recording
            setRecordingImage(forButton: andButton)
            do {
            try getTranscription{
                (transcript) in
                //set the button. self because of closure method
                self.setDefaultImage(forButton: andButton)
                //write value of transcript in textField
                forField.text = transcript
            }
            } catch let error as NSError {
                //show error as alert                
                showError(error.localizedDescription)
                
                //set the button to default
                setDefaultImage(forButton: andButton)
            }
        }
    }
    
    
    
    private func getTranscription(withHandler: @escaping(_ transcript: String) -> ()) throws{
        //kill old task
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        //record audio
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        //request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            //alert
            self.showError("no input node found")
            //reset buttons
            self.resetButtons()
            return
        }
        
        guard let recognitionRequest = recognitionRequest else {
            print("Could not make request")
            //reset buttons
            self.resetButtons()
            return
        }
        
        recognitionRequest.shouldReportPartialResults = false
        
        //get mic action
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format){
            (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
        }
        
        //tansform speech to text
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest,
                                                           resultHandler: { (result, error) in
            //remember: this is result handler! called in the end!, not now
            //stop recording
            self.audioEngine.stop()
            inputNode.removeTap(onBus: 0)
            
            self.recognitionRequest = nil
            self.recognitionTask = nil
            
            guard error == nil else {
                //alert
                self.showError("Could not create transcript")
                //reset buttons
                self.resetButtons()
                return
            }
            
            if let result = result {
                //call completion handler from transcript method and get string
                withHandler(result.bestTranscription.formattedString)
            }
        })
        
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
   }

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

    
    //speech input handled in controller here... 
    //should not be done in real world up but is ok for this purpose
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    //outlets for ui elements
    @IBOutlet weak var nameAudioBtn: UIButton!
    @IBOutlet weak var urlAudioBtn: UIButton!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    
    //button actions
    @IBAction func nameButtonTapped(_ sender: Any) {
        speechInput(forField: nameInput, andButton: nameAudioBtn)
    }
    
    @IBAction func urlButtonTapped(_ sender: Any) {
        speechInput(forField: urlInput, andButton: urlAudioBtn)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    
    
    private func speechInput(forField: UITextField, andButton: UIButton) {
        //if audio is running, stop it
        if audioEngine.isRunning{
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            do {
            try getTranscription{
                (transcript) in
                //write value of transcript in textField
                forField.text = transcript
            }
            } catch let error as NSError {
                //todo: give error with alert
                print(error.localizedDescription)
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
            //todo: alert
            print("no input node found")
            
            return
        }
        
        guard let recognitionRequest = recognitionRequest else {
            print("Could not make request")
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
                //todo: alert
                print("Could not create transcript")
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

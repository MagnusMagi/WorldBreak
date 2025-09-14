//
//  VoiceSearchManager.swift
//  NewsLocal
//
//  Created by Magnus Magi on 2024.
//  Copyright © 2024 NewsLocal. All rights reserved.
//

import Foundation
import AVFoundation
import Speech
import Combine

/// Manager for handling voice search functionality
@MainActor
class VoiceSearchManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var transcribedText: String = ""
    @Published var statusText: String = "Tap to start voice search"
    @Published var isRecording: Bool = false
    @Published var hasPermission: Bool = false
    
    // MARK: - Private Properties
    
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession = AVAudioSession.sharedInstance()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
        checkPermissions { _ in }
    }
    
    // MARK: - Public Methods
    
    /// Check microphone and speech recognition permissions
    func checkPermissions(completion: @escaping (Bool) -> Void) {
        let microphoneStatus = AVAudioSession.sharedInstance().recordPermission
        let speechStatus = SFSpeechRecognizer.authorizationStatus()
        
        switch (microphoneStatus, speechStatus) {
        case (.granted, .authorized):
            hasPermission = true
            completion(true)
        case (.denied, _), (_, .denied):
            hasPermission = false
            completion(false)
        case (.undetermined, _):
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.checkPermissions(completion: completion)
                    } else {
                        self.hasPermission = false
                        completion(false)
                    }
                }
            }
        case (_, .notDetermined):
            SFSpeechRecognizer.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.checkPermissions(completion: completion)
                    } else {
                        self.hasPermission = false
                        completion(false)
                    }
                }
            }
        default:
            hasPermission = false
            completion(false)
        }
    }
    
    /// Start voice recording and recognition
    func startRecording(completion: @escaping (Result<Void, Error>) -> Void) {
        guard hasPermission else {
            completion(.failure(VoiceSearchError.noPermission))
            return
        }
        
        // Stop any existing recording
        stopRecording()
        
        do {
            // Configure audio session
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Create recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else {
                completion(.failure(VoiceSearchError.recognitionRequestFailed))
                return
            }
            
            recognitionRequest.shouldReportPartialResults = true
            
            // Create recognition task
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                DispatchQueue.main.async {
                    if let result = result {
                        self?.transcribedText = result.bestTranscription.formattedString
                        
                        if result.isFinal {
                            self?.stopRecording()
                        }
                    }
                    
                    if let error = error {
                        self?.statusText = "Recognition error: \(error.localizedDescription)"
                        self?.stopRecording()
                    }
                }
            }
            
            // Configure audio engine
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            isRecording = true
            statusText = "Listening... Speak now"
            completion(.success(()))
            
        } catch {
            statusText = "Recording failed: \(error.localizedDescription)"
            completion(.failure(error))
        }
    }
    
    /// Stop voice recording and recognition
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
        
        isRecording = false
        statusText = transcribedText.isEmpty ? "Tap to start voice search" : "Tap to search again"
    }
    
    /// Clear transcribed text
    func clearText() {
        transcribedText = ""
        statusText = "Tap to start voice search"
    }
}

// MARK: - SFSpeechRecognizerDelegate

extension VoiceSearchManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        DispatchQueue.main.async {
            self.statusText = available ? "Tap to start voice search" : "Speech recognition not available"
        }
    }
}

// MARK: - Voice Search Error

enum VoiceSearchError: LocalizedError {
    case noPermission
    case recognitionRequestFailed
    case audioEngineFailed
    case speechRecognitionFailed
    
    var errorDescription: String? {
        switch self {
        case .noPermission:
            return "Microphone and speech recognition permissions are required"
        case .recognitionRequestFailed:
            return "Failed to create speech recognition request"
        case .audioEngineFailed:
            return "Failed to start audio engine"
        case .speechRecognitionFailed:
            return "Speech recognition failed"
        }
    }
}

// MARK: - Extensions

extension VoiceSearchManager {
    /// Mock data for previews
    static let mock = VoiceSearchManager()
}

//
//  RecordSmashViewController.swift
//  DubSwag
//
//  Created by Talha Babar on 8/7/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import MediaPlayer

class RecordSmashViewController: UIViewController, EZMicrophoneDelegate, EZRecorderDelegate, AVMergerDelegate {

    enum ButtonsState {
        case Onload
        case MicTapped
        case StopTapped
    }
    
    @IBOutlet weak var recordingAudioPlot: EZAudioPlot!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    
    
    var btnstate : ButtonsState = .Onload {
        didSet {
            updateAppearance()
        }
    }
    
    var mic: EZMicrophone!
    var recorder: EZRecorder!
    var audioRecorder: AVAudioRecorder!
    var isRecording = false
    var moviePlayer: MPMoviePlayerController!
    var videoURL: NSURL!
    var progressHUD: MBProgressHUD!
    var audioFileName = "recordedAudio"
    var recordedAudioExtension = "wav"
    var videoName: String?
    var videoExtension: String?
    var audioOutputFilePath: NSURL?
    var smashURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAppearance()
        self.progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Preparing..."
        //loadMoviePlayer(videoURL)
        moviePlayer = MediaManager.loadMoviePlayer(videoURL, playerView: playerView)
        var videoFullName = videoURL.lastPathComponent
        videoName = videoFullName?.stringByDeletingPathExtension
        println(videoName)
        videoExtension = videoFullName?.pathExtension
        println(videoExtension)
        var session = AVAudioSession.sharedInstance()
        var error = NSErrorPointer()
        session.setCategory(AVAudioSessionCategoryRecord, error: error)
        if (error != nil){
            println("ERROR: setting up audio session Category: \(error.debugDescription)")
        }
        session.setActive(true, error: error)
        if(error != nil){
            println("ERROR: setting up audio session active: \(error.debugDescription)")
        }
        
        self.recordingAudioPlot.backgroundColor = UIColor(red: 0.984, green: 0.71, blue: 0.365, alpha: 1)
        self.recordingAudioPlot.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.recordingAudioPlot.plotType = EZPlotType.Rolling
        self.recordingAudioPlot.shouldFill = true
        self.recordingAudioPlot.shouldMirror = true
        self.recordingAudioPlot.sizeToFit()
        mic = EZMicrophone(delegate: self)
        mic.stopFetchingAudio()
        moviePlayer.pause()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackStateChanged:", name: "MPMoviePlayerLoadStateDidChangeNotification",object:  moviePlayer)
    }

    func filePathURL() -> NSURL {
        var dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        var docsDir = dirPath[0] as! NSString
        var outputFilePth = docsDir.stringByAppendingPathComponent("recordedAudio.m4a")
        var audioOutputURL = NSURL.fileURLWithPath(outputFilePth)
        return audioOutputURL!
    }
    
    @IBAction func microphoneButtonTapped(sender: AnyObject) {
        self.btnstate = .MicTapped
        moviePlayer.play()
        self.recordingAudioPlot.clear()
        self.mic.startFetchingAudio()
        self.recorder = EZRecorder(URL: self.filePathURL(), clientFormat: self.mic.audioStreamBasicDescription(), fileType: EZRecorderFileType.M4A, delegate: self)
        audioOutputFilePath = self.AudiofilePathURL()
        audioRecorder = AVAudioRecorder(URL: audioOutputFilePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
        self.isRecording = true
   }
    
    @IBAction func stopButtonTapped(sender: AnyObject) {
        self.btnstate = .StopTapped
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Preparing your SMASH...."
        moviePlayer.pause()
        self.mic.stopFetchingAudio()
        self.recorder.closeAudioFile()
        var audioFile = EZAudioFile(URL: self.filePathURL())
        println("audio file finalized")
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
       //var merger = AVMerger(audioName: "recordedAudio", audioType: "wav", videoName: videoName!, videoType: videoExtension!)
       var merger = AVMerger(audioURL: audioOutputFilePath!, videoURL: videoURL)
        merger.merge()
        merger.delegate = self
        smashURL = merger.exportEditedVideo(self)
        
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.recordingAudioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize);
        });
    }
    
    func AudiofilePathURL() -> NSURL {
        var dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        var docsDir = dirPath[0] as! NSString
        var outputFilePth = docsDir.stringByAppendingPathComponent("recordedAudio.wav")
        var outputURL = NSURL.fileURLWithPath(outputFilePth)
        if (NSFileManager.defaultManager().fileExistsAtPath(outputFilePth)) {
            NSFileManager.defaultManager().removeItemAtPath(outputFilePth, error: nil)
        }
        return outputURL!
    }
    
    func updateAppearance() {
        switch self.btnstate {
        case .Onload:
            microphoneButton.hidden = true
            stopButton.hidden = true
            cancelButton.hidden = true
        case .MicTapped:
            microphoneButton.hidden = true
            stopButton.hidden = false
            cancelButton.hidden = false
        case .StopTapped:
            microphoneButton.hidden = false
            stopButton.hidden = true
            cancelButton.hidden = true
        }
    }
        
    func moviePlayBackStateChanged(notification:NSNotification){
        if moviePlayer.loadState == MPMovieLoadState.PlaythroughOK{
        btnstate = .StopTapped
        self.progressHUD.hidden = true
        }
    }
    
    func exportDidEnd() {
        self.progressHUD.hidden = true
        if let smashURL = self.smashURL
        {
        Router.showPlaySmashViewController(self, smashURL: smashURL)
        }
        else
        {
            println("ERROR: No URL of smash")
        }
    }
    
}

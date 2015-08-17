//
//  AVMerger.swift
//  AVMerger
//
//  Created by Talha Babar on 7/30/15.
//  Copyright (c) 2015 Talha Babar. All rights reserved.
//

import UIKit
import AssetsLibrary
import AVFoundation

protocol AVMergerDelegate {
    func exportDidEnd()
}

class AVMerger: NSObject {
    private var videoAsset: AVURLAsset?
    private var audioAsset: AVURLAsset?
    private var smackAsset: AVURLAsset?
    private var smashAsset: AVURLAsset?
    private var mixComposition = AVMutableComposition()
    private var assetExport: AVAssetExportSession?
    var delegate: AVMergerDelegate?
    var outputURL: NSURL?
    let audioURL: NSURL?
    let videoURL: NSURL?
    let editedVideoName: NSString = "FinalVideo"
    let editedVideoType: NSString = "mov"
    
    init(audioName: NSString,audioType: NSString,videoName: NSString, videoType: NSString) {
        audioURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(audioName as String, ofType: audioType as String)!)
        videoURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(videoName as String, ofType: videoType as String)!)
        
    }
    
    override init() {
        self.audioURL = nil
        self.videoURL = nil
    }
    
    init(audioURL: NSURL, videoURL: NSURL) {
        self.audioURL = audioURL
        self.videoURL = videoURL
    }
    
    init(videoURL: NSURL){
        self.videoURL = videoURL
        self.audioURL = nil
    }
    
    func merge() {
        audioAsset = AVURLAsset(URL: audioURL, options: nil)
        var audioTimeRange = CMTimeRange(start: kCMTimeZero, duration: audioAsset!.duration)
        var b_compositionAudioTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        b_compositionAudioTrack.insertTimeRange(audioTimeRange, ofTrack: audioAsset!.tracksWithMediaType(AVMediaTypeAudio)[0] as! AVAssetTrack, atTime: kCMTimeZero, error: nil)
       videoAsset = AVURLAsset(URL: videoURL, options: nil)
        var videoTimeRange = CMTimeRange(start: kCMTimeZero, duration: videoAsset!.duration)
        
        var a_compositionVideoTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        a_compositionVideoTrack.insertTimeRange(audioTimeRange, ofTrack: videoAsset!.tracksWithMediaType(AVMediaTypeVideo)[0] as! AVAssetTrack, atTime: kCMTimeZero, error: nil)
        
        
    }
    
    func exportEditedVideo(FromViewController: UIViewController, shouldSaveToLibrary : Bool = false) -> NSURL {
        var dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        var docsDir = dirPath[0] as! NSString
        var outputFilePth = docsDir.stringByAppendingPathComponent("\(editedVideoName).\(editedVideoType)")
        self.outputURL = NSURL.fileURLWithPath(outputFilePth)
        if (NSFileManager.defaultManager().fileExistsAtPath(outputFilePth)) {
            NSFileManager.defaultManager().removeItemAtPath(outputFilePth, error: nil)
        }
        assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)
        assetExport!.outputFileType = "com.apple.quicktime-movie"
        assetExport!.outputURL = self.outputURL
        
        assetExport!.exportAsynchronouslyWithCompletionHandler({
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.exportDidEnd()
                println("I am called")
            })
        })
        return self.outputURL!
    }
    
    static func saveToLibrary(FromViewController: UIViewController, outputURL: NSURL) {
//        if(assetExport!.status == AVAssetExportSessionStatus.Completed) {
//            var outputURL = assetExport!.outputURL
            var library = ALAssetsLibrary()
            if(library.videoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL)) {
                library.writeVideoAtPathToSavedPhotosAlbum(outputURL, completionBlock: { (assetURL: NSURL!, error:NSError!) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if((error) != nil) {
                            var alert = UIAlertController(title: "Error", message: "Video Saving Failed", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            FromViewController.presentViewController(alert, animated: true, completion: nil)
                        }
                        else {
                            var alert = UIAlertController(title: "Video Saved", message: "Saved To Photo Album", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            FromViewController.presentViewController(alert, animated: true, completion: nil)
                            //self.delegate?.exportDidEnd()
                        }
                    })
                })
            }
//        }
    }
    
    func removeAudio() {
        videoAsset = AVURLAsset(URL: videoURL, options: nil)
        var videoTimeRange = CMTimeRange(start: kCMTimeZero, duration: videoAsset!.duration)
        
        var a_compositionVideoTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        a_compositionVideoTrack.insertTimeRange(videoTimeRange, ofTrack: videoAsset!.tracksWithMediaType(AVMediaTypeVideo)[0] as! AVAssetTrack, atTime: kCMTimeZero, error: nil)
        
    }
    
    func exportVideoAt() {
        var dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        var docsDir = dirPath[0] as! NSString
        var videoName = videoURL!.lastPathComponent
        var outputFilePth = docsDir.stringByAppendingPathComponent("\(videoName!.stringByDeletingPathExtension).\(videoName!.pathExtension)")
        self.outputURL = NSURL.fileURLWithPath(outputFilePth)
        if (NSFileManager.defaultManager().fileExistsAtPath(outputFilePth)) {
            NSFileManager.defaultManager().removeItemAtPath(outputFilePth, error: nil)
        }
        assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)
        assetExport!.outputFileType = "com.apple.quicktime-movie"
        assetExport!.outputURL = self.outputURL
        
        assetExport!.exportAsynchronouslyWithCompletionHandler({
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                println("Video Exported")
                self.delegate?.exportDidEnd()
            })
        })

    }
    
    func mergeVideos(smashURL: NSURL, smackURL: NSURL) {
        var currentCMTime = kCMTimeZero
        smashAsset = AVURLAsset(URL: smashURL, options: nil)
        var smashTimeRange = CMTimeRange(start: kCMTimeZero, duration: smashAsset!.duration)
        var smashAudioTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
       smashAudioTrack.insertTimeRange(smashTimeRange, ofTrack: smashAsset!.tracksWithMediaType(AVMediaTypeAudio)[0] as! AVAssetTrack, atTime: kCMTimeZero, error: nil)
        var smashVideoTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        smashVideoTrack.insertTimeRange(smashTimeRange, ofTrack: smashAsset!.tracksWithMediaType(AVMediaTypeVideo)[0] as! AVAssetTrack, atTime: kCMTimeZero, error: nil)
        currentCMTime = CMTimeAdd(currentCMTime, smashAsset!.duration)
        smackAsset = AVURLAsset(URL: smackURL, options: nil)
        var smackTimeRange = CMTimeRange(start: kCMTimeZero, duration: smackAsset!.duration)
        var smackAudioTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        smackAudioTrack.insertTimeRange(smackTimeRange, ofTrack: smackAsset!.tracksWithMediaType(AVMediaTypeAudio)[0] as! AVAssetTrack, atTime: currentCMTime, error: nil)
        var smackVideoTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        smackVideoTrack.insertTimeRange(smackTimeRange, ofTrack: smackAsset!.tracksWithMediaType(AVMediaTypeVideo)[0] as! AVAssetTrack, atTime: currentCMTime, error: nil)
        
     }
    
    func createSmack(smackURL: NSURL) -> NSURL {
        smackAsset = AVURLAsset(URL: smackURL, options: nil)
        var duration = CMTimeMake(5, 1)
        var smackTimeRange = CMTimeRange(start: kCMTimeZero, duration: duration)
        var smackAudioTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        smackAudioTrack.insertTimeRange(smackTimeRange, ofTrack: smackAsset!.tracksWithMediaType(AVMediaTypeAudio)[0] as! AVAssetTrack, atTime: kCMTimeZero, error: nil)
        var smackVideoTrack = self.mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        smackVideoTrack.insertTimeRange(smackTimeRange, ofTrack: smackAsset!.tracksWithMediaType(AVMediaTypeVideo)[0] as! AVAssetTrack, atTime: kCMTimeZero, error: nil)
        var dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        var docsDir = dirPath[0] as! NSString
        var videoName = smackURL.lastPathComponent
        var outputFilePth = docsDir.stringByAppendingPathComponent("\(videoName!.stringByDeletingPathExtension).\(videoName!.pathExtension)")
        var outputSmackURL = NSURL.fileURLWithPath(outputFilePth)
        if (NSFileManager.defaultManager().fileExistsAtPath(outputFilePth)) {
            NSFileManager.defaultManager().removeItemAtPath(outputFilePth, error: nil)
        }
        assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetMediumQuality)
        assetExport!.outputFileType = "com.apple.quicktime-movie"
        assetExport!.outputURL = outputSmackURL
        
        assetExport!.exportAsynchronouslyWithCompletionHandler({
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                println("Smack Exported")
                self.delegate?.exportDidEnd()
            })
        })
        return outputSmackURL!
    }
    

}

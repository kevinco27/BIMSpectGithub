//
//  RecorderViewController.swift
//  BIMSpectGithub
//
//  Created by kai on 2016/1/4.
//  Copyright © 2016年 kai. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class RecorderViewController: UIViewController {

    var item:Item!
    var recordItem : ItemRecord?
    var audioRecorder:AVAudioRecorder!
    var audioPlayer :AVAudioPlayer!
    var recorderDescription :UILabel!
    var playerDescription : UILabel!
    var appdelegate : AppDelegate!
    var context : NSManagedObjectContext!
    var recordButton : UIButton!
    var pauseButton : UIButton!
    var playButton : UIButton!
    var stopButton : UIButton!
    var timer :NSTimer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "receiveSomethingFromDetailView:", name: "item", object: nil)
        
        //取得Audio session
        let audioSession = AVAudioSession.sharedInstance()
        
        //指定Audio session 可以錄音(預設不行錄音)
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:
                .DefaultToSpeaker)
            
            //如果沒錯誤的話，可以開始錄音
            
            //設定 錄音檔 路徑
            let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
            audioFileURL = directoryURL?.URLByAppendingPathComponent("record.m4a")
            
            //設定 錄音檔 格式
            let recorderSetting:[String:AnyObject] = [ AVFormatIDKey:NSNumber(unsignedInt:kAudioFormatMPEG4AAC), AVSampleRateKey: 44100.0, AVNumberOfChannelsKey: 2]
            
            audioRecorder = try? AVAudioRecorder(URL: audioFileURL!, settings: recorderSetting)
            
            // 準備錄音
            audioRecorder?.prepareToRecord()
            
        }catch{
            
        }
        
    }
    
    func receiveSomethingFromDetailView(noti:NSNotification){
        self.item = noti.object as! Item
    }
    
    override func viewWillAppear(animated: Bool) {
       
        //load record
        appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appdelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "ItemRecord")
        request.predicate = NSPredicate(format: "itemId = %@", item.itemId!)
        
        recordItem = try! context.executeFetchRequest(request).first as? ItemRecord
        
        //put subviews on the RecorderViewController
        if recordItem == nil{ // first time show up witout recordItem existing
            
            recorderDescription = UILabel()
            recorderDescription.text = "Click to start record"
            recorderDescription.font = UIFont(name: "Helvetica", size: CGFloat(15))
            let size = recorderDescription.sizeThatFits(CGSize(width: 98, height: 13))
            recorderDescription.frame = CGRect(origin: CGPoint(x: 32, y: 39), size: size)
            self.view.addSubview(recorderDescription)
            
            recordButton = UIButton()
            recordButton.backgroundColor = UIColor(patternImage: UIImage(named: "recordButton")!)
            recordButton.frame = CGRect(x: 80, y: 64, width: 47, height: 47)
            
            recordButton.addTarget(self, action: "recording", forControlEvents: .TouchUpInside)
            self.view.addSubview(recordButton)
            
        }else{
            recorderDescription = UILabel()
            recorderDescription.text = "Click to record again"
            recorderDescription.font = UIFont(name: "Helvetica", size: CGFloat(12))
            let recorderDescriptionSize = recorderDescription.sizeThatFits(CGSize(width: 98, height: 13))
            recorderDescription.frame = CGRect(origin: CGPoint(x: 10, y: 22), size: recorderDescriptionSize)
            self.view.addSubview(recorderDescription)
            
            recordButton = UIButton()
            recordButton.frame = CGRect(x: 122, y: 7, width: 47, height: 47)
            recordButton.backgroundColor = UIColor(patternImage: UIImage(named: "recordButton")!)
            recordButton.addTarget(self, action: "recording", forControlEvents: .TouchUpInside)
            self.view.addSubview(recordButton)
            
            do{
                audioPlayer = try AVAudioPlayer(data: recordItem!.record!)
            }catch let error as NSError {
                print(error)
            }

            let totalTime = String(format: "%02d:%02d", Int(audioPlayer.duration/60), Int(audioPlayer.duration%60))
            
            playerDescription = UILabel()
            playerDescription.text = "00:00/\(totalTime)"
            playerDescription.font = UIFont(name: "Helvetica", size: CGFloat(15))
            let playerDescriptionSize =
            playerDescription.sizeThatFits(CGSize(width: 98, height: 13))
            playerDescription.frame = CGRect(origin: CGPoint(x: 62, y: 70), size: playerDescriptionSize)
            self.view.addSubview(playerDescription)
            
            pauseButton = UIButton()
            pauseButton.frame = CGRect(x: 49, y: 92, width: 22, height: 22)
            pauseButton.backgroundColor = UIColor(patternImage: UIImage(named: "pauseButton")!)
            pauseButton.addTarget(self, action: "pause", forControlEvents: .TouchUpInside)
            self.view.addSubview(pauseButton)
            
            playButton = UIButton()
            playButton.frame = CGRect(x: 85, y: 86, width: 33, height: 33)
            playButton.backgroundColor = UIColor(patternImage: UIImage(named: "playButton")!)
            playButton.addTarget(self, action: "play", forControlEvents: .TouchUpInside)
            self.view.addSubview(playButton)
            
            stopButton = UIButton()
            stopButton.frame = CGRect(x: 131, y: 92, width: 22, height: 22)
            stopButton.backgroundColor = UIColor(patternImage: UIImage(named: "stopButton")!)
            stopButton.addTarget(self, action: "stop", forControlEvents: .TouchUpInside)
            self.view.addSubview(stopButton)
        }
    }
    
    var isRecording : Bool = false
    var audioFileURL : NSURL!
    func recording(){
        
        if isRecording == false { //start recording
           
            if let recorder = audioRecorder where !recorder.recording{
                
                let audioSession = AVAudioSession.sharedInstance()
                
                if let _ = try? audioSession.setActive(true){
                    //到這裡就表示可以錄音
                    print("開始錄音")
                    
                    //錄音
                    recorder.record()
                    let userInfo = [ audioRecorder!, recorderDescription]
                    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: userInfo, repeats: true)
                    
                }
                
            }
            
            isRecording = true
            
        }else{ //stop recording
            
            let stopRecordAlert = UIAlertController(title: "Stop recording", message: "Would you want to stop recording?", preferredStyle: .Alert)
            
            stopRecordAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            stopRecordAlert.addAction(UIAlertAction(title: "Stop", style: .Destructive, handler: { (UIAlertAction) -> Void in
                
                //stop timer and reset currentTime
                self.timer?.invalidate()
                self.currentTime = -1
                self.audioRecorder!.stop()
                let audioSession = AVAudioSession.sharedInstance()
                if let _ = try? audioSession.setActive(false){}
                if self.recordItem == nil{
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    self.recorderDescription.text = "Click to record again"
                    self.isRecording = false
                }
                 self.saveRecord()
                    print("complete saving record")
            }))
            
             presentViewController(stopRecordAlert, animated: true, completion: nil)
        }
    }
    
    func saveRecord(){
        
        //save record to coredata
        
        if recordItem == nil{
        recordItem = ItemRecord(entity: NSEntityDescription.entityForName("ItemRecord", inManagedObjectContext: self.context)!, insertIntoManagedObjectContext: self.context)
            print("ItemRecord entity created")
        }
        recordItem!.itemId = self.item.itemId
        recordItem!.createDateTime = NSDate()
        print(NSDate())
        recordItem!.itemRecordId = { ()-> NSNumber in
            
            let fetchRequest = NSFetchRequest(entityName: "ItemRecord")
            fetchRequest.fetchLimit = 1
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "itemRecordId", ascending: false)]
            
            let data:ItemRecord!
            do
            {
                // 將查詢結果 存入 data
                data = try self.context.executeFetchRequest(fetchRequest).first as? ItemRecord
            }
            catch
            {
                return NSNumber(integer: 0)
            }
            
            let id = Int(data.itemRecordId!) + 1
            return  NSNumber(integer: id)
            }()
        
        print("The NSData of record : \(NSData(contentsOfURL: self.audioFileURL))")
        recordItem!.record = NSData(contentsOfURL: self.audioFileURL)
        self.appdelegate.saveContext()
    }
    
    var currentTime:Int = -1
    var currentTimeInMinSec:String!
    func updateTime(timer:NSTimer){
        
        let object = timer.userInfo as! [AnyObject]
        let audioObject = object[0]
        let Label = object[1] as! UILabel
        
        if let recorder = audioObject as? AVAudioRecorder{
            currentTime = ++currentTime
           currentTimeInMinSec = String(format: "%02d:%02d", currentTime/60, currentTime%60)
            Label.text = "Recording...\(currentTimeInMinSec)"
        }else{
            
            let player = audioObject as! AVAudioPlayer
            currentTimeInMinSec = String(format: "%02d:%02d", Int(player.currentTime/60), Int(player.currentTime%60))
            let totalTimeInMunSec = String(format: "%02d:%02d", Int(player.duration/60), Int(player.duration%60))
            Label.text = "\(currentTimeInMinSec)/\(totalTimeInMunSec)"
        }
        
    }
    
    func pause(){
        audioPlayer.pause()
        timer?.invalidate()
    }
    
    func play(){
        
        audioPlayer.play()
        let useInfo = [ audioPlayer!, playerDescription]
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: useInfo, repeats: true)
    }
    
    func stop(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        timer?.invalidate()
        currentTimeInMinSec = String(format: "%02d:%02d", audioPlayer.currentTime/60, audioPlayer.currentTime%60)
        let totalTime = String(format: "%02d:%02d", audioPlayer.duration/60, audioPlayer.duration%60)
        playerDescription.text = "\(currentTimeInMinSec)/\(totalTime)"
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    


}

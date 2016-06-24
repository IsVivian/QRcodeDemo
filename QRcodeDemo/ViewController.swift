//
//  ViewController.swift
//  QRcodeDemo
//
//  Created by sherry on 16/6/24.
//  Copyright © 2016年 sherry. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    //显示二维码
    @IBOutlet weak var qrcodeImgV: UIImageView!
    
    //创建一个捕捉会话
    let session =  AVCaptureSession()
    
    //设置输入设备
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    var layer: AVCaptureVideoPreviewLayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //1.使用相机扫描二维码
    @IBAction func cameraBtnAct(sender: AnyObject) {
    
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        let input = try! AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput?
        
        if input != nil {
            let alert = UIAlertController(title: "提示", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机", preferredStyle: .Alert)
            let action = UIAlertAction(title: "确定", style: .Default, handler: nil)
            
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
            
        }
        
        if session.canAddInput(input!) {
            session.addInput(input!)
        }
        
        layer = AVCaptureVideoPreviewLayer(session: session)
        
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //可以看到的镜头区域
        layer?.frame = CGRectMake(0, 0, 320, 568)
        
        self.view.layer.insertSublayer(layer!, atIndex: 0)
        
        let output = AVCaptureMetadataOutput()
        
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        if session.canAddOutput(output) {
            session.addOutput(output)
            //设置类型为二维码
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        
    }
    
    //识别二维码后，实现代理方法，解析数据
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var stringValue: String?
        
        if metadataObjects.count > 0 {
            
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            stringValue = metadataObject.stringValue
            
            if stringValue != nil {
                self.session.stopRunning()
            }
            
        }
        
        self.session.stopRunning()
        
        let alert = UIAlertController(title: "提示", message: stringValue, preferredStyle: .Alert)
        let action = UIAlertAction(title: "确定", style: .Default, handler: nil)
        
        alert.addAction(action)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    //生成二维码
    @IBAction func makeQRcodeBtnAct(sender: AnyObject) {
        
        
        
    }
    
    //生成二维码的方法
    func createQRForString(qrString: String?, qrImageName: String?) -> UIImage? {
    
        if let sureQRString = qrString {
            
            let stringData = sureQRString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            //创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(stringData!, forKey: "inputMessage")
            qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter?.outputImage
            
            //创建一个颜色滤镜---黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")
            colorFilter?.setDefaults()
            colorFilter?.setValue(qrCIImage, forKey: "inputImage")
            colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            //返回二维码image
            let codeImage = UIImage(CIImage: colorFilter!.outputImage!.imageByApplyingTransform(CGAffineTransformMakeScale(5, 5)))
            
            //通常二维码是定制的，需要在中间放自定义的图片
            if let iconImage = UIImage(named: ) {
                <#code#>
            }

            
        }
    
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if session.running {
            
            session.stopRunning()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  TechtaGram
//
//  Created by 杉山航 on 2017/05/24.
//  Copyright © 2017年 杉山航. All rights reserved.
//

import UIKit
//写真をSNSに投稿したいときに必要なフレームワーク
import Accounts

import Social

import AVFoundation
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var cameraImageView: UIImageView!
    
    let maskImage = UIImage(named: "jk.png")
    
    //画像を加工するための元となる画像
    var oliginalimage: UIImage!
    var count: Int = 1
    var text = "🌟航🌟"
    
    //画像加工するフィルターの宣言
    var filter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        NotificationCenter.default.addObserver(self, selector: #selector(self.takePhoto), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    // View構築後の処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if count == 1 {
            
            self.takePhoto()
//            self.processButtonTapped()
        }
        if count >= 2{
            self.processButtonTapped()
        }
        count += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    @IBAction func retry(){
        self.takePhoto()
    }
    //撮影するボタンのメソッド
    func takePhoto() {
        print("\nif文の外\n")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("\nif文の中\n")
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            //画面遷移
            present(picker, animated: true, completion: nil)
            // photoImageView.imageがnilでなければselecttedPhotoに値が入る
//            guard let selectedPhoto = cameraImageView.image else {
//
//                //nilならアラートを表示してメソッドを抜ける
////                simpleAlert("画像がありません")
//                return
//            }
            // seletedPhotoに画像を合成して画面に描き出す
//            self.cameraImageView.image = self.drawMaskImage(selectedPhoto)
            
//            self.processButtonTapped()
        } else {
            //カメラを使えない時はコンソールに出ます
            print("Error")
        }
        
    }
    //編集した画像を保存するボタンのメソッド
    @IBAction func savePhoto() {
//        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
        guard let selectedPhoto = cameraImageView.image else {
            simpleAlert("画像がありません")
            return
        }
        
        let alertController = UIAlertController(title: "アップロード先を選択", message: nil, preferredStyle: .actionSheet)
//        let firstAction = UIAlertAction(title: "Facebookに投稿", style: .default) {
//            action in
//            self.postToSNS(SLServiceTypeFacebook)
//        }
//        let secondAction = UIAlertAction(title: "Twitterに投稿", style: .default) {
//            action in
//            self.postToSNS(SLServiceTypeTwitter)
//        }
        let thirdAction = UIAlertAction(title: "カメラロールに保存", style: .default) {
            action in
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, self, nil, nil)
            self.simpleAlert("アルバムに保存されました。")
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style:  .cancel, handler: nil)
        
        
//        alertController.addAction(firstAction)
//        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
    }
//    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
//        if error != nil {
//            //プライバシー設定不許可など書き込み失敗時は -3310 (ALAssetsLibraryDataUnavailableError)
////            println(error.code)
//        }
//    }
    //表示している画像にフィルタ加工するメソッド
  /*
    @IBAction func collarfilter() {
        let filterImage: CIImage = CIImage(image: oliginalimage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
        
    }
    
    */
    /*
    //カメラロールにある画像を読み込む時のメソッド
    @IBAction func openAlbam() {
        //カメラロールが使えるか確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //カメラロールの画像を選択して画像を表示するまでの一連の流れ
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    */
    //SNSに編集した画像を投稿する時のメソッド
    @IBAction func snsPhoto() {
        
        //投稿するときに一緒に載せるコメント
        let shareText = "脱ぼっち成功"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //投稿する画像とテキストを用意
        let activityItem: [Any] = [shareText,shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    // 合成ボタンを押したときに呼ばれるメソッド
    func processButtonTapped() {
        
        
        // photoImageView.imageがnilでなければselecttedPhotoに値が入る
        guard let selectedPhoto = cameraImageView.image else {

            //nilならアラートを表示してメソッドを抜ける
            print("\nhoge\n")
//            simpleAlert("画像がありません")
            return
        }
//
//        let alertController = UIAlertController(title: "合成するパーツを選択", message: nil, preferredStyle: .actionSheet)
//        let firstAction = UIAlertAction(title: "テキスト", style: .default) {
//            action in
//
//            self.inputTextField()
//            // selectedPhotoにテキストを合成して画面に描き出す
//            //self.photoImegeView.image = self.drawText(selectedPhoto)
//        }
//        let secondAction = UIAlertAction(title: "あ", style: .default){
//            action in
//
//
            // seletedPhotoに画像を合成して画面に描き出す
            self.cameraImageView.image = self.drawMaskImage(selectedPhoto)
//        }
//        let cancelAction = UIAlertAction(title: "キャンセル", style:  .cancel, handler: nil)
//
//
//        alertController.addAction(firstAction)
//        alertController.addAction(secondAction)
//        alertController.addAction(cancelAction)
//
//
//        present(alertController, animated: true, completion: nil)
    }

    
    //カメラ、カメラロールを使ったときに選択した画像をアプリ内に表示するためのメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        //加工する前の画像を元の画像として記録しておく
        oliginalimage = cameraImageView.image
        //画面遷移
        dismiss(animated: true, completion: nil)
    }
    
    // 任意のメッセージとOKボタンを持つアラートのメソッド
    func simpleAlert(_ titleeString: String) {
        
        
        let alertController = UIAlertController(title: titleeString, message: nil, preferredStyle: .alert)
        
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        
        present(alertController,animated: true, completion: nil)
        
    }
    func inputTextField(){
        
        let alert:UIAlertController = UIAlertController(title:"action",
                                                        message: "alertView",
                                                        preferredStyle:  UIAlertControllerStyle.alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertActionStyle.cancel,
                                                       handler: {
                                                        (action:UIAlertAction!) -> Void in
                                                        
                                                        
                                                        print("Cancel")
        })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action:UIAlertAction!) -> Void in
            let textFields:Array<UITextField>? = alert.textFields as Array<UITextField>?
            if textFields != nil {
                for textFields:UITextField in textFields! {
                    self.text = textFields.text!
                    self.cameraImageView.image = self.drawText(self.cameraImageView.image!)
                    //各テキストにアクセス
                    print(textFields.text)
                }
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        //textfiledの追加
        alert.addTextField(configurationHandler: {(text1:UITextField!) -> Void in
        })
        
        present(alert, animated: true, completion: nil)
    }
    func drawMaskImage(_ image: UIImage) ->UIImage {
        
        
        //グラフィックスコンテキスト生成,編集を開始
        UIGraphicsBeginImageContext(image.size)
        
        
        //読み込んだ写真を書き出す
        image.draw(in: CGRect(x: 0,y: 0, width: image.size.width, height: image.size.height))
        
        
        
        
        
        // 描き出す位置と大きさの設定　CGRectMake([左からのx座標]px, [上からのy座標]px, [横の長さ]px)
        let offset: CGFloat = 0.0
        let maskRect = CGRect(
            x: image.size.width - maskImage!.size.width - offset,
            y: image.size.height - maskImage!.size.height - offset,
            width: maskImage!.size.width,
            height: maskImage!.size.height
        )
        
//        maskImage!.size.width = image.size.width
//        maskImage!.size.width = image.size.height
        
        //maskRectで指定した範囲にmaskImage絵お書き出す
        maskImage!.draw(in: maskRect)
        
        
        //グラフィックスコンテキストの画像を取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        //グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()
        
        
        return newImage!
    }
    //元の画像にテキストを合成するメソッド
    func drawText(_ image: UIImage) -> UIImage {
        //テキストの内容の設定
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
            self.dismiss(animated: true, completion: nil)
            //　画像を出力
            cameraImageView.image = image
        }
        
        
        
        
        //グラフィックスコンテキスト生成、編集を開始
        UIGraphicsBeginImageContext(image.size)
        
        //読み込んだ写真を書き出す
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height ))
        
        //書き出す位置と大きさの設定CGRectMake([左からの座標]px,　[縦の長さ]px, [横の長さ]px)
        let textRect  = CGRect(x: 5, y: 5, width: image.size.width - 5, height: image.size.height - 5)
        
        // textFontAttributes: 文字の特性　　（フォント、カラー、スタイル）の設定
        let textFontAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 120),
            NSForegroundColorAttributeName: UIColor.red,
            NSParagraphStyleAttributeName: NSMutableParagraphStyle.default
        ]
        //textRectで指定した範囲にtextFontAttributesに従ってテキストを描き出す
        text.draw(in: textRect,withAttributes:  textFontAttributes)
        
        //グラフィックスコンテキストの画像を取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()
        
        
        return newImage!
        
    }



}


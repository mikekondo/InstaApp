//
//  CheckModel.swift
//  SampleInstaApp
//
//  Created by 近藤米功 on 2022/07/17.
//

import Foundation
import Photos

class CheckModel {

    func showCheckPermission(){
           PHPhotoLibrary.requestAuthorization { (status) in

               switch(status){

               case .authorized:
                   print("写真とアルバムの使用を許可しています")

               case .denied:
                       print("拒否")

               case .notDetermined:
                           print("notDetermined")

               case .restricted:
                           print("restricted")

               case .limited:
                   print("limited")
               @unknown default: break

               }

           }
       }

}


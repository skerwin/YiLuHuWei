//
//  DialogueUtils.swift
//  WisdomJapan
//
//  Created by zhaoyuanjing on 2017/09/15.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import UIKit

/**
 *  清除缓存
 */
func clearMyCache() -> Bool {
    
    var result = true
    let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: basePath!){
        let childrenPath = fileManager.subpaths(atPath: basePath!)
        for childPath in childrenPath!{
            let cachePath = basePath?.appending("/").appending(childPath)
            do{
                try fileManager.removeItem(atPath: cachePath!)
            }catch _{
                result = false
            }
        }
    }
    
    return result
}

class CacheTool: NSObject {
    /**
     *  计算缓存大小
     */
    static var cacheSize: String{
        get{
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let fileManager = FileManager.default
            
            func caculateCache() -> Float{
                var total: Float = 0
                if fileManager.fileExists(atPath: basePath!){
                    let childrenPath = fileManager.subpaths(atPath: basePath!)
                    if childrenPath != nil{
                        for path in childrenPath!{
                            let childPath = basePath!.appending("/").appending(path)
                            do{
                                let attr = try fileManager.attributesOfItem(atPath: childPath)
                                
                                let fileSize = attr[FileAttributeKey.init("NSFileSize")] as! Float
                                total += fileSize
                                
                            }catch _{
                                
                            }
                        }
                    }
                }
                
                return total
            }
            
            
            let totalCache = caculateCache()
            return NSString(format: "%.2f MB", totalCache / 1024.0 / 1024.0 ) as String
        }
    }
    
    static var clearResult: Bool{
        get{
            return clearMyCache()
        }
    }

}

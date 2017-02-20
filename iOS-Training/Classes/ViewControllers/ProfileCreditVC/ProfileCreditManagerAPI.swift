//
//  ProfileCreditManagerAPI.swift
//  iOS-Training
//
//  Created by An Le on 1/21/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD

// MARK: ProfileCreditManagerAPIDelegate Protocol

protocol ProfileCreditManagerAPIDelegate:NSObjectProtocol {
    func profileCreditManagerAPIDelegate(sendListCreditData listCredit:ListCredit, isLastPage:Bool) ->Void
}

class ProfileCreditManagerAPI {
    
    // MARK: - Variables
    var progress: MBProgressHUD!
    weak var profileCreditManagerAPIDelegate:ProfileCreditManagerAPIDelegate!
    
    // MARK: - Methods
    func getCreditItems(page:Int!) {
        Async.main{
            self.progress?.show(true)
        }
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = API_HOST + "/items?page=\(page)"
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let listCredit:ListCredit! = Mapper<ListCredit>().map(response.result.value!)
                    var maxPage:Int = 1
                    if listCredit.total!%listCredit.pageLimit! != 0 {
                        maxPage = listCredit.total!/listCredit.pageLimit! + 1
                    } else {
                        maxPage = listCredit.total!/listCredit.pageLimit!
                    }
                    print("max page: \(maxPage)")
                    if listCredit != nil {
                        if page == maxPage {
                            self.profileCreditManagerAPIDelegate.profileCreditManagerAPIDelegate(sendListCreditData: listCredit!, isLastPage: true)
                        } else {
                            self.profileCreditManagerAPIDelegate.profileCreditManagerAPIDelegate(sendListCreditData: listCredit!, isLastPage: false)
                        }

                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        Async.main {
            if self.progress?.alpha == 1 {
                self.progress?.hide(true)
            }
        }
    }
    
    func getCreditHistoryItems(page:Int!) {
        Async.main{
            self.progress?.show(true)
        }
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        let api_url:String = API_HOST + "/me/credit_tracking?page=\(page)"
//        print(api_url)
        Alamofire.request(.GET, api_url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if response.result.isSuccess {
                Async.background{
                    let listCredit:ListCredit! = Mapper<ListCredit>().map(response.result.value!)
//                    print(response.result.value!)
                    var maxPage:Int = 1
                    if listCredit.total!%listCredit.pageLimit! != 0 {
                        maxPage = listCredit.total!/listCredit.pageLimit! + 1
                    } else {
                        maxPage = listCredit.total!/listCredit.pageLimit!
                    }
                    if listCredit != nil {
                        if page == maxPage {
                            self.profileCreditManagerAPIDelegate.profileCreditManagerAPIDelegate(sendListCreditData: listCredit!, isLastPage: true)
                        } else {
                            self.profileCreditManagerAPIDelegate.profileCreditManagerAPIDelegate(sendListCreditData: listCredit!, isLastPage: false)
                        }
                        
                    } else {
                        print("???")
                    }
                }
            } else {
                print(response.result.error!)
            }
        }
        Async.main {
            if self.progress?.alpha == 1 {
                self.progress?.hide(true)
            }
        }
    }
    
}
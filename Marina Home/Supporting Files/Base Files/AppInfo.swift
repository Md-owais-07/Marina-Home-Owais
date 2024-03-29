//
//  AppInfo.swift
//  Marina Home
//
//  Created by Codilar on 11/04/23.
//

import Foundation
import Adjust

final class AppInfo{

   static let shared = AppInfo()
   //Mark MHIOS-1158
   let appLink = "itms-apps://itunes.apple.com/app/id6447933191"
   //Mark MHIOS-1158
   let appName = "Marina Home"
   let appVersion = "1.0"
   let apiDataBoundary = "MarinaHomeiOSAppDataBoundry"
   let forceUpdateVersion = "1"
    
    
  // let googleApiKey = "AIzaSyBXKIvxjGO_HFUqCXYKRH4Tu4mfCWpm1s8"
    
    // MARK: - Dev
    /*let adressBaseUrl = "https://marina-dev.codilar.in/rest/en/V1/"
    let ordersUrl = "https://marina-dev.codilar.in/rest/V1/"
    let baseURL = "https://marina-dev.codilar.in/en-uae/rest/V1/"
    let baseMenuURL = "https://marina-dev.codilar.in/en-uae/rest/V2/"
    let homeURL = "https://marina-dev.codilar.in/media/marinahomes/home.json"
    let countryUrl = "https://marina-dev.codilar.in/en-uae/rest/V1/header/country"
    let roomURL = "https://marina-dev.codilar.in/media/marinahomes/shopbyroom/room.json"
    let imageURL = "https://marina-dev.codilar.in/media/"
    let productImageURL = "https://marina-dev.codilar.in/media/catalog/product"
    let checkOutPaymentRequestURL = "https://api.sandbox.checkout.com/payments"
    let checkOutPaymentSuccessURL  = "https://marina-dev.codilar.in/checkoutcom/success_redirect.php"
    let checkOutPaymentFailureURL = "https://marina-dev.codilar.in/checkoutcom/failure_redirect.php"
    let adminToken = "Bearer lz45l0tjgq29qq643tvh4ghnccbsl5qm"*/
    


    // MARK: - Stage
    //applinks:preprod.marinahome.org
    let adressBaseUrl = "https://marinahome.org/en-uae/rest/V1/"
    let adminToken = "Bearer j0mdmrkp2mq35u4tzlkjjtlxbz84hphl"
    let baseURL = "https://marinahome.org/en-uae/rest/V1/"
    let baseURL2 = "https://marinahome.org/en-uae/rest/V2/"
    let baseMenuProductsURL = "https://marinahome.org/rest/V1/"
    let baseMenuURL = "https://marinahome.org/rest/V2/"
    let homeURL = "https://marinahome.org/media/marinahomes/home.json"
    let countryUrl = "https://marinahome.org/rest/V1/directory/countries/AE"
    let roomURL = "https://marinahome.org/media/marinahomes/shopbyroom/room.json"
    let imageURL = "https://mhstaging.gumlet.io/media/"
    // Mark MHIOS-1130
    let yourAppToken = "p7bdnj4hngg0"
    let adjustEnv = ADJEnvironmentSandbox
    // Mark MHIOS-1130
    let shareBaseURL = "https://marinahome.org/en-uae/"
    //MARK: START MHIOS-1064
    let smartLookKey = "da17894177fcdb286be4a664026951b660171e52"
    //MARK: END MHIOS-1064
    //MARK: START MHIOS-1304
    let pushImageURL = "https://marinahome.org/media/push_notification"
    //MARK: END MHIOS-1304
    let productImageURL = "https://marinahome.org/media/catalog/product"
    let gumletProductImageURL = "https://mhstaging.gumlet.io/media/catalog/product"
    let checkOutPaymentRequestURL = "https://api.sandbox.checkout.com/payments"
    // MARK: START MHIOS-1317
    let checkOutPaymentSuccessURL  = "https://marinahome.org/checkoutcom/success_redirect.php"
    let checkOutPaymentFailureURL = "https://marinahome.org/checkoutcom/failure_redirect.php"
    // MARK: END MHIOS-1317
    let tabbybaseUrl = "https://api.tabby.ai/api/v1/payments/"
    let recentProductsUrl = "https://eucs32v2.ksearchnet.com/cs/v2/search"
    //let searchUrl = "https://eucs32v2.ksearchnet.com/cs/v2/search"
    let searchUrl = "https://eucs32v2.ksearchnet.com/cs/v2/search"
    let searchQuesryKelbuUrl = "https://config-cdn.ksearchnet.com/recommendations/klevu-169262117580113664/settings/k-a12c5357-3718-423b-8089-2ba7132fefb8"
    let klevuKey = "klevu-169262117580113664"
    let integrationToken = "j0mdmrkp2mq35u4tzlkjjtlxbz84hphl"
    //MARK: START MHIOS-1252
    let postpayToken = "Basic aWRfZDZjMDU2NjI2YjM5NDU1MzlkMGRjY2M2MzU2YzhiODI6c2tfbGl2ZV81ZGQxNmVhZjZiMTIzZDNkYzQ1NjRjZWU4NWY2ZTk3NDFkNTFhYzQ5"
    //MARK: END MHIOS-1252
    //"Basic aWRfMWI5MDcyZTAxMDBmNGQ1MmJmYzU0ZjM2N2I1NjhjMjg6c2tfdGVzdF8zMWM4MWQwZGYyNDBlMGFjNDhmNDUxNzIwNzgwMzkxOTc3NjBjMTc0"
    let checkoutComApiToken =  "Bearer sk_sbox_7k2dvat6w75rlqzyewp6tueeza*"
    let klaviyoKey = "Xmy5h5"
    let tabbyApiKey = "pk_test_c898e5cf-bc51-4592-83b0-414f7daf30b3"
    //MARK: START MHIOS-1173
    let smartAppLink = "zjxj.adj.st"
    //MARK: END MHIOS-1173
    let postPaybaseUrl = "https://sandbox.postpay.io/checkouts"
    let postPayCaptureUrl = "https://sandbox.postpay.io/"
    let googleApiKey = "AIzaSyDE5521N1kDc95TQbqdcJqJjj_msjNk4tU"
    let guestCarriercode = "amstrates"
    let guestShipingCode = "amstrates17"

    let applePayPublicKey = "pk_sbox_j6wcor5q3nu3oua4kbjcyaifcy3"
    let applePayMerchantId = "merchant.comheckoutSabdbox.com"
    let applePayProcessingChannelId = "pc_55s2ku56mhjudhjfvzwsuyc3nq"
    let postpayCMSUrl = "https://marinahome.org/en-uae/postpay-mobile-page?price="
    let newRelicAppKey = "AA72f42570181b4df0d7b7b543cf8a244a45874dc9-NRMA"
    
    //pre prod
    
    // MARK: - Preprod
//    let adressBaseUrl = "https://preprod.marinahome.org/en-uae/rest/V1/"
//    let adminToken = "Bearer gbxzp2pa6uplkpk46e9f58oe6bk3oisp"
//    let baseURL = "https://preprod.marinahome.org/en-uae/rest/V1/"
//    let baseMenuURL = "https://preprod.marinahome.org/en-uae/rest/V2/"
//    let homeURL = "https://preprod.marinahome.org/media/marinahomes/home.json"
//    let countryUrl = "https://marinahome.org/rest/V1/directory/countries/AE"
//    let roomURL = "https://preprod.marinahome.org/media/marinahomes/shopbyroom/room.json"
//    let imageURL = "https://preprod.gumlet.io/media/"
//    let shareBaseURL = "https://preprod.marinahome.org/en-uae/"
    
//    let productImageURL = "https://preprod.gumlet.io/media/catalog/product/"
//    let checkOutPaymentRequestURL = "https://api.sandbox.checkout.com/payments"
//    let checkOutPaymentSuccessURL  = "https://preprod.marinahome.org/checkoutcom/success_redirect.php"
//    let checkOutPaymentFailureURL = "https://preprod.marinahome.org/checkoutcom/failure_redirect.php"
//    let recentProductsUrl = "https://eucs26v2.ksearchnet.com/cs/v2/search"
//    let klevuKey = "klevu-162393374404713664"
//    let integrationToken = "gbxzp2pa6uplkpk46e9f58oe6bk3oisp"
//    let klaviyoKey = "Xmy5h5"
//    let postPaybaseUrl = "https://dashboard-sandbox.postpay.io/checkouts"
//        /////USING FOR PROD ITEMS
//    let googleApiKey = "AIzaSyAufaFobxyfbgbawz_FebfGfmats9otqnk"
//    let tabbyApiKey = "sk_test_dba9e98a-33ce-4c0a-8de6-db661369f680"
//    let postpayToken = "Basic aWRfMWI5MDcyZTAxMDBmNGQ1MmJmYzU0ZjM2N2I1NjhjMjg6c2tfbGl2ZV8yOGMyODI0YTdhMjI1YjVhYjk4OGNlN2Y3YzAxZmYwZTAyNjA1Yzk3"
//    let postPayCaptureUrl = "https://api.postpay.io/"
//    let guestCarriercode = "amstrates"
//    let guestShipingCode = "amstrates1"
//    let checkoutComApiToken =  "Bearer sk_u2qa2f6tmft2vnv3ytd2pzeihqw"
//    let applePayPublicKey = "pk_xnqtfvknghjv57wngg6fobnrdam"
//    let applePayMerchantId = "merchant.marinahomes.live.newccdash"
//    let applePayProcessingChannelId = "pc_2psasyittrfuxor7bnlslwveja"
//    let tabbybaseUrl = "https://api.tabby.ai/api/v1/payments/"
//    let postpayCMSUrl = "https://preprod.marinahome.org/en-uae/postpay-mobile-page?price="
    

    // MARK: - Prod
    /*let adressBaseUrl = "https://marinahomeinteriors.com/rest/V1/"
    let adminToken = "Bearer iykcf40i2bb3t02tzs1axz179lbx62p5"
    let baseURL = "https://marinahomeinteriors.com/rest/V1/"
    let baseMenuProductsURL = "https://marinahomeinteriors.com/rest/V1/"
    let baseMenuURL = "https://marinahomeinteriors.com/rest/V2/"
     //Mark MHIOS-1130
     let yourAppToken = "qozlqrrh3f28"
     let adjustEnv = ADJEnvironmentProduction
     //Mark MHIOS-1130
     //MARK: START MHIOS-1304
     let pushImageURL = "https://marinahomeinteriors.com/media/push_notification"
     //MARK: END MHIOS-1304
    let baseURL2 = "https://www.marinahomeinteriors.com/en-uae/rest/V2/"
    let homeURL = "https://marinahomeinteriors.com/media/marinahomes/home.json"
    let countryUrl = "https://marinahomeinteriors.com/rest/V1/directory/countries/AE"
    let roomURL = "https://marinahomeinteriors.com/media/marinahomes/shopbyroom/room.json"
    let imageURL = "https://prod.gumlet.io/media/"
    let shareBaseURL = "https://www.marinahomeinteriors.com/en-uae/"
    let gumletProductImageURL = "https://prod.gumlet.io/media/catalog/product"
    let productImageURL = "https://marinahomeinteriors.com/media/catalog/product/"
    let checkOutPaymentRequestURL = "https://api.checkout.com/payments"
    let checkOutPaymentSuccessURL  = "https://marinahomeinteriors.com/checkoutcom/success_redirect.php"
    let checkOutPaymentFailureURL = "https://marinahomeinteriors.com/checkoutcom/failure_redirect.php"
    let tabbybaseUrl = "https://api.tabby.ai/api/v1/payments/"
    let recentProductsUrl = "https://eucs26v2.ksearchnet.com/cs/v2/search"
    let searchUrl = "https://eucs26v2.ksearchnet.com/cs/v2/search"
    let klevuKey = "klevu-162393374404713664"
    let integrationToken = "iykcf40i2bb3t02tzs1axz179lbx62p5"
    //MARK: START MHIOS-1064
    let smartLookKey = "a3f173e2a250258e60c16ca614d97e62f3cc38e9"
    //MARK: END MHIOS-1064
    let searchQuesryKelbuUrl = "https://config-cdn.ksearchnet.com/recommendations/klevu-162393374404713664/settings/0fd51598-970b-4bd4-a8cc-e853f4cb7883"
    let postpayToken = "Basic
     aWRfMWI5MDcyZTAxMDBmNGQ1MmJmYzU0ZjM2N2I1NjhjMjg6c2tfbGl2ZV8yOGMyODI0YTdhMjI1YjVhYjk4OGNlN2Y3YzAxZmYwZTAyNjA1Yzk3"
    let checkoutComApiToken =  "Bearer sk_u2qa2f6tmft2vnv3ytd2pzeihqw"
    let klaviyoKey = "VCQ9Zf"
     let tabbyApiKey = "pk_20151d78-5c3e-4a62-810b-85259555f2f1"
    let postPaybaseUrl = "https://api.postpay.io/checkouts"
    let googleApiKey = "AIzaSyDE5521N1kDc95TQbqdcJqJjj_msjNk4tU"
    //MARK: START MHIOS-1173
    let smartAppLink = "dnr2.adj.st"
    //MARK: END MHIOS-1173
    let postPayCaptureUrl = "https://api.postpay.io/"
    let guestCarriercode = "amstrates"
    let guestShipingCode = "amstrates1"

    let applePayPublicKey = "pk_xnqtfvknghjv57wngg6fobnrdam"
    let applePayMerchantId = "merchant.marinahomes.live.newccdash"
    let applePayProcessingChannelId = "pc_2psasyittrfuxor7bnlslwveja"
    let postpayCMSUrl = "https://www.marinahomeinteriors.com/en-uae/postpay-mobile-page?price="
     // Mark MHIOS-1176
    //  let newRelicAppKey = "AAfffa740a9a70283fd8dfaa676bbea658ac4ce9fa-NRMA" //Old
        let newRelicAppKey = "eu01xx6e1dd9bcf0181af39374664124c1b28c6a68-NRMA" // Working Since 13/12/2023
     // Mark MHIOS-1176*/
}




//
//  Coupon.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/05/16.
//

import Foundation

struct Coupon {
    var itemCode: String
    var price: String
    var discountAmount: String
    var imageUrl: String
    var expirationDate: String
}

struct CouponStub {
    var data: [Coupon] =  [
        Coupon(itemCode: "f022021-hirosaki:10000429", price: "12000", discountAmount: "100", imageUrl: "https://thumbnail.image.rakuten.co.jp/@0_mall/f022021-hirosaki/cabinet/d_202104/52280341_01_web_s.jpg?_ex=128x128", expirationDate: "5月22日 15:00"),
        Coupon(itemCode: "f062090-nagai:10000992", price: "10000", discountAmount: "120", imageUrl: "https://thumbnail.image.rakuten.co.jp/@0_mall/f062090-nagai/cabinet/seika/ringo/imgrc0076198318.jpg?_ex=128x128", expirationDate: "5月22日 15:00"),
        Coupon(itemCode: "f022055-goshogawara:10000582", price: "20000", discountAmount: "330", imageUrl: "https://thumbnail.image.rakuten.co.jp/@0_mall/f022055-goshogawara/cabinet/go001/go001-016e037-01.jpg?_ex=128x128", expirationDate: "5月22日 15:00"),
        Coupon(itemCode: "world-wand:10000059", price: "3980", discountAmount: "400", imageUrl: "https://thumbnail.image.rakuten.co.jp/@0_mall/world-wand/cabinet/shohin00/03473926/08530566/imgrc0078850413.jpg?_ex=128x128", expirationDate: "5月22日 15:00"),
        Coupon(itemCode: "world-wand:10000060", price: "4780", discountAmount: "500", imageUrl: "https://thumbnail.image.rakuten.co.jp/@0_mall/world-wand/cabinet/shohin00/03473926/06352900/20221031-r10.jpg?_ex=128x128", expirationDate: "5月22日 15:00"),
    ]
}

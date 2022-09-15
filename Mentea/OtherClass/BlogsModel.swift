 
 
 import UIKit
 
 
 struct BlogsModel: Decodable { 
    let blogId: String
    let blogText: String
    let bloggerId: String
    let bloggerImage: String
    let bloggerName: String
    let commentCount: String
    let createdDate: String
    let currentCity: String
    let likesCount: String
    let attachFileName: String
    let attachFileUrl: String
    let comment: [Comment]
    let like: [Like]
    let isLike = false
 }
 
 struct Comment: Decodable {
    let blogId: String
    let commentId: String
    let commentText: String
    let commentorId: String
    let commentorImage: String
    let commentorName: String
    let createdDate: String
    let currentCity: String
 }

 struct Like: Decodable {
    let blogId: String
    let likeId: String
    let like_status: String
    let userId: String
    let userName: String
 }
  
 struct LikesData: Decodable {
    let blogId: String
    let userId: String
    let userName: String
 }
 struct ReporteData: Decodable {
    let blogId: String
    let userId: String
    let userName: String
 }

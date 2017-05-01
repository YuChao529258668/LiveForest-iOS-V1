//
//  HSConstLayout.h
//  HotSNS
//
//  Created by 陈秋寒 on 15/3/19.
//  Copyright (c) 2015年 李长远. All rights reserved.
//

#ifndef HotSNS_HSConstLayout_h
#define HotSNS_HSConstLayout_h

/* 屏幕宽度 */
#define kScreenWidth                             [[UIScreen mainScreen] bounds].size.width
/* 屏幕高度 */
#define kScreenHeight                            [[UIScreen mainScreen] bounds].size.height

//begin
/* ScrollView高度 */
#define kScrollViewHeight                         kScreenHeight / 2.0

/* ScrollView高度 */
#define kCollectionViewHeight                     (kScreenHeight - kScrollViewHeight)

/* Cell高度 */
#define kCollectionViewCellHeight                 (kScreenHeight - kScrollViewHeight)


#pragma mark small layout begin
//small layout begin    首页cell 头像
/* 首页cell头像x */
#define kIndexCellAvatarSmallX                               17 / 2.0
/* 首页cell头像y */
#define kIndexCellAvatarSmallY                               20 / 2.0
/* 首页cell头像width */
#define kIndexCellAvatarSmallWidth                           75 / 2.0
/* 首页cell头像Height */
#define kIndexCellAvatarSmallHeight                          75 / 2.0


//begin                 首页cell 姓名标签                                                        //待调整
/* 首页cell姓名标签x */
#define kIndexCellNameLabelSmallX                            kIndexCellAvatarSmallX
/* 首页cell姓名标签y */
#define kIndexCellNameLabelSmallY                            (kIndexCellAvatarSmallY+kIndexCellAvatarSmallHeight+16/2.0)
/* 首页cell姓名标签width */
#define kIndexCellNameLabelSmallWidth                        4*kIndexCellAvatarSmallWidth
/* 首页cell姓名标签Height */
#define kIndexCellNameLabelSmallHeight                       17

//begin                 首页cell 时间标签                                                   //待调整
/* x */
#define kIndexCellTimeLabelSmallX                            kIndexCellAvatarSmallX
/* y */
#define kIndexCellTimeLabelSmallY                            (kIndexCellNameLabelSmallY+kIndexCellNameLabelSmallHeight+6/2.0)
/* width */
#define kIndexCellTimeLabelSmallWidth                        kIndexCellNameLabelSmallWidth
/* Height */
#define kIndexCellTimeLabelSmallHeight                       15 /2.0


//begin                 首页cell 活动标签                                                   //待调整
/* x */
#define kIndexCellTextLabelSmallX                            kIndexCellAvatarSmallX
/* y */
#define kIndexCellTextLabelSmallY                            (kIndexCellTimeLabelSmallY+kIndexCellTimeLabelSmallHeight+16/2.0)
/* width */
#define kIndexCellTextLabelSmallWidth                        kIndexCellNameLabelSmallWidth
/* Height */
#define kIndexCellTextLabelSmallHeight                       80/2.0


//begin                 首页cell 内容图片片
/* 首页cell内容图片x */
#define kIndexCellContentImgSmallX                               kIndexCellAvatarSmallX
/* 首页cell内容图片y */
#define kIndexCellContentImgSmallY                               (kIndexCellTextLabelSmallY+kIndexCellTextLabelSmallHeight+30/2.0)
/* 首页cell内容图片width */
#define kIndexCellContentImgSmallWidth                          (cell.frame.size.width-2*kIndexCellNameLabelSmallX)
/* 首页cell内容图片Height */
#define kIndexCellContentImgSmallHeight                          (cell.frame.size.height-kIndexCellContentImgSmallY-4)

//begin                 首页cell 点赞按钮
/* x */
#define kIndexCellpraiseBtnSmallX                               kIndexCellAvatarSmallX
/* y */
#define kIndexCellpraiseBtnSmallY                               (kIndexCellContentImgSmallY+kIndexCellContentImgSmallHeight+60/2.0)
/* width */
#define kIndexCellpraiseBtnSmallWidth                           48/2.0
/* Height */
#define kIndexCellpraiseBtnSmallHeight                          48/2.0


//begin                 首页cell 赞数标签
/* x */
#define kIndexCellpraiseLabelSmallX                               (kIndexCellpraiseBtnSmallX+30)
/* y */
#define kIndexCellpraiseLabelSmallY                               kIndexCellpraiseBtnSmallY
/* width */
#define kIndexCellpraiseLabelSmallWidth                           kIndexCellpraiseBtnSmallWidth
/* Height */
#define kIndexCellpraiseLabelSmallHeight                          kIndexCellpraiseBtnSmallHeight





#pragma mark large layout begin
//large layout begin
//                      首页cell 头像             大
/* x */
#define kIndexCellAvatarLargeX                               40 / 2.0
/* y */
#define kIndexCellAvatarLargeY                               2*40 / 2.0
/* width */
#define kIndexCellAvatarLargeWidth                           140 / 2.0
/* Height */
#define kIndexCellAvatarLargeHeight                          140 / 2.0


//begin                 首页cell 姓名标签                                                   //待调整
/* x */
#define kIndexCellNameLabelLargeX                            kIndexCellAvatarLargeX
/* y */
#define kIndexCellNameLabelLargeY                            (kIndexCellAvatarLargeY+kIndexCellAvatarLargeHeight+35/2.0)
/* width */
#define kIndexCellNameLabelLargeWidth                        300
/* Height */
#define kIndexCellNameLabelLargeHeight                       64 / 2.0


//begin                 首页cell 时间标签                                                   //待调整
/* x */
#define kIndexCellTimeLabelLargeX                            kIndexCellAvatarLargeX
/* y */
#define kIndexCellTimeLabelLargeY                            (kIndexCellNameLabelLargeY+kIndexCellNameLabelLargeHeight+10/2.0)
/* width */
#define kIndexCellTimeLabelLargeWidth                        300
/* Height */
#define kIndexCellTimeLabelLargeHeight                       40 /2.0


//begin                 首页cell 活动标签                                                   //待调整
/* x */
#define kIndexCellTextLabelLargeX                            kIndexCellAvatarLargeX
/* y */
#define kIndexCellTextLabelLargeY                            (kIndexCellTimeLabelLargeY+kIndexCellTimeLabelLargeHeight+35/2.0)
/* width */
#define kIndexCellTextLabelLargeWidth                        300
/* Height */
#define kIndexCellTextLabelLargeHeight                       50/2.0


//begin                 首页cell 内容图片                                                   //待调整
/* x */
#define kIndexCellContentImgLargeX                               40 / 2.0
/* y */
#define kIndexCellContentImgLargeY                               (kIndexCellTextLabelLargeY+kIndexCellTextLabelLargeHeight+35/2.0)
/* width */
#define kIndexCellContentImgLargeWidth                           (kScreenWidth-2*kIndexCellContentImgLargeX)
/* Height */
#define kIndexCellContentImgLargeHeight                          kScreenHeight/2.0      //TODO 修改


//begin                 首页cell 点赞按钮
/* x */
#define kIndexCellpraiseBtnLargeX                               kScreenWidth/4.0*3
/* y */
#define kIndexCellpraiseBtnLargeY                               (kScreenHeight-60/2.0)
/* width */
#define kIndexCellpraiseBtnLargeWidth                           48/2.0
/* Height */
#define kIndexCellpraiseBtnLargeHeight                          48/2.0


//begin                 首页cell 赞数标签
/* x */
#define kIndexCellpraiseLabelLargeX                               (kIndexCellpraiseBtnLargeX+30)
/* y */
#define kIndexCellpraiseLabelLargeY                               kIndexCellpraiseBtnLargeY
/* width */
#define kIndexCellpraiseLabelLargeWidth                           kIndexCellpraiseBtnLargeWidth
/* Height */
#define kIndexCellpraiseLabelLargeHeight                          kIndexCellpraiseBtnLargeHeight

//activityPage
//topImage
//acitivityName
#define kAcitivityTopActivityNameX                                  (40/2.0)             //待调整
#define kAcitivityTopActivityNameY                                  (kScreenHeight/4.0)
#define kAcitivityTopActivityNameWidth                              (372/2.0)
#define kAcitivityTopActivityNameHeight                             (150/2.0)
//acitivityLocation
#define kAcitivityTopActivityLocationX                              kAcitivityTopActivityNameX             //待调整
#define kAcitivityTopActivityLocationY                              (kAcitivityTopActivityNameY+30/2.0)
#define kAcitivityTopActivityLocationWidth                              (420/2.0)
#define kAcitivityTopActivityLocationHeight                             (50/2.0)

//smallCell define
#define kActivitySmallSmallBackgoundImgX                                      1
#define kActivitySmallBackgoundImgY                                      1
#define kActivitySmallBackgoundImgWidth                                  0
#define kActivitySmallBackgoundImgHeight                            (kCollectionViewCellHeight/2.0)

//largeCell
#define kActivityLargeBackgoundImgX                                      1
#define kActivityLargeBackgoundImgY                                      1
#define kActivityLargeBackgoundImgWidth                                  0
#define kActivityLargeBackgoundImgHeight                                 (kScreenHeight/3.0)




#pragma mark
#pragma mark yc 活动小 cell 4.1
//small layout begin    活动cell 背景
/* 活动cell背景x */
#define kActivityCellbackgroundImgSmallX                               0
/* 活动cell背景y */
#define kActivityCellbackgroundImgSmallY                               0
/* 活动cell背景width */
#define kActivityCellbackgroundImgSmallWidth                           cell.frame.size.width
/* 活动cell背景Height */
#define kActivityCellbackgroundImgSmallHeight                          270 /2.0


//begin                 活动cell 活动名称                                                        //待调整
/* 活动cell活动名称x */
#define kActivityCellavtivityNameSmallX                            40/2.0
/* 活动cell活动名称y */
#define kActivityCellavtivityNameSmallY                            34/2.0
/* 活动cell活动名称width */
#define kActivityCellavtivityNameSmallWidth                        (cell.frame.size.width-2*kActivityCellavtivityNameSmallX)
/* 活动cell活动名称Height */
#define kActivityCellavtivityNameSmallHeight                       36 /2.0


//begin                 活动cell 发布时间publishTime                                                   //待调整
/* x */
#define kActivityCellpublishTimeSmallX                            kActivityCellavtivityNameSmallX
/* y */
#define kActivityCellpublishTimeSmallY                            (kActivityCellavtivityNameSmallY+kActivityCellavtivityNameSmallHeight+10/2.0)
/* width */
#define kActivityCellpublishTimeSmallWidth                        kActivityCellavtivityNameSmallWidth
/* Height */
#define kActivityCellpublishTimeSmallHeight                       20 /2.0


//begin                 活动cell 活动描述activityDescription                                                   //待调整
/* x */
#define kActivityCellactivityDescriptionSmallX                            kActivityCellpublishTimeSmallX
/* y */
#define kActivityCellactivityDescriptionSmallY                            (kActivityCellpublishTimeSmallY+kActivityCellpublishTimeSmallHeight+16/2.0)
/* width */
#define kActivityCellactivityDescriptionSmallWidth                        kActivityCellavtivityNameSmallWidth
/* Height */
#define kActivityCellactivityDescriptionSmallHeight                       150/2.0


//begin                 活动cell 活动时间 activityTimeTag
/* 活动cell内容图片x */
#define kActivityCellactivityTimeTagSmallX                               kActivityCellactivityDescriptionSmallX
/* 活动cell内容图片y */
#define kActivityCellactivityTimeTagSmallY                               (kActivityCellactivityDescriptionSmallY+kActivityCellactivityDescriptionSmallHeight+16/2.0)
/* 活动cell内容图片width */
#define kActivityCellactivityTimeTagSmallWidth                           kActivityCellactivityDescriptionSmallWidth
/* 活动cell内容图片Height */
#define kActivityCellactivityTimeTagSmallHeight                          26

//begin                 活动cell 具体活动时间 activityTime
/* x */
#define kActivityCellactivityTimeSmallX                               kActivityCellactivityTimeTagSmallX
/* y */
#define kActivityCellactivityTimeSmallY                               (kActivityCellactivityTimeTagSmallY+kActivityCellactivityTimeTagSmallHeight+10/2.0)
/* width */
#define kActivityCellactivityTimeSmallWidth                           kActivityCellactivityTimeTagSmallWidth
/* Height */
#define kActivityCellactivityTimeSmallHeight                          22/2.0


//begin                 活动cell 活动地点activityLocationTag
/* x */
#define kActivityCellactivityLocationTagSmallX                               kActivityCellactivityLocationTagLargeX
/* y */
#define kActivityCellactivityLocationTagSmallY                               kActivityCellactivityLocationTagLargeY
/* width */
#define kActivityCellactivityLocationTagSmallWidth                           0
/* Height */
#define kActivityCellactivityLocationTagSmallHeight                          0


//begin                 活动cell 具体活动地点activityLocation
/* x */
#define kActivityCellactivityLocationSmallX                               kActivityCellactivityLocationLargeX
/* y */
#define kActivityCellactivityLocationSmallY                               kActivityCellactivityLocationLargeY
/* width */
#define kActivityCellactivityLocationSmallWidth                           0
/* Height */
#define kActivityCellactivityLocationSmallHeight                          0

//begin                 活动cell 参加人数activityJoinCount
/* x */
#define kActivityCellactivityJoinCountSmallX                               kActivityCellactivityTimeSmallX
/* y */
#define kActivityCellactivityJoinCountSmallY                               (kActivityCellactivityTimeSmallY+kActivityCellactivityTimeSmallHeight+104/2.0)
/* width */
#define kActivityCellactivityJoinCountSmallWidth                           kActivityCellactivityTimeSmallWidth
/* Height */
#define kActivityCellactivityJoinCountSmallHeight                          24/2.0

//begin                 活动cell 参加人头activityJoinAvata
/* x */
#define kActivityCellactivityJoinAvataSmallX                               kActivityCellactivityJoinCountSmallX
/* y */
#define kActivityCellactivityJoinAvataSmallY                               (kActivityCellactivityJoinCountSmallY+kActivityCellactivityJoinCountSmallHeight+10/2.0)
/* width */
#define kActivityCellactivityJoinAvataSmallWidth                           38/2.0
/* Height */
#define kActivityCellactivityJoinAvataSmallHeight                          kActivityCellactivityJoinAvataSmallWidth

//begin                 活动cell 地图mapView
/* x */
#define kActivityCellmapViewSmallX                                          kActivityCellmapViewLargeX
/* y */
#define kActivityCellmapViewSmallY                                          kActivityCellmapViewLargeY
/* width */
#define kActivityCellmapViewSmallWidth                                      0
/* Height */
#define kActivityCellmapViewSmallHeight                                     0



#pragma mark yc 活动大 cell
//Large layout begin    活动cell 背景
/* 活动cell背景x */
#define kActivityCellbackgroundImgLargeX                               0
/* 活动cell背景y */
#define kActivityCellbackgroundImgLargeY                               0
/* 活动cell背景width */
#define kActivityCellbackgroundImgLargeWidth                           cell.frame.size.width
/* 活动cell背景Height */
#define kActivityCellbackgroundImgLargeHeight                          240


//begin                 活动cell 活动名称                                                        //待调整
/* 活动cell活动名称x */
#define kActivityCellavtivityNameLargeX                            40/2.0
/* 活动cell活动名称y */
#define kActivityCellavtivityNameLargeY                            70/2.0
/* 活动cell活动名称width */
#define kActivityCellavtivityNameLargeWidth                        (cell.frame.size.width-2*kActivityCellavtivityNameLargeX)
/* 活动cell活动名称Height */
#define kActivityCellavtivityNameLargeHeight                       66/2.0


//begin                 活动cell 发布时间publishTime                                                   //待调整
/* x */
#define kActivityCellpublishTimeLargeX                            kActivityCellavtivityNameLargeX
/* y */
#define kActivityCellpublishTimeLargeY                            (kActivityCellavtivityNameLargeY+kActivityCellavtivityNameLargeHeight+10/2.0)
/* width */
#define kActivityCellpublishTimeLargeWidth                        kActivityCellavtivityNameLargeWidth
/* Height */
#define kActivityCellpublishTimeLargeHeight                       40 /2.0


//begin                 活动cell 活动描述activityDescription                                                   //待调整
/* x */
#define kActivityCellactivityDescriptionLargeX                            kActivityCellpublishTimeLargeX
/* y */
#define kActivityCellactivityDescriptionLargeY                            (kActivityCellpublishTimeLargeY+kActivityCellpublishTimeLargeHeight+80/2.0)
/* width */
#define kActivityCellactivityDescriptionLargeWidth                        kActivityCellpublishTimeLargeWidth
/* Height */
#define kActivityCellactivityDescriptionLargeHeight                       160/2.0


//begin                 活动cell 活动时间 activityTimeTag
/* 活动cell内容图片x */
#define kActivityCellactivityTimeTagLargeX                               kActivityCellactivityDescriptionLargeX
/* 活动cell内容图片y */
#define kActivityCellactivityTimeTagLargeY                               (kActivityCellbackgroundImgLargeHeight+20/2.0)
/* 活动cell内容图片width */
#define kActivityCellactivityTimeTagLargeWidth                          kActivityCellactivityDescriptionLargeWidth
/* 活动cell内容图片Height */
#define kActivityCellactivityTimeTagLargeHeight                          40/2.0

//begin                 活动cell 具体活动时间 activityTime
/* x */
#define kActivityCellactivityTimeLargeX                               kActivityCellactivityDescriptionLargeX
/* y */
#define kActivityCellactivityTimeLargeY                               (kActivityCellactivityTimeTagLargeY+kActivityCellactivityTimeTagLargeHeight+10/2.0)
/* width */
#define kActivityCellactivityTimeLargeWidth                           kActivityCellactivityTimeTagLargeWidth
/* Height */
#define kActivityCellactivityTimeLargeHeight                          40/2.0


//begin                 活动cell 活动地点activityLocationTag
/* x */
#define kActivityCellactivityLocationTagLargeX                               kActivityCellactivityTimeLargeX
/* y */
#define kActivityCellactivityLocationTagLargeY                               (kActivityCellactivityTimeLargeY+kActivityCellactivityTimeLargeHeight+20/2.0)
/* width */
#define kActivityCellactivityLocationTagLargeWidth                           kActivityCellactivityTimeLargeWidth
/* Height */
#define kActivityCellactivityLocationTagLargeHeight                          kActivityCellactivityTimeTagLargeHeight


//begin                 活动cell 具体活动地点activityLocation
/* x */
#define kActivityCellactivityLocationLargeX                               kActivityCellactivityLocationTagLargeX
/* y */
#define kActivityCellactivityLocationLargeY                               (kActivityCellactivityLocationTagLargeY+kActivityCellactivityLocationTagLargeHeight+10/2.0)
/* width */
#define kActivityCellactivityLocationLargeWidth                           kActivityCellactivityLocationTagLargeWidth
/* Height */
#define kActivityCellactivityLocationLargeHeight                          kActivityCellactivityTimeLargeHeight

//begin                 活动cell 地图mapView
/* x */
#define kActivityCellmapViewLargeX                               kActivityCellactivityLocationLargeX
/* y */
#define kActivityCellmapViewLargeY                               (kActivityCellactivityLocationLargeY+kActivityCellactivityLocationLargeHeight+20/2.0)
/* width */
#define kActivityCellmapViewLargeWidth                           kActivityCellactivityLocationTagLargeWidth
/* Height */
#define kActivityCellmapViewLargeHeight                          400/2.0



//begin                 活动cell 参加人数activityJoinCount
/* x */
#define kActivityCellactivityJoinCountLargeX                               kActivityCellmapViewLargeX
/* y */
#define kActivityCellactivityJoinCountLargeY                               (kActivityCellmapViewLargeY+kActivityCellmapViewLargeHeight+20/2.0)
/* width */
#define kActivityCellactivityJoinCountLargeWidth                           kActivityCellmapViewLargeWidth
/* Height */
#define kActivityCellactivityJoinCountLargeHeight                          40/2.0

//begin                 活动cell 参加人头activityJoinAvata
/* x */
#define kActivityCellactivityJoinAvataLargeX                               kActivityCellmapViewLargeX
/* y */
#define kActivityCellactivityJoinAvataLargeY                               (kActivityCellactivityJoinCountLargeY+kActivityCellactivityJoinCountLargeHeight+10/2.0)
/* width */
#define kActivityCellactivityJoinAvataLargeWidth                           86/2.0
/* Height */
#define kActivityCellactivityJoinAvataLargeHeight                          kActivityCellactivityJoinAvataLargeWidth


#endif

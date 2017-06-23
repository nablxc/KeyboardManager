//
//  KeyboardManagerHeader.h
//  KeyboardManager
//
//  Created by 刘星辰 on 2017/6/6.
//  Copyright © 2017年 刘星辰. All rights reserved.
//

#ifndef Header_h
#define Header_h

/*16进制颜色*/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define Delete @"删除"
#define KeyboardX_H 220.0f


#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define BLACK_COLOR [UIColor blackColor]

#define TOPCAIL_COLOR UIColorFromRGB(0x1dc4ad)

#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]

#define NOTIFICATION_DIDAPPEAR @"viewDidAppear"
#define NOTIFICATION_WILLDISAPPEAR @"viewWillDisappear"
#define NOTIFICATION_BIND @"BindSuccess"
#define NOTIFICATION_KEY_VC @"vc"

#endif /* Header_h */

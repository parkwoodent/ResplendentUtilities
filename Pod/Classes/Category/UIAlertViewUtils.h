//
//  UIAlertViewUtils.h
//  Pods
//
//  Created by Benjamin Maer on 9/7/18.
//

#ifndef UIAlertViewUtils_h
#define UIAlertViewUtils_h

#import <UIKit/UIKit.h>





#define RU_ALERT(title,msg,del,cancel,other,...) [[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:cancel otherButtonTitles:other, ##__VA_ARGS__]
#define RU_ALERT_SHOW(title,msg,del,cancel,other,...) [RU_ALERT((title),(msg),(del),(cancel),(other),##__VA_ARGS__) show]





#endif /* UIAlertViewUtils_h */

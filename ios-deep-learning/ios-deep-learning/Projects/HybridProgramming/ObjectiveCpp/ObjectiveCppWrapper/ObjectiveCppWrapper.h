//
//  ObjectiveCppWrapper.h
//  ios-deep-learning
//
//  Created by Bin Yu on 23/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

class ObjectiveCppWrapper {
    
public:
    ObjectiveCppWrapper();
    ~ObjectiveCppWrapper();
    
    void showAlert(NSString *title, NSString *message, UIViewController *parentViewController);
    
private:
    UIAlertController *getAlertController();
    UIAlertController *alertController;
    
};

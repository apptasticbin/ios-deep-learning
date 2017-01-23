//
//  ObjectiveCppWrapper.m
//  ios-deep-learning
//
//  Created by Bin Yu on 23/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "ObjectiveCppWrapper.h"
#include <iostream>

ObjectiveCppWrapper::ObjectiveCppWrapper(){
    std::cout << "Object " << typeid(this).name() << "(" << this << ")" << " has been created." << std::endl;
}

ObjectiveCppWrapper::~ObjectiveCppWrapper() {
    std::cout << "Object " << typeid(this).name() << "(" << this << ")" << " has been destructed." << std::endl;
}

void ObjectiveCppWrapper::showAlert(NSString *title, NSString *message, UIViewController *parentViewController) {
    if (!parentViewController) {
        std::cout << "Parent view controller can not be NULL." << std::endl;
        return;
    }
    UIAlertController *alertController = getAlertController();
    alertController.title = title;
    alertController.message = message;
    
    [parentViewController presentViewController:alertController animated:YES completion:^{
        
    }];
}

// private

UIAlertController *ObjectiveCppWrapper::getAlertController() {
    if (!alertController) {
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:closeAction];
    }
    return alertController;
}

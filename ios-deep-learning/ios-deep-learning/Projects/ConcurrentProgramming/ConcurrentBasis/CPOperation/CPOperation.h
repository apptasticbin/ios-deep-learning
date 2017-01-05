//
//  CPOperation.h
//  ios-deep-learning
//
//  Created by Bin Yu on 03/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OperationTickBlock)();

@interface CPOperation : NSOperation

@property (nonatomic, strong) OperationTickBlock tickBlock;

@end

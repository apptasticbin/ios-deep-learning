//
//  CATiledImageView.m
//  ios-deep-learning
//
//  Created by Bin Yu on 17/01/2017.
//  Copyright © 2017 Bin Yu. All rights reserved.
//

#import "CATiledImageView.h"

static NSString * const TiledImageName = @"stains_gate_large";
static CGSize TiledImageSize = {300, 300};

@interface CATiledImageView ()

@property (nonatomic, strong) CATiledLayer *tiledLayer;
@property (nonatomic, strong) NSString *cacheDirectoryPath;

@end

@implementation CATiledImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    self.tiledLayer.contentsScale = [UIScreen mainScreen].scale;
    self.tiledLayer.tileSize = TiledImageSize;
}

- (void)cutAndSaveImages {
    [self cutAndSaveImageNamed:TiledImageName intoPiecesWithSize:TiledImageSize];
}

- (void)cutAndSaveImageNamed:(NSString *)imageName intoPiecesWithSize:(CGSize)size {
    // first check if cached image is existing or not
    NSString *filePath = [NSString stringWithFormat:@"%@/%@_0_0.png", self.cacheDirectoryPath, imageName];
    NSLog(@"Cache path: %@", filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL cacheExist = [fileManager fileExistsAtPath:filePath];
    if (cacheExist) {
        NSLog(@"Cache exists already");
        return;
    }
    
    // no cached image, we can not cut the image into pieces
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *image = [UIImage imageNamed:TiledImageName];
    CGImageRef imageRef = image.CGImage;
    // calculate row and column. ceiling the result 3.9 -> 4, not 3
    NSInteger rows = ceil(image.size.height / size.height) * scale;
    NSInteger columns = ceil(image.size.width / size.width) * scale;
    
    // because image width(height) can not be fully divided by tile size. So we need to handle edge cases.
    CGFloat partialRowHeight = image.size.height - trunc(image.size.height / size.height) * size.height;
    CGFloat partialColumnWidth = image.size.width - trunc(image.size.width / size.width) * size.width;

    // in order to not block main thread, do all these work in global concurrent queues
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger r=0; r<rows; r++) {
            for (NSInteger c=0; c<columns; c++) {
                CGSize tileSize = size;
                if (partialRowHeight > 0 && r == rows-1) {
                    tileSize.height = partialRowHeight;
                }
                
                if (partialColumnWidth > 0 && c == columns-1) {
                    tileSize.width = partialColumnWidth;
                }
                
                CGRect tileImageRect = CGRectMake(c*size.width, r*size.height, tileSize.width, tileSize.height);
                CGImageRef tileImageRef = CGImageCreateWithImageInRect(imageRef, tileImageRect);
                UIImage *tileImage = [UIImage imageWithCGImage:tileImageRef];
                NSData *tileImageData = UIImagePNGRepresentation(tileImage);
                
                NSString *tileImagePath = [NSString stringWithFormat:@"%@/%@_%@_%@", self.cacheDirectoryPath, imageName, @(r), @(c)];
                NSError *error;
                [tileImageData writeToFile:tileImagePath options:0 error:&error];
            }
        }
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (CATiledLayer *)tiledLayer {
    return (CATiledLayer *)self.layer;
}

- (void)drawRect:(CGRect)rect {
    NSInteger firstRow = CGRectGetMinY(rect) / TiledImageSize.height;
    NSInteger lastRow = CGRectGetMaxY(rect) / TiledImageSize.height;
    NSInteger firstColumn = CGRectGetMinX(rect) / TiledImageSize.width;
    NSInteger lastColumn = CGRectGetMaxX(rect) / TiledImageSize.width;
    
    for (NSInteger row=firstRow; row<=lastRow; row++) {
        for (NSInteger column=firstColumn; column<=lastColumn; column++) {
            UIImage *tiledImage = [self imageForTileAtRow:row column:column];
            CGFloat x = column * TiledImageSize.width;
            CGFloat y = row * TiledImageSize.height;
            CGRect tileRect = CGRectMake(x, y, TiledImageSize.width, TiledImageSize.height);
            
//            tileRect = CGRectIntersection(self.bounds, tileRect);
            [tiledImage drawInRect:tileRect];
        }
    }
}

- (UIImage *)imageForTileAtRow:(NSInteger)row column:(NSInteger)column {
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@_%@_%@", self.cacheDirectoryPath, TiledImageName, @(row), @(column)];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end

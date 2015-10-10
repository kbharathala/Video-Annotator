//
//  Annotation.h
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/10/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Annotation : NSObject

@property (nonatomic) int start;
@property (nonatomic) int end;
@property (nonatomic, strong) NSString *comment;

- (id)initWithStart: (int) start
                end: (int) end
            comment: (NSString *) comment;

@end

//
//  Annotation.m
//  Video-Annotator
//
//  Created by Krishna Bharathala on 10/10/15.
//  Copyright (c) 2015 Krishna Bharathala. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (id)initWithStart: (int) start
                end: (int) end
            comment: (NSString *) comment {
    
    self = [super init];
    if(self) {
        self.start = start;
        self.end = end;
        self.comment = comment;
    }
    return self;
}



@end

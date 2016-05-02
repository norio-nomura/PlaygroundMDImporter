//
//  Importer.m
//  PlaygroundMDImporter
//
//  Created by 野村 憲男 on 5/2/16.
//
//  Copyright (c) 2016 Norio Nomura
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

@import Foundation;
#import "Importer.h"

BOOL isSwiftSourceURL(NSURL* url) {
    NSDictionary *dictionary = [url resourceValuesForKeys:@[NSURLTypeIdentifierKey] error:nil];
    NSString *typeIdentifier = [dictionary objectForKey:NSURLTypeIdentifierKey];
    return [typeIdentifier isEqualToString:@"public.swift-source"];
}

@implementation Importer

+(BOOL)import:(NSURL*)url toDictionary:(NSMutableDictionary*)dictionary {
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDirectory = false;
    if (!([fm fileExistsAtPath:[url path] isDirectory:&isDirectory] && isDirectory)) {
        return NO;
    }

    NSMutableArray<NSString*> *codes = [NSMutableArray<NSString*> new];
    NSEnumerator *enumerator = [fm enumeratorAtURL:url
                        includingPropertiesForKeys:@[NSURLTypeIdentifierKey]
                                           options:0
                                      errorHandler:nil];
    for (NSURL *file in enumerator) {
        if (isSwiftSourceURL(file)) {
            NSString *code = [NSString stringWithContentsOfURL:file usedEncoding:nil error:nil];
            if (code) {
                [codes addObject:code];
            }
        }
    }

    dictionary[(NSString*)kMDItemTextContent] = [codes componentsJoinedByString:@"\n"];
    return YES;
}

@end

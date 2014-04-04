//
//  RevealIDEModel.m
//  RevealPlugin
//
//  Created by shjborage on 4/4/14.
//  Copyright (c) 2014 Saick. All rights reserved.
//

#import "RevealIDEModel.h"
#import <objc/message.h>

@implementation RevealIDEModel

+ (IDEWorkspaceTabController *)workspaceControllerIn
{
  NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
  if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
    IDEWorkspaceWindowController *workspaceController = (IDEWorkspaceWindowController *)currentWindowController;
    
    return workspaceController.activeWorkspaceTabController;
  }
  return nil;
}

+ (DBGDebugSession *)debugSessionIn
{
  IDEWorkspaceTabController *tabController = [self workspaceControllerIn];
  
  if (![tabController respondsToSelector:@selector(debugSessionController)]) {
    return nil;
  } else {
    DBGDebugSessionController *debugSessionController = objc_msgSend(tabController, @selector(debugSessionController));
    if ([debugSessionController respondsToSelector:@selector(debugSession)]) {
      id debugSession = objc_msgSend(debugSessionController, @selector(debugSession));
      if ([NSStringFromClass([debugSession class]) isEqualToString:@"DBGLLDBSession"]) {
        return debugSession;
      } else {
        return nil;
      }
    } else {
      return nil;
    }
  }
}

@end

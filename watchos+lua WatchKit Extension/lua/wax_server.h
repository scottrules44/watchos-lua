#ifndef WAX_TARGET_OS_WATCH

#import <Foundation/Foundation.h>

@class wax_server;


typedef enum {
    kTCPServerCouldNotBindToIPv4Address = 1,
    kTCPServerCouldNotBindToIPv6Address = 2,
    kTCPServerNoSocketsAvailable = 3,
} TCPServerErrorCode;


@protocol WaxServerDelegate

@optional
- (void)connected;
- (void)disconnected;
- (void)dataReceived:(NSData *)data;

@end


@interface wax_server : NSObject <NSStreamDelegate> {
	CFSocketRef _ipv4socket;
	id<WaxServerDelegate> _delegate;

	NSInputStream *_inStream;
	NSOutputStream *_outStream;
}
	
@property(nonatomic, assign) id<WaxServerDelegate> delegate;

- (NSError *)startOnPort:(NSUInteger)port;
- (BOOL)stop;
- (BOOL)enableBonjourOnPort:(NSUInteger)port;
- (void)disableBonjour;

- (BOOL)send:(NSString *)output;
- (void)receive:(NSData *)output;

@end

// This is needed because the runtime doesn't automatically load protocols
@interface HACK_WAX_DELEGATE_IMPLEMENTOR : NSObject  <WaxServerDelegate> {}
@end
#endif

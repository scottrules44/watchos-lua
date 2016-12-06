#import "InterfaceController.h"

#import "wax.h"
#import "lua.h"
@interface InterfaceController()

@property (strong, nonatomic) IBOutlet WKInterfaceSKScene *skInterface;

@end
@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)panTouch:(id)sender {
}
- (IBAction)tapTouch:(id)sender {
}
- (IBAction)longTouch:(id)sender {
}
@end

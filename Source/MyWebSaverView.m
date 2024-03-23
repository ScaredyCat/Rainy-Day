

#import "MyWebSaverView.h"
#import <WebKit/WebKit.h>


@implementation MyWebSaverView

bool Snapped = FALSE;

+ (BOOL)performGammaFade
{
    if (!Snapped) {
        runCommand(@"/usr/sbin/screencapture -T0 -x -S -m /tmp/background.png");
        Snapped = TRUE;
        
        //NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 0.2 ];
        //[NSThread sleepUntilDate:future];
    }
    return YES;
}

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    
   // if ((self = [super initWithFrame:frame isPreview:isPreview])) {
     ////   _webView = [[WebView alloc] initWithFrame:frame];
     //   [_webView setFrameLoadDelegate:self];
        
    self = [super initWithFrame:frame isPreview:isPreview];
    
    
    if (isPreview) {
        if (!Snapped) {
            runCommand(@"/usr/sbin/screencapture -T0 -x -S -m /tmp/background.png");
            Snapped = TRUE;

        }
        
    }
    
    if (self) {
        _webView = [[WebView alloc] initWithFrame:[self bounds] frameName:nil groupName:nil];
        [_webView setFrameLoadDelegate:self];
        //[self addSubview:_webView];
        //[[_webView mainFrame] loadRequest:[self request]];

        
    }
    
    return self;
}

- (void)dealloc
{
    [_webView release];
    [super dealloc];
}

- (NSURLRequest *)request
{

    NSURL *fileUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"embedded" withExtension:@"html"];
    
    //NSURL *url = [NSURL URLWithString:@"file:///Users/andypowell/Documents/myscreensavers/embedded.html"];
    
    
    return [NSURLRequest requestWithURL:fileUrl];
}

NSString * runCommand(NSString* c) {
    
    NSString* outP; FILE *read_fp;  char buffer[BUFSIZ + 1];
    int chars_read; memset(buffer, '\0', sizeof(buffer));
    read_fp = popen(c.UTF8String, "r");
    //if (read_fp != NULL) {
     //   chars_read = fread(buffer, sizeof(char), BUFSIZ, read_fp);
     //   if (chars_read > 0) outP = $UTF8(buffer);
        pclose(read_fp);
   // }
    return outP;
}


#pragma mark Screen Saver

- (void)startAnimation
{
    [_webView setAlphaValue:0.0];
    [self addSubview:_webView];
    [[_webView mainFrame] loadRequest:[self request]];
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
    [_webView removeFromSuperview];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow *)configureSheet
{
    return nil;
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

#pragma mark WebFrame Load Delegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [_webView setAlphaValue:1.0];
}

@end

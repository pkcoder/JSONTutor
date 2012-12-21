

#ifndef AH_RETAIN
#if __has_feature(objc_arc)
#define AH_RETAIN(x) x
#define AH_RELEASE(x)
#define AH_AUTORELEASE(x) x
#define AH_SUPER_DEALLOC
#else
#define __AH_WEAK
#define AH_WEAK assign
#define AH_RETAIN(x) [x retain]
#define AH_RELEASE(x) [x release]
#define AH_AUTORELEASE(x) [x autorelease]
#define AH_SUPER_DEALLOC [super dealloc]
#endif
#endif



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


extern NSString *const ImageLoadDidFinish;
extern NSString *const ImageLoadDidFail;

extern NSString *const ImageImageKey;
extern NSString *const ImageURLKey;
extern NSString *const ImageCacheKey;
extern NSString *const ImageErrorKey;


@interface ImageCache : NSObject

+ (ImageCache *)sharedCache;

@property (nonatomic, assign) BOOL useImageNamed;
@property (nonatomic, assign) NSUInteger countLimit;

- (UIImage *)imageForURL:(NSURL *)URL;
- (void)setImage:(UIImage *)image forURL:(NSURL *)URL;
- (void)removeImageForURL:(NSURL *)URL;
- (void)clearCache;

@end


@interface ImageLoader : NSObject

+ (ImageLoader *)sharedLoader;

@property (nonatomic, strong) ImageCache *cache;
@property (nonatomic, assign) NSUInteger concurrentLoads;
@property (nonatomic, assign) NSTimeInterval loadingTimeout;
@property (nonatomic, assign) BOOL decompressImages;

- (void)loadImageWithURL:(NSURL *)URL target:(id)target success:(SEL)success failure:(SEL)failure;
- (void)loadImageWithURL:(NSURL *)URL target:(id)target action:(SEL)action;
- (void)loadImageWithURL:(NSURL *)URL;
- (void)cancelLoadingURL:(NSURL *)URL target:(id)target action:(SEL)action;
- (void)cancelLoadingURL:(NSURL *)URL target:(id)target;
- (void)cancelLoadingURL:(NSURL *)URL;
- (NSURL *)URLForTarget:(id)target action:(SEL)action;

@end


@interface UIImageView(ImageDownloader)

@property (nonatomic, strong) NSURL *imageURL;

@end


@interface ImageDownloader : UIImageView

@property (nonatomic, assign) BOOL showActivityIndicator;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorStyle;
@property (nonatomic, assign) BOOL crossfadeImages;
@property (nonatomic, assign) NSTimeInterval crossfadeDuration;

@end

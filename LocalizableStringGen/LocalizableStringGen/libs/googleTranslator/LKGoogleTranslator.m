//
//  LKGoogleTranslator.m
//  GoogleTranslator
//

#import "LKGoogleTranslator.h"
#import "JSON.h"

#define URL_STRING @"http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair="
#define TEXT_VAR @"&q="

@implementation LKGoogleTranslator

- (NSString*)translateText:(NSString*)sourceText fromLanguage:(NSString*)sourceLanguage toLanguage:(NSString*)targetLanguage {
	NSMutableString* urlString = [NSMutableString string];
	[urlString appendString: URL_STRING];
	[urlString appendString: sourceLanguage];
	[urlString appendString: @"%7C"];
	[urlString appendString: targetLanguage];
	[urlString appendString: TEXT_VAR];
	[urlString appendString: [sourceText stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
	NSURL* url = [NSURL URLWithString: urlString];
	NSURLRequest* request = [NSURLRequest requestWithURL: url cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval: 60.0];
	NSURLResponse* response; NSError* error;
	NSData* data = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
	if (data == nil) {
		NSLog(@"Could not connect to the server: %@ %@", urlString, [error description]);
		return nil;
	} else {
		NSString* contents = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
		NSLog(@"# %@ %@ %@", sourceLanguage, targetLanguage, contents);
		return [self translateCharacters: [[[contents JSONValue] objectForKey: @"responseData"] objectForKey: @"translatedText"]];
	}
}

- (NSString*)translateCharacters:(NSString*)text {
	NSMutableString* translatedText = [NSMutableString string];
	NSRange range = [text rangeOfString: @"&#"];
	int processedSoFar = 0;
	while (range.location != NSNotFound) {
		int pos = range.location;
		[translatedText appendString: [text substringWithRange: NSMakeRange(processedSoFar, pos - processedSoFar)]];
		range = [text rangeOfString: @";" options: 0 range: NSMakeRange(pos + 2, [text length] - pos - 2)];
		int code = [[text substringWithRange: NSMakeRange(pos + 2, range.location - pos - 2)] intValue];
		[translatedText appendFormat: @"%C", (unichar) code];
		processedSoFar = range.location + 1;
		range = [text rangeOfString: @"&#" options: 0 range: NSMakeRange(processedSoFar, [text length] - processedSoFar)];
	}
	[translatedText appendString: [text substringFromIndex: processedSoFar]];
	return translatedText;
}

@end

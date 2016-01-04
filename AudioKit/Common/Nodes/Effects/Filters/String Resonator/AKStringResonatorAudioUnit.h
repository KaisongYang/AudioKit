//
//  AKStringResonatorAudioUnit.h
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2016 Aurelius Prochazka. All rights reserved.
//

#ifndef AKStringResonatorAudioUnit_h
#define AKStringResonatorAudioUnit_h

#import <AudioToolbox/AudioToolbox.h>

@interface AKStringResonatorAudioUnit : AUAudioUnit
- (void)start;
- (void)stop;
- (BOOL)isPlaying;
@end

#endif /* AKStringResonatorAudioUnit_h */
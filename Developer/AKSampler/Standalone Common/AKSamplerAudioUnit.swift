//
//  AKSamplerAudioUnit2.swift
//  ExtendingAudioKit
//
//  Created by Shane Dunne on 2018-02-19.
//  Copyright © 2018 Shane Dunne & Associates. All rights reserved.
//

import AVFoundation
import AudioKit

public class AKSampler2AudioUnit: AKGeneratorAudioUnitBase {
    
    var pDSP: UnsafeMutableRawPointer?
    
    func setParameter(_ address: AKSamplerParameter, value: Double) {
        setParameterWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }
    
    func setParameterImmediately(_ address: AKSamplerParameter, value: Double) {
        setParameterImmediatelyWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }
    
    var pitchBend: Double = 0.0 {
        didSet { setParameter(.pitchBendParam, value: pitchBend) }
    }
    
    var vibratoDepth: Double = 1.0 {
        didSet { setParameter(.vibratoDepthParam, value: vibratoDepth) }
    }
    
    var rampTime: Double = 0.0 {
        didSet { setParameter(.rampTimeParam, value: rampTime) }
    }
    
    var ampAttackTime: Double = 0.0 {
        didSet { setParameter(.ampAttackTimeParam, value: ampAttackTime) }
    }
    
    var ampDecayTime: Double = 0.0 {
        didSet { setParameter(.ampDecayTimeParam, value: ampDecayTime) }
    }
    
    var ampSustainLevel: Double = 0.0 {
        didSet { setParameter(.ampSustainLevelParam, value: ampSustainLevel) }
    }
    
    var ampReleaseTime: Double = 0.0 {
        didSet { setParameter(.ampReleaseTimeParam, value: ampReleaseTime) }
    }

    var filterAttackTime: Double = 0.0 {
        didSet { setParameter(.filterAttackTimeParam, value: filterAttackTime) }
    }
    
    var filterDecayTime: Double = 0.0 {
        didSet { setParameter(.filterDecayTimeParam, value: filterDecayTime) }
    }
    
    var filterSustainLevel: Double = 0.0 {
        didSet { setParameter(.filterSustainLevelParam, value: filterSustainLevel) }
    }
    
    var filterReleaseTime: Double = 0.0 {
        didSet { setParameter(.filterReleaseTimeParam, value: filterReleaseTime) }
    }
    
    var filterEnable: Double = 0.0 {
        didSet { setParameter(.filterEnableParam, value: filterEnable) }
    }
    
    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> UnsafeMutableRawPointer! {
        pDSP = createAKSamplerDSP(Int32(count), sampleRate)
        return pDSP
    }
    
    override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)
        
        let rampFlags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable, .flag_CanRamp]
        let nonRampFlags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable]
        
        var paramAddress = 0
        let pitchBendParam = AUParameterTree.createParameter(withIdentifier: "pitchBend",
                                                       name: "Pitch Offset (semitones)",
                                                       address: AUParameterAddress(paramAddress),
                                                       min: -1000.0, max: 1000.0,
                                                       unit: .relativeSemiTones, unitName: nil,
                                                       flags: rampFlags,
                                                       valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let vibratoDepthParam = AUParameterTree.createParameter(withIdentifier: "vibratoDepth",
                                                        name: "Vibrato amount (semitones)",
                                                        address: AUParameterAddress(paramAddress),
                                                        min: 0.0, max: 1000.0,
                                                        unit: .relativeSemiTones, unitName: nil,
                                                        flags: rampFlags,
                                                        valueStrings: nil, dependentParameters: nil)

        paramAddress += 1
        let ampAttackTimeParam = AUParameterTree.createParameter(withIdentifier: "ampAttackTime",
                                                                name: "Amp Attack time (seconds)",
                                                                address: AUParameterAddress(paramAddress),
                                                                min: 0.0, max: 1000.0,
                                                                unit: .seconds, unitName: nil,
                                                                flags: nonRampFlags,
                                                                valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let ampDecayTimeParam = AUParameterTree.createParameter(withIdentifier: "ampDecayTime",
                                                              name: "Amp Decay time (seconds)",
                                                              address: AUParameterAddress(paramAddress),
                                                              min: 0.0, max: 1000.0,
                                                              unit: .seconds, unitName: nil,
                                                              flags: nonRampFlags,
                                                              valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let ampSustainLevelParam = AUParameterTree.createParameter(withIdentifier: "ampSustainLevel",
                                                             name: "Amp Sustain level (fraction)",
                                                             address: AUParameterAddress(paramAddress),
                                                             min: 0.0, max: 1.0,
                                                             unit: .generic, unitName: nil,
                                                             flags: nonRampFlags,
                                                             valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let ampReleaseTimeParam = AUParameterTree.createParameter(withIdentifier: "ampReleaseTime",
                                                              name: "Amp Release time (seconds)",
                                                              address: AUParameterAddress(paramAddress),
                                                              min: 0.0, max: 1000.0,
                                                              unit: .seconds, unitName: nil,
                                                              flags: nonRampFlags,
                                                              valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let filterAttackTimeParam = AUParameterTree.createParameter(withIdentifier: "filterAttackTime",
                                                                 name: "Filter Attack time (seconds)",
                                                                 address: AUParameterAddress(paramAddress),
                                                                 min: 0.0, max: 1000.0,
                                                                 unit: .seconds, unitName: nil,
                                                                 flags: nonRampFlags,
                                                                 valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let filterDecayTimeParam = AUParameterTree.createParameter(withIdentifier: "filterDecayTime",
                                                                name: "Filter Decay time (seconds)",
                                                                address: AUParameterAddress(paramAddress),
                                                                min: 0.0, max: 1000.0,
                                                                unit: .seconds, unitName: nil,
                                                                flags: nonRampFlags,
                                                                valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let filterSustainLevelParam = AUParameterTree.createParameter(withIdentifier: "filterSustainLevel",
                                                                   name: "Filter Sustain level (fraction)",
                                                                   address: AUParameterAddress(paramAddress),
                                                                   min: 0.0, max: 1.0,
                                                                   unit: .generic, unitName: nil,
                                                                   flags: nonRampFlags,
                                                                   valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let filterReleaseTimeParam = AUParameterTree.createParameter(withIdentifier: "filterReleaseTime",
                                                                  name: "Filter Release time (seconds)",
                                                                  address: AUParameterAddress(paramAddress),
                                                                  min: 0.0, max: 1000.0,
                                                                  unit: .seconds, unitName: nil,
                                                                  flags: nonRampFlags,
                                                                  valueStrings: nil, dependentParameters: nil)
        paramAddress += 1
        let filterEnableParam = AUParameterTree.createParameter(withIdentifier: "filterEnable",
                                                                     name: "Filter Enable",
                                                                     address: AUParameterAddress(paramAddress),
                                                                     min: 0.0, max: 1.0,
                                                                     unit: .boolean, unitName: nil,
                                                                     flags: nonRampFlags,
                                                                     valueStrings: nil, dependentParameters: nil)

        setParameterTree(AUParameterTree.createTree(withChildren: [pitchBendParam, vibratoDepthParam,
                                                                   ampAttackTimeParam, ampDecayTimeParam,
                                                                   ampSustainLevelParam, ampReleaseTimeParam,
                                                                   filterAttackTimeParam, filterDecayTimeParam,
                                                                   filterSustainLevelParam, filterReleaseTimeParam,
                                                                   filterEnableParam ]))
        pitchBendParam.value = 0.0
        vibratoDepthParam.value = 0.0
        ampAttackTimeParam.value = 0.0
        ampDecayTimeParam.value = 0.0
        ampSustainLevelParam.value = 1.0
        ampReleaseTimeParam.value = 0.0
        filterAttackTimeParam.value = 0.0
        filterDecayTimeParam.value = 0.0
        filterSustainLevelParam.value = 1.0
        filterReleaseTimeParam.value = 0.0
        filterEnableParam.value = 0.0
    }
    
    public override var canProcessInPlace: Bool { return true; }
    
    public func loadSampleData(_ noteNumber: MIDINoteNumber, _ noteHz: Float, _  bInterleaved: Bool,
                               _ channelCount: UInt32, _ sampleCount: UInt32, _ data: UnsafeMutablePointer<Float>,
                               _ min_note: Int32 = -1, _ max_note: Int32 = -1, _ min_vel: Int32 = -1, _ max_vel: Int32 = -1,
                               _ bLoop: Bool = true, _ fLoopStart: Float = 0, _ fLoopEnd: Float = 0,
                               _ fStart: Float = 0, _ fEnd: Float = 0) {
        doAKSamplerLoadData(pDSP, noteNumber, noteHz, bInterleaved,
                            channelCount, sampleCount, data,
                            min_note, max_note, min_vel, max_vel,
                            bLoop, fLoopStart, fLoopEnd, fStart, fEnd)
    }
    
    public func buildSimpleKeyMap() {
        doAKSamplerBuildSimpleKeyMap(pDSP)
    }
    
    public func buildKeyMap() {
        doAKSamplerBuildKeyMap(pDSP)
    }
    
    public func playNote(_ noteNumber: UInt8, _ velocity: UInt8, _ noteHz: Float) {
        //print("playNote \(noteNumber)")
        doAKSamplerPlayNote(pDSP, noteNumber, velocity, noteHz)
    }
    
    public func stopNote(_ noteNumber: UInt8, _ immediate: Bool) {
        //print("stopNote \(noteNumber)")
        doAKSamplerStopNote(pDSP, noteNumber, immediate)
    }

}
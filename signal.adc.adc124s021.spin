{
----------------------------------------------------------------------------------------------------
    Filename:       signal.adc.adc124s021.spin
    Description:    Driver for TI ADC124S021 Analog to Digital Converters 
    Author:         Jesse Burt
    Started:        Apr 3, 2024
    Updated:        Apr 5, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------
}

CON

    { default I/O settings; these can be overridden in the parent object }
    CS          = 0
    SCK         = 1
    MOSI        = 2
    MISO        = 3

    ADC_BITS    = 12
    ADC_CHANNELS= 4


#include "signal.adc.common.spinh"              ' pull in code common to all ADC drivers

VAR

    long _adc_ref
    long _adc_range, _adc_max
    long _adc_model
    word _adc_mask
    byte _max_channels, _ch


OBJ

    time:   "time"                              ' Basic timing functions
    u64:    "math.unsigned64"


PUB null()
' This is not a top-level object


PUB start(): s
' Start the driver using default I/O settings
    return startx(CS, SCK, MOSI, MISO)


PUB startx(CS_PIN, SCK_PIN, MOSI_PIN, MISO_PIN): status
' Start the driver, using custom I/O settings
'   CS_PIN:     Chip Select
'   SCK_PIN:    Serial Clock
'   MOSI_PIN:   Master-Out Slave-In (ignored on single-channel ADC models)
'   MISO_PIN:   Master-In Slave-Out
'   Returns: cog ID+1 of parent cog, or 0 on failure
    if (    lookdown(CS_PIN: 0..31) and lookdown(SCK_PIN: 0..31) and ...
            lookdown(MOSI_PIN: 0..31) and lookdown(MISO_PIN: 0..31) )
            outa[CS] := 1                       ' make sure CS starts high
            dira[CS] := 1
            outa[SCK] := 1                      ' clock idles high (SPI mode 3)
            dira[SCK] := 1
            outa[MOSI] := 0
            dira[MOSI] := 1
            dira[MISO] := 0

            _adc_range := (1 << ADC_BITS)
            _adc_max := _adc_range-1
            return (cogid+1)
    ' if this point is reached, something above failed
    ' Re-check I/O pin assignments, bus speed, connections, power
    ' Lastly - make sure you have at least one free core/cog
    return FALSE


PUB stop()
' Stop the driver
    longfill(@_adc_ref, 0, 4)
    _adc_mask := _max_channels := _ch := 0


PUB defaults()
' Set factory defaults
    set_adc_channel(0)
    set_ref_voltage(3_300000)


pub preset_prop_activityboard()
' Preset settings: Propeller Activity Board (WX #32912 or non-WX #32910)
    set_ref_voltage(5_000000)


PUB adc_channel(): ch
' Get currently set ADC channel (cached)
    return _ch


PUB adc_data(): wd | b, ch, sp
' ADC data word
'   Returns: ADC word (12bits)
    ch := (_ch << 11)                           ' ch cfg: %xx_ccc_xxx
#ifdef __OUTPUT_ASM__
    sp := ( (clkfreq/3_200_000) )               ' calc SCK period best-case
#endif
    outa[CS] := 0
        repeat 2                                ' result is delayed 16 clocks; read twice
            repeat b from 15 to 0
                outa[SCK] := 0
                outa[MOSI] := ch.[b]            ' set the channel
                wd.[b] := ina[MISO]             ' read the conversion
                outa[SCK] := 1
#ifdef __OUTPUT_ASM__
                waitcnt(cnt+sp)
#endif
    outa[CS] := 1

    return (wd & $fff)


PUB adc2volts(adc_word): volts
' Scale ADC word to microvolts
    return u64.multdiv(_adc_ref, adc_word, _adc_range)


PUB opmode(m)
' dummy method for API compatibility with other drivers


PUB ref_voltage(): v
' Get currently set reference voltage
'   Returns: microvolts
    return _adc_ref


PUB set_adc_channel(ch)
' Set ADC channel for subsequent reads
'   Valid values: 0..3
    _ch := 0 #> ch <# 3


PUB set_ref_voltage(v): curr_v
' Set ADC reference/supply voltage (Vdd), in microvolts
'   Valid values: 2_700_000..5_250_000 (2.7 .. 5.25V)
    _adc_ref := (2_700000 #> v <# 5_250000)


DAT
{
Copyright 2024 Jesse Burt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}


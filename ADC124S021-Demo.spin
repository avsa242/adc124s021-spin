{
----------------------------------------------------------------------------------------------------
    Filename:       ADC124S021-Demo.spin
    Description:    Demo of the ADC124S021 driver
    Author:         Jesse Burt
    Started:        Apr 3, 2024
    Updated:        Apr 5, 2024
    Copyright (c) 2024 - See end of file for terms of use.
----------------------------------------------------------------------------------------------------
}

CON

    _clkmode    = xtal1+pll16x
    _xinfreq    = 5_000_000


OBJ

    cfg:    "boardcfg.activity"
    time:   "time"
    ser:    "com.serial.terminal.ansi" | SER_BAUD=115_200
    adc:    "signal.adc.adc124s021" | CS=cfg.ADC_CS, SCK=cfg.ADC_SCL, MOSI=cfg.ADC_DI, ...
                                        MISO=cfg.ADC_DO


PUB main() | ch, v

    ser.start()
    time.msleep(30)
    ser.clear()
    ser.strln(@"Serial terminal started")

    if ( adc.start() )
        ser.strln(@"ADC124S021 driver started")
    else
        ser.strln(@"ADC124S021 driver failed to start - halting")
        repeat

    adc.preset_prop_activityboard()             ' preset for Activity bord (5.0V reference)

'    adc.set_ref_voltage(5_000_000)              ' set reference voltage (Vref pin)

    { show voltage reading from each channel on a separate line }
    repeat
        repeat ch from 0 to (adc.ADC_CHANNELS-1)
            adc.set_adc_channel(ch)             ' select channel (# available is model-dependent)
            v := adc.voltage()
            ser.pos_xy(0, 3+ch)
            ser.printf3(@"CH%d Voltage: %d.%06.6dv", ch, (v / VF), ||(v // VF))


CON VF  = 1_000_000                             ' voltage scaling factor


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


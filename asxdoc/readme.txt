
       ASxxxx Cross Assemblers, Version 5.50.5, January 2026 

       The  ASxxxx  assemblers are a series of microprocessor assemblers
    written in the C programming  language.   This  collection  contains
    cross  assemblers  for  the  1802, S2650, 4040(4004), SC/MP, MPS430,
    6100, 61860, 6500, 6800(6802/6808), 6801(6803/HD6303),  6804,  6805,
    68HC(S)08,  6809,  68HC11, 68HC(S)12, 68HC16, 68CF, 68K, 740, 78K/0,
    78K/0S, 8008, 8008S, 8048(8041/8022/8021), 8051, 8085(8080), AT89LP,
    8X300(8X305),  COP4,  COP8,  DS8XCXXX,  AVR,  EZ8,  EZ80, F2MC8L/FX,
    F8/3870, GameBoy(Z80), H8/3xx, Cypress PSoC(M8C), PDP11, PIC, Rabbit
    2000/3000,    RS08,    ST6,    ST7,    ST8,    SX,    TLCS90,    Z8,
    Z80(HD64180,ZXN,8080,8085), and Z280  series  microprocessors.   The
    companion  program  ASLINK is a relocating linker supporting all the
    cross assemblers.  ASLINK also supports object  files  created  with
    the 4.xx and 3.xx assemblers.  

       The assemblers and linker have been tested using Linux and DJGPP,
    Cygwin, Symantec C/C++  V7.2,  Borland  Turbo C++ 3.0,  Open  Watcom
    V1.9,  VC6,  Visual  Studio  2005,  2010, 2013, 2015, 2019 and 2022.
    Complete source code and documentation for the assemblers and linker
    is included with the distribution.  Additionally, test code for each
    assembler and several microprocessor monitors  (  ASSIST05  for  the
    6805,  MONDEB  and  ASSIST09 for the 6809, BUFFALO 2.5 for the 6811,
    and MONDEB for 8051 / AT89LP series ) are included as working  exam-
    ples of use of these assemblers.  

    asxv5p50p5.zip      ASxxxx and ASlink V5.50.5 Zipped
    
        MS-DOS:
        Windows:        unzip asxv5p50p5.zip
                        pkunzip -d asxv5p50p5.zip
                        unzips and restores directory structure
    
        Linux:          unzip -L -a asxv5p50p5.zip
                        unzips to lower-case names and converts
                        ascii files to \n from \r\n form.
    
    
    Makefiles or Build command files are in directories:
    
        Linux:          /asxv5pxx/asxmak/linux/build/
    
        Cygwin:         \asxv5pxx\asxmak\cygwin\build\
    
        DJGPP:          \asxv5pxx\asxmak\djgpp\build\
    
        Symantec:       \asxv5pxx\asxmak\symantec\build\
    
        TurboC:         \asxv5pxx\asxmak\TurboC30\build\
    
        VC6:            \asxv5pxx\asxmak\vc6\build\
    
        VS05:           \asxv5pxx\asxmak\vs05\build\
    
        VS10:           \asxv5pxx\asxmak\vs10\build\
    
        VS13:           \asxv5pxx\asxmak\vs13\build\
    
        VS15:           \asxv5pxx\asxmak\vs15\build\
    
        VS19:           \asxv5pxx\asxmak\vs19\build\
    
        VS22:           \asxv5pxx\asxmak\vs22\build\
    
        Watcom:         \asxv5pxx\asxmak\watcom\build\
    
    
    The Make or Build Exectutable directories are:
    
        Linux:          /asxv5pxx/asxmak/linux/exe/
    
        Cygwin:         \asxv5pxx\asxmak\cygwin\exe\
    
        DJGPP:          \asxv5pxx\asxmak\djgpp\exe\
    
        Symantec:       \asxv5pxx\asxmak\symantec\exe\
    
        TurboC:         \asxv5pxx\asxmak\TurboC30\exe\
    
        VC6:            \asxv5pxx\asxmak\vc6\exe\
    
        VS05:           \asxv5pxx\asxmak\vs05\exe\
    
        VS10:           \asxv5pxx\asxmak\vs10\exe\
    
        VS13:           \asxv5pxx\asxmak\vs13\exe\
    
        VS15:           \asxv5pxx\asxmak\vs15\exe\
    
        VS19:           \asxv5pxx\asxmak\vs19\exe\
    
        VS22:           \asxv5pxx\asxmak\vs22\exe\
    
        Watcom:         \asxv5pxx\asxmak\watcom\exe\
    
    
        Documentation (V 5.50) in pdf form is
        \asxv5pxx\asxhtml\asmlnk.pdf
    
        Documentation (V 5.50) in rtf form is
        \asxv5pxx\asxhtml\asmlnk.rtf
    
        Documentation (V 5.50.5) in plain text form is
        \asxv5pxx\asxhtml\asmlnk.txt
    
        Documentation (V 5.50.5) in HTML form starts with
        \asxv5pxx\asxhtml\asxxxx.htm
    
    
    /*
     *  Copyright (C) 1989-2026 Alan R. Baldwin
     *
     *  This program is free software: you can redistribute it and/or
     *  modify it under the terms of the GNU General Public License
     *  as published by the Free Software Foundation, either version 3
     *  of the License, or (at your option) any later version.
     *
     *  This program is distributed in the hope that it will be useful,
     *  but WITHOUT ANY WARRANTY; without even the implied warranty of
     *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     *  GNU General Public License for more details.
     *
     *  You should have received a copy of the GNU General Public
     *  License along with this program.
     *  If not, see <http://www.gnu.org/licenses/>.
     */

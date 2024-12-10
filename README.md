# Saturn 4bpp Graphics Converter
A utility to convert between SEGA Saturn 4bpp graphic format and bitmaps.

After dumping both a 4bpp graphics file and its corresponding palette file from a SEGA Saturn game and identifying its dimensions, `4bpp-2-bmp` can be used to convert said graphic data to a bitmap for editing. After editing the bitmap, it can be converted back to its original 4bpp graphic format using `bmp-2-4bpp`.

## Current Version
Saturn 4bpp Graphics Converter is currently at version [1.0](https://github.com/DerekPascarella/-Saturn-4bpp-Graphics-Converter/releases/download/1.0/Saturn.4bpp.Graphics.Converter.v1.0.zip).

## Usage
Note that the output filename of `4bpp-2-bmp` will be the input filename with the `.BMP` extension appended (e.g., an input file named `TEX.BIN` will produce `TEX.BIN.BMP`).
```
4bpp-2-bmp <4BPP_FILE> <PALETTE_FILE> <PALETTE_INDEX> <WIDTH> <HEIGHT>
```
Note that the output filename of `bmp-2-4bpp` will be the input filename with the `.BMP` extension removed (e.g., an input file named `TEX.BIN.BMP` will produce `TEX.BIN`).
```
bmp-2-4bpp <BITMAP_FILE> <PALETTE_FILE> <PALETTE_INDEX> <WIDTH> <HEIGHT>
```

## Example Usage
Convert a 64x16 4bpp graphic file named `TEX.BIN` to bitmap using palette the first palette index (i.e., `0`) from palette file `TEX.PAL`.
```
4pp-2-bmp TEX.BIN TEX.PAL 0 64 16
```
Convert a 64x16 bitmap named `TEX.BIN.BMP` to 4bpp graphic format using palette the first palette index (i.e., `0`) from palette file `TEX.PAL`.
```
bmp-2-15bpp TEX.BIN.BMP TEX.PAL 0 64 16
```

## Tutorial
[Malenko](https://segaxtreme.net/members/malenko.22808/) published a fantastic tutorial on ripping and replacing SEGA Saturn graphic assets on the [SegaXtreme](https://segaxtreme.net) forums. Click the preview screenshot below to access it.

[![Tutorial Screenshot](https://github.com/DerekPascarella/-Saturn-4bpp-Graphics-Converter/blob/main/tutorial.png?raw=true)](https://segaxtreme.net/threads/lets-replace-sega-saturn-graphics.25295/)

Note that Malenko also created a guide on the usage of the [Saturn 15bpp Graphics Converter](https://github.com/DerekPascarella/Saturn-15bpp-Graphics-Converter), which may prove helpful to those wishing to use Saturn 4bpp Graphics Converter.

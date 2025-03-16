extends Resource
class_name ASCIIPalette

enum Palettes {
    BASIC,
    SMOOTH,
    EXTENDED,
    DETAILED,
    ULTRA_DETAILED,
    SUPER_DETAILED,
    BLOCKY,
    SYMBOLS,
    MINIMAL,
    OUTLINE,
    DIGITAL,
    MATRIX,
    GLITCH,
    COLOR,
    EMOJI
}

var ascii_palettes: Dictionary = {
    Palettes.BASIC: "@#*+=-:. ",
    Palettes.SMOOTH: "@%#*+=-:. ",
    Palettes.EXTENDED: "@8#0Oo+=-., ",
    Palettes.DETAILED: "@#$%&?*+;:,. ",
    Palettes.ULTRA_DETAILED: "@#%xo;:,. ",
    Palettes.SUPER_DETAILED: " .'`^\",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$",
    Palettes.BLOCKY: "█▓▒░",
    Palettes.SYMBOLS: "$@&%*+~^;,. ",
    Palettes.MINIMAL: "@#*-. ",
    Palettes.OUTLINE: "#0o-. ",
    Palettes.DIGITAL: "#0OIl ",
    Palettes.MATRIX: "#/|!;,. ",
    Palettes.GLITCH: "@#%XO*-. ",
    Palettes.COLOR: "⬛🟫🟥🟧🟨🟩🟦🟪⬜", 
    Palettes.EMOJI: "😀🤢🥶🫥👿😡"
}

const Image_Format = {
    "L8": Image.FORMAT_L8,
    "LA8": Image.FORMAT_LA8,
    "R8": Image.FORMAT_R8,
    "RG8": Image.FORMAT_RG8,
    "RGB8": Image.FORMAT_RGB8,
    "RGBA8": Image.FORMAT_RGBA8,
    "RGBA4444": Image.FORMAT_RGBA4444,
    "RGB565": Image.FORMAT_RGB565,
    "RF": Image.FORMAT_RF,
    "RGF": Image.FORMAT_RGF,
    "RGBF": Image.FORMAT_RGBF,
    "RGBAF": Image.FORMAT_RGBAF,
    "RH": Image.FORMAT_RH,
    "RGH": Image.FORMAT_RGH,
    "RGBH": Image.FORMAT_RGBH,
    "RGBAH": Image.FORMAT_RGBAH,
    "RGBE9995": Image.FORMAT_RGBE9995,
    "DXT1": Image.FORMAT_DXT1,
    "DXT3": Image.FORMAT_DXT3,
    "DXT5": Image.FORMAT_DXT5,
    "RGTC_R": Image.FORMAT_RGTC_R,
    "RGTC_RG": Image.FORMAT_RGTC_RG,
    "BPTC_RGBF": Image.FORMAT_BPTC_RGBF,
    "BPTC_RGBFU": Image.FORMAT_BPTC_RGBFU,
    "BPTC_RGBA": Image.FORMAT_BPTC_RGBA,
    "ETC": Image.FORMAT_ETC,
    "ETC2_R11": Image.FORMAT_ETC2_R11,
    "ETC2_R11S": Image.FORMAT_ETC2_R11S,
    "ETC2_RG11": Image.FORMAT_ETC2_RG11,
    "ETC2_RG11S": Image.FORMAT_ETC2_RG11S,
    "ETC2_RGB8": Image.FORMAT_ETC2_RGB8,
    "ETC2_RGBA8": Image.FORMAT_ETC2_RGBA8,
    "ETC2_RGB8A1": Image.FORMAT_ETC2_RGB8A1,
    "ASTC_4x4": Image.FORMAT_ASTC_4x4,
    "ASTC_8x8": Image.FORMAT_ASTC_8x8,
    "MAX": Image.FORMAT_MAX
}

func get_palette(palette_id: Palettes) -> String:
    return ascii_palettes.get(palette_id, "@")

func get_palette_name(palette_id: Palettes) -> String:
    return Palettes.keys().get(palette_id)

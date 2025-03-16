extends Resource
class_name ASCII

var image: Image = Image.new()

func generate_ascii(palette_dict: Dictionary, reverse_palette: bool = false) -> String: 
    if not image: return ""
    var palette_name: String = palette_dict.name
    var palette: String = palette_dict.value
    rescale_image(is_special_palette(palette_name))
    
    var output = ""
    for y in range(image.get_height()):
        for x in range(image.get_width()):
            var index = floor(get_intensity(x, y) * (palette.length() - 1))
            output += palette.reverse()[index] if reverse_palette else palette[index]
        output += "\n"
    
    return output

func load_image(file_path: String) -> Dictionary:
    var error: Error = image.load(file_path)
    var texture: Texture2D
    if error == OK:
        texture = ImageTexture.create_from_image(image)
    else:
        printerr("File may have special characters in it's name. Rename and try again.")
        return {}
        
    return {
        "image": image,
        "texture": texture,
    }

func rescale_image(_is_special_palette: bool, default_image_scale: Vector2 = Vector2(100, 42), special_image_scale: Vector2 =Vector2(60, 64)) -> void:
    var new_width: int = int(default_image_scale.x) if not _is_special_palette else int(special_image_scale.x)
    var new_height: int = int(default_image_scale.y) if not _is_special_palette else int(special_image_scale.y)
    image.resize(new_width, new_height, Image.INTERPOLATE_BILINEAR)
    
func get_intensity(x: float, y: float) -> float:
    var color = image.get_pixel(int(x), int(y))
    return color.r
    
func is_special_palette(palette_name: String) -> bool:
    return palette_name.to_lower().contains("color") || palette_name.to_lower().contains("emoji")

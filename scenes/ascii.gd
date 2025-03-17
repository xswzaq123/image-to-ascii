extends Resource
class_name ASCII

signal image_rescaled(img_texture: ImageTexture)

var original_image: Image = Image.new()


func generate_ascii(image: Image, palette_dict: Dictionary, t: TextureRect, reverse_palette: bool = false) -> String:
    if not image: return ""

    var palette_name: String = palette_dict.name
    var palette: String = palette_dict.value
    var scaled_image: Image = rescale_image(image, is_special_palette(palette_name)).get_image()
    t.set_texture(rescale_image(image, is_special_palette(palette_name)))
    # generate ascii art
    var output: String = ""
    for y in range(scaled_image.get_height()):
        for x in range(scaled_image.get_width()):
            var index = floor(get_intensity(scaled_image, x, y) * (palette.length() - 1))
            output += palette.reverse()[index] if reverse_palette else palette[index]
        output += "\n"
    
    return output

func load_image(file_path: String) -> Dictionary:
    var error: Error = original_image.load(file_path)
    var texture: ImageTexture

    if error == OK:
        texture = ImageTexture.create_from_image(original_image)
    else:
        printerr("File may have special characters in it's name. Rename and try again.")
        return {}

    var image: Image = original_image.duplicate(true)
    return {
        "image": image,
        "texture": texture,
    }

func rescale_image(image: Image, _is_special_palette: bool, default_image_scale: Vector2 = Vector2(100, 42), special_image_scale: Vector2 = Vector2(60, 64)) -> ImageTexture:
    var new_width: int = int(default_image_scale.x) if not _is_special_palette else int(special_image_scale.x)
    var new_height: int = int(default_image_scale.y) if not _is_special_palette else int(special_image_scale.y)
    var new_texture: ImageTexture = duplicate_image_and_create_new_texture(image, func(img: Image): img.resize(new_width, new_height, Image.INTERPOLATE_BILINEAR))
    image_rescaled.emit(new_texture)
    return new_texture

func convert_image_texture(new_format: Image.Format) -> ImageTexture:
    var new_texture: ImageTexture = duplicate_image_and_create_new_texture(original_image, func(img): img.convert(new_format))
    return new_texture

func get_intensity(image: Image, x: float, y: float) -> float:
    var color = image.get_pixel(int(x), int(y))
    return color.r
    
func is_special_palette(palette_name: String) -> bool:
    return palette_name.to_lower().contains("color") || palette_name.to_lower().contains("emoji")

func duplicate_image_and_create_new_texture(image: Image, callbackFn: Callable) -> ImageTexture:
    var dup_image: Image = image.duplicate(true)
    callbackFn.call(dup_image as Image)
    return ImageTexture.create_from_image(dup_image)

func get_aspect_ratio(image: Image) -> float:
    return float(image.get_width()) / float(image.get_height())

func get_image_properties(image: Image) -> Dictionary[String, Variant]:
    var image_format_id: int = image.get_format()
    return {
        "id": image.get_instance_id(),
        "width": image.get_width(),
        "height": image.get_height(),
        "aspect_ratio": get_aspect_ratio(image),
        "format": {"id": image_format_id}
    }

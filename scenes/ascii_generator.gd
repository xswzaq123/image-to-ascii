extends Control

const grayscale_shader = preload("res://shaders/grayscale.gdshader")

#region defaults
# the id of the current palette
@export var palette_id: ASCIIPalette.Palettes:
    set(value):
        palette_id = value
        selected_palette = ascii_palette.get_palette(palette_id)
        palette_name = ascii_palette.get_palette_name(palette_id)
        # sync editor changes with UI
        if palette_option_btn:
            palette_option_btn.select(palette_id)
@export var reverse_palette: bool = false:
    set(value):
        reverse_palette = value
        # sync editor changes with UI
        if reverse_palette_btn:
            reverse_palette_btn.button_pressed = reverse_palette
#endregion

#region customizations
# prefix "special" used for palettes that has emojis in it 
@export_group("Customizations")
@export var default_font_size: int = 8
@export var default_image_scale: Vector2 = Vector2(100, 40)
@export var special_font_size: int = 4
@export var special_image_scale: Vector2 = Vector2(40, 40)
#endregion

#region references
@export_group("References")
@export var generate_ascii_btn: Button
@export var load_image_btn: Button
@export var result_label: RichTextLabel
@export var result_label2: CodeEdit
@export var grayscale_texture_rect: TextureRect
@export var display_texture_rect: TextureRect
@export var placeholder_texture_rect: ColorRect
# settings - UI
@export var palette_option_btn: OptionButton
@export var reverse_palette_btn: CheckButton
#endregion

var ascii_palette = ASCIIPalette.new()
var selected_palette: String # the actual palette in string format
var palette_name: String = ascii_palette.get_palette_name(palette_id)
var image_format: Image.Format = Image.FORMAT_L8
var load_btn_clicked: bool = false # state to manage load btn clicked and disable it to prevent pressing it multiple times
var output: String:
    set(value):
        output = value
        display_ascii()
var ascii = ASCII.new()
var generate_ascii: Callable = func(): output = ascii.generate_ascii({"name": palette_name, "value": selected_palette},reverse_palette)

func _ready() -> void:
    setup_environment()
    connect_signals()

#region inits
func setup_environment() -> void:
    init_option_button()
    sync_ui_with_editor()
    # actual setting - setting these here so that it looks good in the main scene (main scene using dummy settings to look good in editor)
    grayscale_texture_rect.set_visible(false)
    result_label.set_v_size_flags(Control.SIZE_SHRINK_BEGIN)
    result_label.set_stretch_ratio(1.0)
    result_label.set_v_size_flags(Control.SIZE_SHRINK_CENTER)
    
    display_texture_rect.set_visible(false)
    result_label.set_modulate(Color(result_label.get_modulate(), 0.0))
    apply_grayscale_shader(grayscale_texture_rect)

func init_option_button() -> void:
    # populate palette otion btn
    var palette_array: Array = ASCIIPalette.Palettes.keys()
    for p in palette_array:
        palette_option_btn.add_item(p)
    # sync with editor selected option
    
func connect_signals() -> void:
    generate_ascii_btn.pressed.connect(generate_ascii)
    load_image_btn.pressed.connect(open_native_file_dialog)
    selected_palette = ascii_palette.get_palette(palette_id)
    palette_option_btn.item_selected.connect(palette_option_changed)
    reverse_palette_btn.toggled.connect(toggle_reverse)
    #image_format_option_btn.item_selected.connect(on_image_format_change)

func sync_ui_with_editor() -> void:
    palette_option_btn._select_int(palette_id)
    reverse_palette_btn.button_pressed = reverse_palette
#endregion

#region click handlers
func palette_option_changed(id: int) -> void:
    selected_palette = ascii_palette.get_palette(id)
    palette_name = ascii_palette.get_palette_name(id)

func toggle_reverse(value: bool) -> void:
    reverse_palette = value
  
func open_native_file_dialog() -> void:
    if load_btn_clicked: return
    load_btn_clicked = true
    
    var file_output = []
    var cmd = """
    Add-Type -AssemblyName System.Windows.Forms; 
    $f = New-Object System.Windows.Forms.OpenFileDialog; 
    $f.Filter = 'Image Files|*.png;*.jpg;*.jpeg'; 
    $f.ShowDialog() | Out-Null; 
    $f.FileName
    """
    
    OS.execute("powershell", ["-NoProfile", "-WindowStyle", "Hidden", "-Command", cmd], file_output, true, false)
    
    # on cancelled
    if file_output.size() == 0 or file_output[0].strip_edges() == "":
        print("❌ File selection canceled.")
        load_btn_clicked = false
        return

    # on selected
    var file_path = file_output[0].strip_edges()
    print("✅ File selected:", file_path)
    var result = ascii.load_image(file_path)
    if result:
        on_image_loaded(result)
    else: load_btn_clicked = false
#endregion

func on_image_loaded(dict: Dictionary) -> void:
    var texture = dict.texture
    var image = dict.image
    
    # apply texture
    grayscale_texture_rect.set_texture(texture)
    display_texture_rect.set_texture(texture)
    
    # hide placeholder rect if visible
    if placeholder_texture_rect:
        placeholder_texture_rect.set_visible(false)
        display_texture_rect.set_visible(true)
    convert_image_texture(image, image_format)
    await get_tree().create_timer(0.5).timeout
    load_btn_clicked = false

#func on_image_format_change(id: int) -> void:
    #image_format = ASCIIPalette.Image_Format[image_format_option_btn.get_item_text(id)]

func apply_grayscale_shader(texture: Variant) -> void:
    var shader_mat: ShaderMaterial = ShaderMaterial.new()
    shader_mat.set_shader(grayscale_shader)
    texture.material = shader_mat

func convert_image_texture(image: Image, new_format: Image.Format) -> void:
    image.convert(new_format)

func display_ascii() -> void:
    result_label.clear()
    update_font_size(result_label, ascii.is_special_palette(palette_name), default_font_size, special_font_size)
    result_label.append_text("[code]" + output + "[/code]")
    result_label.set_modulate(Color(result_label.get_modulate(), 1.0))

func update_font_size(output_label: RichTextLabel, _is_special_palette: bool, _default_font_size: int = 8, _special_font_size: int = 4) -> void:
    print(_is_special_palette, palette_name)
    var new_font_size: int = _default_font_size if not _is_special_palette else _special_font_size
    output_label.add_theme_font_size_override("mono_font_size", new_font_size)

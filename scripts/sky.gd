@tool

extends Node3D;

# Instance
var time_of_day: float = 0.0;
var one_second: float = 1.0 / (24.0 * 60.0 * 60.0); # --- What part of a second takes in a day in the range from 0 to 1
var sun_pos: Vector3;
var moon_pos: Vector3;
var god_rays: Node3D;
var iTime: float = 0.0;

var env: Environment;

# Nodes
#@export var sunMoon: DirectionalLight3D;
#@export var worldEnv: WorldEnvironment;
@onready  var sunMoon: DirectionalLight3D = $SunMoon;
@onready  var worldEnv: WorldEnvironment = $WorldEnvironment;

# Sky
#@export var skyViewport: SubViewport;
#@export var skyTexture: Sprite2D;
@onready  var skyViewport: SubViewport = $SkyViewport;
@onready  var skyTexture: Sprite2D = $SkyViewport/SkyTexture;

# Clouds
#@export var cloudsViewport: SubViewport;
#@export var cloudsTexture: Sprite2D;
@onready  var cloudsViewport: SubViewport = $CloudsViewport;
@onready  var cloudsTexture: Sprite2D = $CloudsViewport/CloudsTexture;

@export_range(0.0, 1.0, 0.01) var time_of_day_setup: float  = 0.0:
	get:
		return time_of_day_setup;
	set(value):
		time_of_day_setup = value;
		set_time_of_day(time_of_day_setup);

# setget | Sky & Clouds
@export var clouds_resolution: int = 1024:
	get:
		return clouds_resolution;
	set(value):
		clouds_resolution = value;
		set_clouds_resolution(clouds_resolution);

@export var sky_resolution: int = 2048:
	get:
		return sky_resolution;
	set(value):
		sky_resolution = value;
		set_sky_resolution(sky_resolution);

@export var sky_gradient_texture: GradientTexture2D:
	get:
		return sky_gradient_texture;
	set(value):
		sky_gradient_texture = value;
		set_sky_gradient(sky_gradient_texture);

@export var SCATERRING: bool = false:
	get:
		return SCATERRING;
	set(value):
		SCATERRING = value;
		set_SCATERRING(SCATERRING);

@export var color_sky: Color = Color(0.25,0.5,1.0,1.0):
	get:
		return color_sky;
	set(value):
		color_sky = value;
		set_color_sky(color_sky);

@export_range(0.0, 10.0, 0.1) var sky_tone: float = 3.0:
	get:
		return sky_tone;
	set(value):
		sky_tone = value;
		set_sky_tone(sky_tone);

@export_range(0.0, 2.0, 0.01) var sky_density: float = 0.75:
	get:
		return sky_density;
	set(value):
		sky_density = value;
		set_sky_density(sky_density);

@export_range(0.0, 10.0, 0.01) var sky_rayleig_coeff: float = 0.75:
	get:
		return sky_rayleig_coeff;
	set(value):
		sky_rayleig_coeff = value;
		set_sky_rayleig_coeff(sky_rayleig_coeff);

@export_range(0.0, 10.0, 0.1) var sky_mie_coeff: float = 2.0:
	get:
		return sky_mie_coeff;
	set(value):
		sky_mie_coeff = value;
		set_sky_mie_coeff(sky_mie_coeff);

@export_range(0.0, 2.0, 0.1) var multiScatterPhase: float = 0.0:
	get:
		return multiScatterPhase;
	set(value):
		multiScatterPhase = value;
		set_multiScatterPhase(multiScatterPhase);

@export_range(0.0, 2.0, 0.1) var anisotropicIntensity: float = 0.0:
	get:
		return anisotropicIntensity;
	set(value):
		anisotropicIntensity = value;
		set_anisotropicIntensity(anisotropicIntensity);

@export_range(0, 23, 1) var hours: int = 0:
	get:
		return hours;
	set(value):
		hours = value;
		set_hours(hours);

@export_range(0, 59, 1) var minutes: int = 0:
	get:
		return minutes;
	set(value):
		minutes = value;
		set_minutes(minutes);

@export_range(0, 59, 1) var seconds: int = 0:
	get:
		return seconds;
	set(value):
		seconds = value;
		set_seconds(seconds);

@export_range(0.0, 1.0, 0.01) var clouds_coverage: float = 0.5:
	get:
		return clouds_coverage;
	set(value):
		clouds_coverage = value;
		set_clouds_coverage(clouds_coverage);

@export_range(0.0, 10.0, 0.1) var clouds_size: float = 2.0:
	get:
		return clouds_size;
	set(value):
		clouds_size = value;
		set_clouds_size(clouds_size);

@export_range(0.0, 1.0, 0.1) var clouds_softness: float = 1.0:
	get:
		return clouds_softness;
	set(value):
		clouds_softness = value;
		set_clouds_softness(clouds_softness);

@export_range(0.0, 1.0, 0.01) var clouds_dens: float = 0.07:
	get:
		return clouds_dens;
	set(value):
		clouds_dens = value;
		set_clouds_dens(clouds_dens);

@export_range(0.0, 1.0, 0.01) var clouds_height: float = 0.35:
	get:
		return clouds_height;
	set(value):
		clouds_height = value;
		set_clouds_height(clouds_height);

@export_range(1, 100, 1) var clouds_quality: int = 25:
	get:
		return clouds_quality;
	set(value):
		clouds_quality = value;
		set_clouds_quality(clouds_quality);

@export var moon_light: Color = Color(0.6, 0.6, 0.8, 1.0);
@export var sunset_light: Color = Color(1.0, 0.7, 0.55, 1.0);
@export var sunset_offset: float = -0.1;
@export var sunset_range: float = 0.2;
@export var day_light: Color = Color(1.0, 1.0, 1.0, 1.0);

@export var moon_tint: Color = Color(1.0, 0.7, 0.35, 1.0):
	get:
		return moon_tint;
	set(value):
		moon_tint = value;
		set_moon_tint(moon_tint);

@export var clouds_tint :Color = Color(1.0, 1.0, 1.0, 1.0):
	get:
		return clouds_tint;
	set(value):
		clouds_tint = value;
		set_clouds_tint(clouds_tint);

@export_range(0.0, 1.0, 0.01) var sun_radius: float = 0.04:
	get:
		return sun_radius;
	set(value):
		sun_radius = value;
		set_sun_radius(sun_radius);

@export_range(0.0, 1.0, 0.01) var moon_radius: float = 0.1:
	get:
		return moon_radius;
	set(value):
		moon_radius = value;
		set_moon_radius(moon_radius);

@export_range(0.0, 1.0, 0.01) var moon_phase: float = 0.0:
	get:
		return moon_phase;
	set(value):
		moon_phase = value;
		set_moon_phase(moon_phase);

@export_range(0.0, 1.0, 0.01) var night_level_light: float = 0.05:
	get:
		return night_level_light;
	set(value):
		night_level_light = value;

@export var wind_dir: Vector2 = Vector2(1.0, 0.0):
	get:
		return wind_dir;
	set(value):
		wind_dir = value.normalized();
		set_wind_dir(wind_dir);

@export_range(0.0, 1.0, 0.1) var wind_strength: float = 0.1:
	get:
		return wind_strength;
	set(value):
		wind_strength = value;
		set_wind_strength(wind_strength);

@export var lighting_pos: Vector3 = Vector3(0.0, 1.0, 1.0):
	get:
		return lighting_pos;
	set(value):
		lighting_pos = value.normalized();
		set_lighting_pos(lighting_pos);

func set_call_deff_shader_params(node: Material, params:String, value):
	node.set(params,value)

func set_clouds_resolution(value: int):
	if is_inside_tree():
		cloudsViewport.size = Vector2(value,value);
		cloudsTexture.texture.set_size_override(Vector2(value,value));

func set_sky_resolution(value: int):
	if is_inside_tree():
		skyViewport.size = Vector2(value,value)
		skyTexture.texture.set_size_override(Vector2(value,value))
	
func _ready():
	god_rays = get_node_or_null("GodRays")
	env = worldEnv.environment;

	_set_god_rays(false);
	set_lighting_strike(false);
	set_clouds_resolution(sky_resolution);
	set_clouds_resolution(clouds_resolution);
	call_deferred("set_sky_resolution", sky_resolution)
	call_deferred("set_clouds_resolution", clouds_resolution)
	call_deferred("_set_attenuation", 3.0)
	call_deferred("_set_exposure", 1.0)
	call_deferred("_set_light_size", 0.2)
	call_deferred("set_color_sky", color_sky)
	call_deferred("set_moon_tint", moon_tint)
	call_deferred("set_clouds_tint", clouds_tint)
	call_deferred("set_moon_phase", moon_phase)
	call_deferred("set_moon_radius", moon_radius)
	call_deferred("set_wind_strength", wind_strength)
	call_deferred("set_wind_strength", wind_strength)
	call_deferred("set_clouds_quality", clouds_quality)
	call_deferred("set_clouds_height", clouds_height)
	call_deferred("set_clouds_coverage", clouds_coverage)
	call_deferred("set_time")
	call_deferred("reflections_update")

func reflections_update():
	#env.background_sky.set_panorama(null)
	#env.background_sky.set_panorama(skyViewport.get_texture());
	await RenderingServer.frame_post_draw;
	env.sky.sky_material.set_panorama(skyViewport.get_texture());

func set_SCATERRING(_value :bool):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "SCATERRING",SCATERRING)

func set_sky_gradient(_value: GradientTexture2D):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "sky_gradient_texture",sky_gradient_texture)

func set_hours(_value: int):
	set_time_of_day((hours*3600+minutes*60+seconds)*one_second);
		
func set_minutes(_value: int):
	set_time_of_day((hours*3600+minutes*60+seconds)*one_second);
	
func set_seconds(_value: int):
	set_time_of_day((hours*3600+minutes*60+seconds)*one_second);
		
func set_time_of_day(value: float):
	var time: float = value/one_second;
	value -= 2.0/24.0;
	if value < 0.0:
		value = 1.0 + value;

	time_of_day = value

	var _hours = int(clamp(time/3600.0,0.0,23.0))
	time -= _hours*3600
	var _minutes = int(clamp(time/60,0.0,59.0))
	time -= _minutes*60
	var _seconds = int(clamp(time,0.0,59.0))
	#print (_hours, ":", _minutes, ":", _seconds)
	set_time();

func set_time():
	print('set time');
	if !is_inside_tree():
		return

	var light_color: Color = Color(1.0,1.0,1.0,1.0);
	var phi: float = time_of_day * 2.0 * PI;

	sun_pos = Vector3(0.0,-1.0,0.0).normalized().rotated(Vector3(1.0,0.0,0.0).normalized(),phi) #here you can change the start position of the Sun and axis of rotation
	moon_pos = Vector3(0.0,1.0,0.0).normalized().rotated(Vector3(1.0,0.0,0.0).normalized(),phi) #Same for Moon
	var moon_tex_pos: Vector3 = Vector3(0.0,1.0,0.0).normalized().rotated(Vector3(1.0,0.0,0.0).normalized(),(phi+PI)*0.5) #This magical formula for shader
	var light_energy: float = smoothstep(sunset_offset,0.4, sun_pos.y);# light intensity depending on the height of the sun

	if (skyTexture != null):
		call_deferred("set_call_deff_shader_params", skyTexture.material, "MOON_TEX_POS",moon_tex_pos)
		call_deferred("set_call_deff_shader_params", skyTexture.material, "SUN_POS",sun_pos)
		call_deferred("set_call_deff_shader_params", skyTexture.material, "MOON_POS",moon_pos)
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "SUN_POS",-sun_pos)
		call_deferred("set_call_deff_shader_params", skyTexture.material, "attenuation",clamp(light_energy,night_level_light*0.25,1.00))#clouds to bright with night_level_light

	light_energy = clamp(light_energy, night_level_light, 2.0);
	var sun_height: float = sun_pos.y-sunset_offset;

	if sun_height < sunset_range:
		light_color=color_lerp(moon_light, sunset_light, clamp(sun_height/sunset_range,0.0,1.0));
	else:
		light_color=color_lerp(sunset_light, day_light, clamp((sun_height-sunset_range)/sunset_range,0.0,1.0));

	if sun_pos.y < 0.0:
		if moon_pos.normalized() != Vector3.UP:# error  Up vector and direction between node origin and target are aligned, look_at() failed.
			sunMoon.look_at_from_position(moon_pos,Vector3.ZERO,Vector3.UP); # move sun to position and look at center scene from position
	else:
		if sun_pos.normalized() != Vector3.UP:
			sunMoon.look_at_from_position(sun_pos,Vector3.ZERO,Vector3.UP); # move sun to position and look at center scene from position

	set_clouds_tint(light_color) # comment this, if you need custom clouds tint
	light_energy = light_energy * (1-clouds_coverage * 0.5)
	sunMoon.light_energy = light_energy;
	sunMoon.light_color = light_color;

	env.ambient_light_energy = light_energy
	env.ambient_light_color = light_color
	env.adjustment_saturation = 1-clouds_coverage*0.5
	env.fog_light_color = light_color;
	call_deferred("reflections_update")

	env.volumetric_fog_albedo = light_color;
	print(day_light);


func set_clouds_height(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "HEIGHT",clouds_height)

func set_clouds_coverage(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "ABSORPTION",clouds_coverage+0.75)
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "COVERAGE",1.0-(clouds_coverage*0.7+0.1))
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "THICKNESS",clouds_coverage*10.0+10.0)
		call_deferred("set_time")

func set_clouds_size(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "SIZE",clouds_size)

func set_clouds_softness(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "SOFTNESS",clouds_softness)

func set_clouds_dens(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "DENS",clouds_dens)

func set_clouds_quality(_value: int):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "STEPS", clamp (clouds_quality,5,100))

func set_wind_dir(_value: Vector2):
	set_wind_strength(wind_strength);

func set_wind_strength(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", cloudsTexture.material, "WIND",Vector3(wind_dir.x,0.0,wind_dir.y)*wind_strength)

func set_sun_radius(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "sun_radius", sun_radius);

func set_moon_radius(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "moon_radius", moon_radius)

func set_moon_phase(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "MOON_PHASE",moon_phase)#*0.4-0.2) # convert to diapazon -0.2...+0.2

func set_sky_tone(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "sky_tone",sky_tone)

func set_sky_density(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "sky_density",sky_density)

func set_sky_rayleig_coeff(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "sky_rayleig_coeff",sky_rayleig_coeff)

func set_sky_mie_coeff(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "sky_mie_coeff", sky_mie_coeff)

func set_multiScatterPhase(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "multiScatterPhase", multiScatterPhase)

func set_anisotropicIntensity(_value: float):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "anisotropicIntensity", anisotropicIntensity)

func set_color_sky(_value: Color):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "color_sky", color_sky)

func set_moon_tint(_value: Color):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "moon_tint", moon_tint)

func set_clouds_tint(_value: Color):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "clouds_tint", clouds_tint)

func _process(delta: float):
	iTime += delta

	var lighting_strength = clamp(sin(iTime*20.0),0.0,1.0);
	sunMoon.light_color = day_light
	sunMoon.light_energy = lighting_strength*2
	sunMoon.look_at_from_position(lighting_pos,Vector3.ZERO,Vector3.UP);

	call_deferred("set_call_deff_shader_params", skyTexture.material, "LIGHTTING_POS", lighting_pos)
	call_deferred("set_call_deff_shader_params", skyTexture.material, "LIGHTING_STRENGTH",Vector3(lighting_strength,lighting_strength,lighting_strength))

func set_lighting_strike(on: bool):
	if on:
		_set_god_rays(false)
		set_process(true)
	else:
		_set_god_rays(true)
		set_process(false)
		iTime = 0.0
		if skyTexture:
			call_deferred("set_call_deff_shader_params", skyTexture.material, "LIGHTING_STRENGTH",Vector3(0.0,0.0,0.0))
		set_time()

func set_lighting_pos(_value):
	if is_inside_tree():
		call_deferred("set_call_deff_shader_params", skyTexture.material, "LIGHTTING_POS", _value)

func thunder():
	var thunder_sound: AudioStreamPlayer = $thunder;
	if thunder_sound.is_playing():
		#thunder_sound.stop()
		return;

	thunder_sound.play()
	await get_tree().create_timer(0.3).timeout;
	set_lighting_strike(true)
	await get_tree().create_timer(0.8).timeout;
	set_lighting_strike(false)

func _set_exposure(value: float):
	if god_rays:
		god_rays.set_exposure(value)

func _set_attenuation(value: float):
	if god_rays:
		god_rays.set_attenuation(value)

func _set_light_size(value: float):
	if god_rays:
		god_rays.set_light_size(value)

func _set_god_rays(on: bool):
	if not god_rays:
		return
	if on:
		if !god_rays.is_inside_tree():
			add_child(god_rays)
		god_rays.light = sunMoon;
		god_rays.set_clouds(cloudsViewport.get_texture())
	else:
		remove_child(god_rays)

func color_lerp(from: Color, to: Color, weight: float):
	var r = lerp(from.r, to.r, weight);
	var g = lerp(from.g, to.g, weight);
	var b = lerp(from.b, to.b, weight);
	var a = lerp(from.a, to.a, weight);
	var newColor = Color(from.r, from.g, from.b, from.a);

	return newColor;



// COLOR

// space conversion
function gmui_hsv_to_rgb(h, s, v) {
    h = frac(h) * 6;
    var i = floor(h);
    var f = h - i;
    var p = v * (1 - s);
    var q = v * (1 - s * f);
    var t = v * (1 - s * (1 - f));
    var r, g, b;
    switch (i) {
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        default: r = v; g = p; b = q; break;
    }
    return [clamp(r * 255, 0, 255), clamp(g * 255, 0, 255), clamp(b * 255, 0, 255)];
}

function gmui_rgb_to_hsv(r, g, b) {
    var rf = r / 255, gf = g / 255, bf = b / 255;
    var maxc = max(rf, gf, bf);
    var minc = min(rf, gf, bf);
    var delta = maxc - minc;
    var h = 0, s = 0, v = maxc;
    if (delta != 0) {
        s = delta / maxc;
        if      (maxc == rf) h = ((gf - bf) / delta) mod 6;
        else if (maxc == gf) h = ((bf - rf) / delta) + 2;
        else                 h = ((rf - gf) / delta) + 4;
        h /= 6;
        if (h < 0) h += 1;
    }
    return [h, s, v];
}

function gmui_color_to_hsv(color) {
    return gmui_rgb_to_hsv(color_get_red(color), color_get_green(color), color_get_blue(color));
}

function gmui_color_from_hsv(hsv) {
    var rgb = gmui_hsv_to_rgb(hsv[0], hsv[1], hsv[2]);
    return make_color_rgb(rgb[0], rgb[1], rgb[2]);
}


function gmui_make_color_rgba(r, g, b, a) { // (R | G<<8 | B<<16 | A<<24)
    return (clamp(r, 0, 255))
         | (clamp(g, 0, 255) << 8)
         | (clamp(b, 0, 255) << 16)
         | (clamp(a, 0, 255) << 24);
}

function gmui_color_rgba_get_red(color)   { return  color        & 0xFF; }
function gmui_color_rgba_get_green(color) { return (color >>  8) & 0xFF; }
function gmui_color_rgba_get_blue(color)  { return (color >> 16) & 0xFF; }
function gmui_color_rgba_get_alpha(color) { return (color >> 24) & 0xFF; }

function gmui_color_rgb_to_rgba(color, alpha = 255) { // GML BGR to RGBA
    return gmui_make_color_rgba(
        color_get_red(color),
        color_get_green(color),
        color_get_blue(color),
        alpha
    );
}

function gmui_color_rgba_to_rgb(color) { // GMUI RGBA to GML BGR
    return make_color_rgb(
        gmui_color_rgba_get_red(color),
        gmui_color_rgba_get_green(color),
        gmui_color_rgba_get_blue(color)
    );
}

// array stuff
function gmui_color_rgba_to_array(color) {
    return [
        gmui_color_rgba_get_red(color),
        gmui_color_rgba_get_green(color),
        gmui_color_rgba_get_blue(color),
        gmui_color_rgba_get_alpha(color)
    ];
}

function gmui_color_rgb_to_array(color) {
    return [color_get_red(color), color_get_green(color), color_get_blue(color)];
}

function gmui_color_rgba_from_array(arr) {
    return gmui_make_color_rgba(arr[0], arr[1], arr[2], arr[3]);
}

// manipulation
function gmui_color_scale(color, factor) {
    return gmui_make_color_rgba(
        clamp(gmui_color_rgba_get_red(color)   * factor, 0, 255),
        clamp(gmui_color_rgba_get_green(color) * factor, 0, 255),
        clamp(gmui_color_rgba_get_blue(color)  * factor, 0, 255),
        gmui_color_rgba_get_alpha(color)
    );
}

function gmui_color_lighten(color, factor) {
    return gmui_color_scale(color, max(factor, 0));
}

function gmui_color_darken(color, factor) {
    return gmui_color_scale(color, clamp(factor, 0, 1));
}

function gmui_color_set_alpha(color, alpha) {
    return (color & 0x00FFFFFF) | (clamp(alpha, 0, 255) << 24);
}

function gmui_color_shift_hue(color, delta) {
    var hsv = gmui_color_to_hsv(gmui_color_rgba_to_rgb(color));
    hsv[@ 0] = frac(hsv[0] + delta);
    var rgb = gmui_hsv_to_rgb(hsv[0], hsv[1], hsv[2]);
    return gmui_make_color_rgba(rgb[0], rgb[1], rgb[2], gmui_color_rgba_get_alpha(color));
}

function gmui_color_saturate(color, factor) {
    var hsv = gmui_color_to_hsv(gmui_color_rgba_to_rgb(color));
    hsv[@ 1] = clamp(hsv[1] * factor, 0, 1);
    var rgb = gmui_hsv_to_rgb(hsv[0], hsv[1], hsv[2]);
    return gmui_make_color_rgba(rgb[0], rgb[1], rgb[2], gmui_color_rgba_get_alpha(color));
}

function gmui_color_premultiply_alpha(color) {
    var a = gmui_color_rgba_get_alpha(color) / 255;
    return gmui_make_color_rgba(
        gmui_color_rgba_get_red(color)   * a,
        gmui_color_rgba_get_green(color) * a,
        gmui_color_rgba_get_blue(color)  * a,
        gmui_color_rgba_get_alpha(color)
    );
}

// interpolation
function gmui_color_lerp(color1, color2, t) {
    t = clamp(t, 0, 1);
    return gmui_make_color_rgba(
        lerp(gmui_color_rgba_get_red(color1),   gmui_color_rgba_get_red(color2),   t),
        lerp(gmui_color_rgba_get_green(color1), gmui_color_rgba_get_green(color2), t),
        lerp(gmui_color_rgba_get_blue(color1),  gmui_color_rgba_get_blue(color2),  t),
        lerp(gmui_color_rgba_get_alpha(color1), gmui_color_rgba_get_alpha(color2), t)
    );
}

function _gmui_lerp_color(c1, c2, t) {
    t = clamp(t, 0, 1);
    return make_color_rgb(
        lerp(color_get_red(c1),   color_get_red(c2),   t),
        lerp(color_get_green(c1), color_get_green(c2), t),
        lerp(color_get_blue(c1),  color_get_blue(c2),  t)
    );
}

function _gmui_lerp_color_gradient(gradient, t) { // t [0,1]
    t = clamp(t, 0, 1);
    var stops = array_length(gradient);
    if (stops == 0) return c_white;
    if (stops == 1) return gradient[0];
    var segment = t * (stops - 1);
    var index   = floor(segment);
    var f       = segment - index;
    if (index >= stops - 1) return gradient[stops - 1];
    return _gmui_lerp_color(gradient[index], gradient[index + 1], f);
}

function gmui_lerp_rgba_gradient(gradient, t) {
    t = clamp(t, 0, 1);
    var stops = array_length(gradient);
    if (stops == 0) return gmui_make_color_rgba(255, 255, 255, 255);
    if (stops == 1) return gradient[0];
    var segment = t * (stops - 1);
    var index   = floor(segment);
    var f       = segment - index;
    if (index >= stops - 1) return gradient[stops - 1];
    return gmui_color_lerp(gradient[index], gradient[index + 1], f);
}

// parsing
function gmui_color_from_hex(hex_str) {
    if (string_char_at(hex_str, 1) == "#") {
        hex_str = string_copy(hex_str, 2, string_length(hex_str) - 1);
    }
    
    var len = string_length(hex_str);
    
    if (len == 3) {
        var r = string_char_at(hex_str, 1);
        var g = string_char_at(hex_str, 2);
        var b = string_char_at(hex_str, 3);
        hex_str = r + r + g + g + b + b;
        len = 6;
    }
    
    if (len != 6) return c_fuchsia; // unrecognised format
    
    var r = _gmui_hex_pair_to_int(string_copy(hex_str, 1, 2));
    var g = _gmui_hex_pair_to_int(string_copy(hex_str, 3, 2));
    var b = _gmui_hex_pair_to_int(string_copy(hex_str, 5, 2));
    
    if (r < 0 || g < 0 || b < 0) return c_fuchsia;
    return make_color_rgb(r, g, b);
}

function gmui_color_rgba_from_hex(hex_str) { // default alpha 255
    if (string_char_at(hex_str, 1) == "#") {
        hex_str = string_copy(hex_str, 2, string_length(hex_str) - 1);
    }
    
    var len = string_length(hex_str);
    
    if (len == 3) {
        var r = string_char_at(hex_str, 1);
        var g = string_char_at(hex_str, 2);
        var b = string_char_at(hex_str, 3);
        hex_str = r + r + g + g + b + b + "FF";
        len = 8;
    } else if (len == 4) {
        var r = string_char_at(hex_str, 1);
        var g = string_char_at(hex_str, 2);
        var b = string_char_at(hex_str, 3);
        var a = string_char_at(hex_str, 4);
        hex_str = r + r + g + g + b + b + a + a;
        len = 8;
    } else if (len == 6) {
        hex_str += "FF";
        len = 8;
    }
    
    if (len != 8) return gmui_make_color_rgba(255, 0, 255, 255); // error sentinel
    
    var r = _gmui_hex_pair_to_int(string_copy(hex_str, 1, 2));
    var g = _gmui_hex_pair_to_int(string_copy(hex_str, 3, 2));
    var b = _gmui_hex_pair_to_int(string_copy(hex_str, 5, 2));
    var a = _gmui_hex_pair_to_int(string_copy(hex_str, 7, 2));
    
    if (r < 0 || g < 0 || b < 0 || a < 0) return gmui_make_color_rgba(255, 0, 255, 255);
    return gmui_make_color_rgba(r, g, b, a);
}

function gmui_color_to_hex(color) { // GML BGR to '#RRGGBB' STRING
    return "#"
        + _gmui_int_to_hex_pair(color_get_red(color))
        + _gmui_int_to_hex_pair(color_get_green(color))
        + _gmui_int_to_hex_pair(color_get_blue(color));
}

function gmui_color_rgba_to_hex(color) { // GMUI RGBA to '#RRGGBBAA' STRING
    return "#"
        + _gmui_int_to_hex_pair(gmui_color_rgba_get_red(color))
        + _gmui_int_to_hex_pair(gmui_color_rgba_get_green(color))
        + _gmui_int_to_hex_pair(gmui_color_rgba_get_blue(color))
        + _gmui_int_to_hex_pair(gmui_color_rgba_get_alpha(color));
}

function gmui_color_rgba_to_css(color) { // GMUI RGBA to "rgba(r, g, b, a)" CSS STRING - ALPHA [0,1]
    var a_norm = gmui_color_rgba_get_alpha(color) / 255;
    var a_str  = string_format(a_norm, 1, 3);
    return "rgba("
        + string(gmui_color_rgba_get_red(color))   + ", "
        + string(gmui_color_rgba_get_green(color)) + ", "
        + string(gmui_color_rgba_get_blue(color))  + ", "
        + a_str + ")";
}

function gmui_color_rgba_from_css(css_str) { // CSS "rgb(r, g, b)" or "rgba(r, g, b, a)" STRING to GMUI RGBA
    css_str = string_lower(css_str);
    
    var p_open  = string_pos("(", css_str);
    var p_close = string_pos(")", css_str);
    if (p_open == 0 || p_close == 0) return gmui_make_color_rgba(255, 0, 255, 255);
    
    var inner = string_copy(css_str, p_open + 1, p_close - p_open - 1);
    
    var parts = _gmui_string_split(inner, ",");
    if (array_length(parts) < 3) return gmui_make_color_rgba(255, 0, 255, 255);
    
    var r = clamp(round(real(string_trim(parts[0]))), 0, 255);
    var g = clamp(round(real(string_trim(parts[1]))), 0, 255);
    var b = clamp(round(real(string_trim(parts[2]))), 0, 255);
    var a = 255;
    if (array_length(parts) >= 4) {
        a = clamp(round(real(string_trim(parts[3])) * 255), 0, 255);
    }
    
    return gmui_make_color_rgba(r, g, b, a);
}

function gmui_color_from_name(name) { // CSS to GML BGR
    var c = _gmui_css_named_colors();
    var key = string_lower(name);
    if (ds_map_exists(c, key)) {
        var hex = c[? key];
        ds_map_destroy(c);
        return gmui_color_from_hex(hex);
    }
    ds_map_destroy(c);
    return c_fuchsia;
}

// helpers
function _gmui_hex_pair_to_int(pair) {
    pair = string_upper(pair);
    var hi = _gmui_hex_char_value(string_char_at(pair, 1));
    var lo = _gmui_hex_char_value(string_char_at(pair, 2));
    if (hi < 0 || lo < 0) return -1;
    return (hi * 16) + lo;
}

function _gmui_hex_char_value(ch) {
    if (ch >= "0" && ch <= "9") return real(ch) - 48;
    if (ch >= "A" && ch <= "F") return real(ch) - 55;
    return -1;
}

function _gmui_int_to_hex_pair(n) {
    n = clamp(round(n), 0, 255);
    var hi = n div 16;
    var lo = n mod 16;
    return _gmui_hex_digit(hi) + _gmui_hex_digit(lo);
}

function _gmui_hex_digit(n) {
    if (n < 10) return string(n);
    return chr(55 + n);
}

function _gmui_string_split(str, delim) {
    var result = [];
    var dlen   = string_length(delim);
    var pos    = string_pos(delim, str);
    while (pos > 0) {
        array_push(result, string_copy(str, 1, pos - 1));
        str = string_copy(str, pos + dlen, string_length(str));
        pos = string_pos(delim, str);
    }
    array_push(result, str);
    return result;
}

function _gmui_css_named_colors() {
    var m = ds_map_create();
    m[? "aliceblue"]            = "F0F8FF"; m[? "antiquewhite"]         = "FAEBD7";
    m[? "aqua"]                 = "00FFFF"; m[? "aquamarine"]           = "7FFFD4";
    m[? "azure"]                = "F0FFFF"; m[? "beige"]                = "F5F5DC";
    m[? "bisque"]               = "FFE4C4"; m[? "black"]                = "000000";
    m[? "blanchedalmond"]       = "FFEBCD"; m[? "blue"]                 = "0000FF";
    m[? "blueviolet"]           = "8A2BE2"; m[? "brown"]                = "A52A2A";
    m[? "burlywood"]            = "DEB887"; m[? "cadetblue"]            = "5F9EA0";
    m[? "chartreuse"]           = "7FFF00"; m[? "chocolate"]            = "D2691E";
    m[? "coral"]                = "FF7F50"; m[? "cornflowerblue"]       = "6495ED";
    m[? "cornsilk"]             = "FFF8DC"; m[? "crimson"]              = "DC143C";
    m[? "cyan"]                 = "00FFFF"; m[? "darkblue"]             = "00008B";
    m[? "darkcyan"]             = "008B8B"; m[? "darkgoldenrod"]        = "B8860B";
    m[? "darkgray"]             = "A9A9A9"; m[? "darkgreen"]            = "006400";
    m[? "darkgrey"]             = "A9A9A9"; m[? "darkkhaki"]            = "BDB76B";
    m[? "darkmagenta"]          = "8B008B"; m[? "darkolivegreen"]       = "556B2F";
    m[? "darkorange"]           = "FF8C00"; m[? "darkorchid"]           = "9932CC";
    m[? "darkred"]              = "8B0000"; m[? "darksalmon"]           = "E9967A";
    m[? "darkseagreen"]         = "8FBC8F"; m[? "darkslateblue"]        = "483D8B";
    m[? "darkslategray"]        = "2F4F4F"; m[? "darkslategrey"]        = "2F4F4F";
    m[? "darkturquoise"]        = "00CED1"; m[? "darkviolet"]           = "9400D3";
    m[? "deeppink"]             = "FF1493"; m[? "deepskyblue"]          = "00BFFF";
    m[? "dimgray"]              = "696969"; m[? "dimgrey"]              = "696969";
    m[? "dodgerblue"]           = "1E90FF"; m[? "firebrick"]            = "B22222";
    m[? "floralwhite"]          = "FFFAF0"; m[? "forestgreen"]          = "228B22";
    m[? "fuchsia"]              = "FF00FF"; m[? "gainsboro"]            = "DCDCDC";
    m[? "ghostwhite"]           = "F8F8FF"; m[? "gold"]                 = "FFD700";
    m[? "goldenrod"]            = "DAA520"; m[? "gray"]                 = "808080";
    m[? "green"]                = "008000"; m[? "greenyellow"]          = "ADFF2F";
    m[? "grey"]                 = "808080"; m[? "honeydew"]             = "F0FFF0";
    m[? "hotpink"]              = "FF69B4"; m[? "indianred"]            = "CD5C5C";
    m[? "indigo"]               = "4B0082"; m[? "ivory"]                = "FFFFF0";
    m[? "khaki"]                = "F0E68C"; m[? "lavender"]             = "E6E6FA";
    m[? "lavenderblush"]        = "FFF0F5"; m[? "lawngreen"]            = "7CFC00";
    m[? "lemonchiffon"]         = "FFFACD"; m[? "lightblue"]            = "ADD8E6";
    m[? "lightcoral"]           = "F08080"; m[? "lightcyan"]            = "E0FFFF";
    m[? "lightgoldenrodyellow"] = "FAFAD2"; m[? "lightgray"]            = "D3D3D3";
    m[? "lightgreen"]           = "90EE90"; m[? "lightgrey"]            = "D3D3D3";
    m[? "lightpink"]            = "FFB6C1"; m[? "lightsalmon"]          = "FFA07A";
    m[? "lightseagreen"]        = "20B2AA"; m[? "lightskyblue"]         = "87CEFA";
    m[? "lightslategray"]       = "778899"; m[? "lightslategrey"]       = "778899";
    m[? "lightsteelblue"]       = "B0C4DE"; m[? "lightyellow"]          = "FFFFE0";
    m[? "lime"]                 = "00FF00"; m[? "limegreen"]            = "32CD32";
    m[? "linen"]                = "FAF0E6"; m[? "magenta"]              = "FF00FF";
    m[? "maroon"]               = "800000"; m[? "mediumaquamarine"]     = "66CDAA";
    m[? "mediumblue"]           = "0000CD"; m[? "mediumorchid"]         = "BA55D3";
    m[? "mediumpurple"]         = "9370DB"; m[? "mediumseagreen"]       = "3CB371";
    m[? "mediumslateblue"]      = "7B68EE"; m[? "mediumspringgreen"]    = "00FA9A";
    m[? "mediumturquoise"]      = "48D1CC"; m[? "mediumvioletred"]      = "C71585";
    m[? "midnightblue"]         = "191970"; m[? "mintcream"]            = "F5FFFA";
    m[? "mistyrose"]            = "FFE4E1"; m[? "moccasin"]             = "FFE4B5";
    m[? "navajowhite"]          = "FFDEAD"; m[? "navy"]                 = "000080";
    m[? "oldlace"]              = "FDF5E6"; m[? "olive"]                = "808000";
    m[? "olivedrab"]            = "6B8E23"; m[? "orange"]               = "FFA500";
    m[? "orangered"]            = "FF4500"; m[? "orchid"]               = "DA70D6";
    m[? "palegoldenrod"]        = "EEE8AA"; m[? "palegreen"]            = "98FB98";
    m[? "paleturquoise"]        = "AFEEEE"; m[? "palevioletred"]        = "DB7093";
    m[? "papayawhip"]           = "FFEFD5"; m[? "peachpuff"]            = "FFDAB9";
    m[? "peru"]                 = "CD853F"; m[? "pink"]                 = "FFC0CB";
    m[? "plum"]                 = "DDA0DD"; m[? "powderblue"]           = "B0E0E6";
    m[? "purple"]               = "800080"; m[? "rebeccapurple"]        = "663399";
    m[? "red"]                  = "FF0000"; m[? "rosybrown"]            = "BC8F8F";
    m[? "royalblue"]            = "4169E1"; m[? "saddlebrown"]          = "8B4513";
    m[? "salmon"]               = "FA8072"; m[? "sandybrown"]           = "F4A460";
    m[? "seagreen"]             = "2E8B57"; m[? "seashell"]             = "FFF5EE";
    m[? "sienna"]               = "A0522D"; m[? "silver"]               = "C0C0C0";
    m[? "skyblue"]              = "87CEEB"; m[? "slateblue"]            = "6A5ACD";
    m[? "slategray"]            = "708090"; m[? "slategrey"]            = "708090";
    m[? "snow"]                 = "FFFAFA"; m[? "springgreen"]          = "00FF7F";
    m[? "steelblue"]            = "4682B4"; m[? "tan"]                  = "D2B48C";
    m[? "teal"]                 = "008080"; m[? "thistle"]              = "D8BFD8";
    m[? "tomato"]               = "FF6347"; m[? "turquoise"]            = "40E0D0";
    m[? "violet"]               = "EE82EE"; m[? "wheat"]                = "F5DEB3";
    m[? "white"]                = "FFFFFF"; m[? "whitesmoke"]           = "F5F5F5";
    m[? "yellow"]               = "FFFF00"; m[? "yellowgreen"]          = "9ACD32";
    return m;
}
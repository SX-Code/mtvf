//!HOOK OUTPUT
//!BIND HOOKED
//!DESC [色觉辅助] 黑/白滤镜（全色盲适配）

vec4 hook() {
    // 获取原始像素颜色
    vec4 color = HOOKED_tex(HOOKED_pos);
    vec3 rgb = color.rgb;

    // 标准灰度转换公式（ITU-R BT.709 亮度系数）
    float luminance = 0.2126 * rgb.r + 0.7152 * rgb.g + 0.0722 * rgb.b;
    // 生成灰度色彩
    vec3 gray = vec3(luminance);

    // 轻微提升对比度，优化全色盲视觉效果
    gray = (gray - 0.5) * 1.1 + 0.5;
    gray = clamp(gray, 0.0, 1.0);

    return vec4(gray, color.a);
}
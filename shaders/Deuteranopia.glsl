//!HOOK OUTPUT
//!BIND HOOKED
//!DESC [色觉辅助] 绿/红滤镜（绿色盲适配）

// Daltonize算法：将绿色盲无法感知的红绿差异转移到红蓝通道
// 核心原理：绿色盲患者M视锥细胞缺失，无法区分红绿，将差异转移到可感知的红蓝通道

// 绿色盲模拟矩阵（模拟绿色盲看到的颜色）
const mat3 DEUTAN_SIM = mat3(
    0.625, 0.375, 0.000,
    0.700, 0.300, 0.000,
    0.000, 0.300, 0.700
);

// 转移矩阵：将差异分配到红蓝通道
const mat3 DEUTAN_TRANSFER = mat3(
    0.7, 0.7, 0.7,
    0.0, 0.0, 0.0,
    0.7, 0.7, 0.7
);

vec4 hook() {
    vec4 color = HOOKED_tex(HOOKED_pos);
    vec3 original = color.rgb;

    // 1. 模拟绿色盲视觉
    vec3 cbColor = DEUTAN_SIM * original;

    // 2. 计算原图与模拟图的差异
    vec3 error = original - cbColor;

    // 3. 将差异转移到红蓝通道
    vec3 correction = DEUTAN_TRANSFER * error;

    // 4. 将修正叠加到模拟图上
    vec3 corrected = cbColor + correction;

    // 5. 与原图混合（80%矫正强度）
    vec3 result = mix(original, corrected, 0.8);

    // 6. 范围保护
    result = clamp(result, 0.0, 1.0);

    return vec4(result, color.a);
}
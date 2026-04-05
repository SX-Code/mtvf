//!HOOK OUTPUT
//!BIND HOOKED
//!DESC [色觉辅助] 蓝/黄滤镜（蓝色盲适配）

// Daltonize算法：将蓝色盲无法感知的蓝黄差异转移到红绿通道
// 核心原理：蓝色盲患者S视锥细胞缺失，无法区分蓝黄，将差异转移到可感知的红绿通道

// 蓝色盲模拟矩阵（模拟蓝色盲看到的颜色）
const mat3 TRITAN_SIM = mat3(
    0.950, 0.050, 0.000,
    0.000, 0.433, 0.567,
    0.000, 0.475, 0.525
);

// 转移矩阵：将差异分配到红绿通道
const mat3 TRITAN_TRANSFER = mat3(
    0.7, 0.7, 0.7,
    0.7, 0.7, 0.7,
    0.0, 0.0, 0.0
);

vec4 hook() {
    vec4 color = HOOKED_tex(HOOKED_pos);
    vec3 original = color.rgb;

    // 1. 模拟蓝色盲视觉
    vec3 cbColor = TRITAN_SIM * original;

    // 2. 计算原图与模拟图的差异
    vec3 error = original - cbColor;

    // 3. 将差异转移到红绿通道
    vec3 correction = TRITAN_TRANSFER * error;

    // 4. 将修正叠加到模拟图上
    vec3 corrected = cbColor + correction;

    // 5. 与原图混合（80%矫正强度）
    vec3 result = mix(original, corrected, 0.8);

    // 6. 范围保护
    result = clamp(result, 0.0, 1.0);

    return vec4(result, color.a);
}
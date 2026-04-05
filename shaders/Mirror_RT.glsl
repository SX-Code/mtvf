//!HOOK OUTPUT
//!BIND HOOKED
//!DESC [mirror_RT] 全局水平镜像（无动态参数）

vec4 hook() {
    vec2 pos = HOOKED_pos;
    // 核心：水平镜像（左右翻转），写死无需参数
    pos.x = 1.0 - pos.x;
    // 采样镜像后的纹理像素
    return HOOKED_tex(pos);
}
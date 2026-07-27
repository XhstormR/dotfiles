// ============================================================================
// GHOSTTY CURSOR FOCUS SHADER
// ============================================================================
// Displays a zooming cursor highlight animation when the window gains focus.
// Early exits when not in active animation for minimal performance impact.
//
// Copyright (c) 2025 Martin Emde
// ============================================================================

// ---------------------------------------------------------------------------
// 可配置参数（集中在此，便于按需调整外观与手感）
// ---------------------------------------------------------------------------
const float PULSE_DURATION = 0.2;   // 动画时长（秒）

// 缩放矩形大小：动画起始时高亮矩形相对光标的放大倍数，随进度收敛到 1x。
// 数值越大，聚焦时“聚拢”动画的初始矩形越大、视觉冲击越强。
const float ZOOM_START_SCALE = 10.0;  // 起始放大倍数（原 6.0，已增大）
const float ZOOM_END_SCALE = 1.0;     // 结束放大倍数（贴合光标本身）

// 透明度区间：动画从半透明淡入到接近不透明。
const float OPACITY_START = 0.15;
const float OPACITY_END = 0.8;

// 软边半宽（像素）：dist 在 [-EDGE_SOFTNESS, +EDGE_SOFTNESS] 间平滑过渡。
const float EDGE_SOFTNESS = 2.0;

// 渐变高亮颜色：复刻 cursor_blaze.glsl 的双色效果
// 内部填充黄色（TRAIL_COLOR），边缘描红橙色（TRAIL_COLOR_ACCENT）
const vec3 TRAIL_COLOR = vec3(1.0, 0.725, 0.161);        // 黄色
const vec3 TRAIL_COLOR_ACCENT = vec3(1.0, 0.0, 0.0);     // 红橙色

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Quick exit: only run during active focus animation
    float timeSinceFocus = iTime - iTimeFocus;
    if (iFocus == 0 || timeSinceFocus < 0.0 || timeSinceFocus > PULSE_DURATION) {
        fragColor = texture(iChannel0, fragCoord / iResolution.xy);
        return;
    }

    vec4 originalColor = texture(iChannel0, fragCoord / iResolution.xy);

    // Animation progress: 0.0 at start, 1.0 at end
    float progress = timeSinceFocus / PULSE_DURATION;

    // Fade in: 从 OPACITY_START 淡入到 OPACITY_END
    float opacity = mix(OPACITY_START, OPACITY_END, progress);

    // Calculate scaled cursor rectangle
    // iCurrentCursor.xy is top-left corner (Y-down coordinate system)
    vec2 cursorSize = iCurrentCursor.zw;
    vec2 cursorCenter = iCurrentCursor.xy + cursorSize * vec2(0.5, -0.5);
    vec2 offset = fragCoord - cursorCenter;

    // 缩放矩形半宽 = 光标半尺寸 × 当前缩放（从 ZOOM_START_SCALE 收敛到 ZOOM_END_SCALE）
    vec2 halfSize = cursorSize * (0.5 * mix(ZOOM_START_SCALE, ZOOM_END_SCALE, progress));

    // Soft-edged cursor shape
    // dist < 0 表示在缩放矩形内部，= 0 为边缘，> 0 为外部；复用 dist
    // 同时驱动软边、内外判定与双色渐变，避免重复计算 abs(offset)。
    vec2 edgeDist = abs(offset) - halfSize;
    float dist = max(edgeDist.x, edgeDist.y);

    // 早退：像素在软边范围（EDGE_SOFTNESS）之外，pulse 恒为 0，无需混合。
    if (dist >= EDGE_SOFTNESS) {
        fragColor = originalColor;
        return;
    }

    // 软边：dist 从 +EDGE_SOFTNESS（外）到 -EDGE_SOFTNESS（内）平滑过渡，跨越边界连续，
    // 不再用 dist<0 硬裁剪（那会在边界产生 0.5→0 的跳变，与“软边”自相矛盾）。
    float pulse = smoothstep(EDGE_SOFTNESS, -EDGE_SOFTNESS, dist) * opacity;

    // 双色渐变：越靠近边缘越偏红橙，越靠内部越偏黄（对齐 cursor_blaze.glsl）
    // dist 在边缘附近约为 0，向内部变为负值；用其到边缘的深度控制混合。
    float edgeWidth = min(halfSize.x, halfSize.y);
    float innerFactor = smoothstep(0.0, edgeWidth, -dist);
    vec3 highlightColor = mix(TRAIL_COLOR_ACCENT, TRAIL_COLOR, innerFactor);

    // Blend cursor color with original
    vec3 finalColor = mix(originalColor.rgb, highlightColor, pulse);
    fragColor = vec4(finalColor, originalColor.a);
}

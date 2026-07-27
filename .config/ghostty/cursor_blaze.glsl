// Based on https://gist.github.com/chardskarth/95874c54e29da6b5a36ab7b50ae2d088
float ease(float x) {
    return pow(1.0 - x, 10.0);
}

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}
// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    // pq = p - proj，其中 proj = a + e*t；直接用 w - e*t 可省去一次向量加法（IQ 原版写法）。
    vec2 pq = w - e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    d = min(d, dot(pq, pq));

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

// 命名为 norm 而非 normalize，避免遮蔽 GLSL 内建的 normalize（对齐 cursor_smear_rocket.glsl）。
vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float blend(float t)
{
    float sqr = t * t;
    return sqr / (2.0 * (sqr - t) + 1.0);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    // Conditions using step
    float condition1 = step(b.x, a.x) * step(a.y, b.y); // a.x < b.x && a.y > b.y
    float condition2 = step(a.x, b.x) * step(b.y, a.y); // a.x > b.x && a.y < b.y

    // If neither condition is met, return 1 (else case)
    return 1.0 - max(condition1, condition2);
}
vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

const vec4 TRAIL_COLOR = vec4(1.0, 0.725, 0.161, 1.0); // yellow
const vec4 TRAIL_COLOR_ACCENT = vec4(1.0, 0., 0., 1.0); // red-orange
const float DURATION = .5;
// Don't draw trail within that distance * cursor size.
// This prevents trails from appearing when typing.
const float DRAW_THRESHOLD = 1.5;
// Don't draw trails within the same line: same line jumps are usually where
// people expect them.
const bool HIDE_TRAILS_ON_THE_SAME_LINE = false;
// 拖尾锥化系数：尾端（上一光标位置）宽度相对当前光标的比例，
// 0.0 = 收成一个点，1.0 = 保持等宽。用于模仿 rocket 的火箭尾迹形状。
const float TAPER_FACTOR = 0.1;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // 缓存 UV 与上一帧，避免后续重复采样。
    vec2 uv = fragCoord.xy / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    // 早退 1：窗口失焦时不绘制拖尾（对齐 cursor_smear_rocket.glsl）。
    if (iFocus == 0) {
        return;
    }

    // 早退 2：动画结束后无需绘制。progress 达到 1 时 easedProgress→0，
    // 拖尾完全消失，同时避免下方 alphaModifier 的除零/NaN。
    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));
    float easedProgress = ease(progress);
    if (progress >= 1.0 || easedProgress <= 0.0) {
        return;
    }

    //Normalization for cursor position and size;
    //cursor xy has the postion in a space of -1 to 1;
    //zw has the width and height
    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.), norm(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.), norm(iPreviousCursor.zw, 0.));

    // 早退 3：移动过小（打字）时不绘制。先用平方距离比较，避免昂贵的 sqrt。
    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    vec2 delta = centerCC - centerCP;
    float lineLengthSq = dot(delta, delta);

    float cursorSize = max(currentCursor.z, currentCursor.w);
    float trailThreshold = DRAW_THRESHOLD * cursorSize;
    bool isOnSeparateLine = HIDE_TRAILS_ON_THE_SAME_LINE ? currentCursor.y != previousCursor.y : true;
    if (lineLengthSq <= trailThreshold * trailThreshold || !isOnSeparateLine) {
        return;
    }

    // 仅在确实需要时才计算 sqrt。
    float lineLength = sqrt(lineLengthSq);

    //Normalization for fragCoord to a space of -1 to 1;
    vec2 vu = norm(fragCoord, 1.);

    // 早退 4：像素超出当前动画覆盖半径时，其拖尾贡献为 0，直接跳过 SDF 计算。
    float distanceToEnd = distance(vu.xy, centerCC);
    float alphaModifier = min(distanceToEnd / (lineLength * easedProgress), 1.0);
    if (alphaModifier >= 1.0) {
        return;
    }

    // 抗锯齿边缘宽度：等价于 norm(vec2(2.,2.),0.).x = 2.*2./iResolution.y，
    // 预计算一次而非每像素在 smoothstep 内重复求值。
    float aaWidth = 4.0 / iResolution.y;

    //When drawing a parellelogram between cursors for the trail i need to determine where to start at the top-left or top-right vertex of the cursor
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    //锥化尾迹：当前光标位置用完整宽度，上一光标位置按 TAPER_FACTOR 收窄，
    //形成头宽尾窄的火箭尾迹形状（对齐 cursor_smear_rocket.glsl）。
    vec2 currentWidth = currentCursor.zw;
    vec2 previousWidth = currentCursor.zw * TAPER_FACTOR;

    //Set every vertex of my parellogram
    //v0, v1 = 当前光标（全宽）；v2, v3 = 上一光标（收窄）
    vec2 v0 = vec2(currentCursor.x + currentWidth.x * vertexFactor, currentCursor.y - currentWidth.y);
    vec2 v1 = vec2(currentCursor.x + currentWidth.x * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + previousWidth.x * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + previousWidth.x * vertexFactor, previousCursor.y - previousWidth.y);

    // 光标中心即 centerCC（getRectangleCenter 已算过），无需再用 offsetFactor 重复推导。
    float sdfCursor = getSdfRectangle(vu, centerCC, currentCursor.zw * 0.5);
    float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

    vec4 newColor = fragColor;
    newColor = mix(newColor, TRAIL_COLOR_ACCENT, 1.0 - smoothstep(sdfTrail, -0.01, 0.001));
    newColor = mix(newColor, TRAIL_COLOR, 1.0 - smoothstep(0.0, aaWidth, sdfTrail));
    newColor = mix(fragColor, newColor, 1.0 - alphaModifier);
    fragColor = mix(newColor, fragColor, step(sdfCursor, 0.0));
}

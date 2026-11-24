/* The whole of the C in the Pentora machine's Wasm file: a 130-byte buffer and seven calls into the Lean-generated code. */
#include <lean/lean.h>
#include <string.h>
#include "exports.h"
void __wasm_call_ctors(void);
static bool started, bad;
static uint8_t buf[130];
static uint32_t len;
static void start(void) { if (!started) { __wasm_call_ctors(); r6_constants(); started = true; } }
uint32_t reset(void) { len = 0; bad = false; return 1; }
uint32_t input(uint32_t byte) {
    if (byte > 255 || len == sizeof(buf)) bad = true;
    if (bad) return 0;
    buf[len++] = (uint8_t)byte;
    return 1;
}
static lean_object *take(void) {
    if (bad) return NULL;
    start();
    lean_object *bytes = lean_alloc_sarray(1, len, len);
    memcpy(lean_sarray_cptr(bytes), buf, len);
    return bytes;
}
uint32_t judge(void) { lean_object *b = take(); return b ? pentora_judge(b) : 0xFFFFFFFFu; }
uint32_t seams(void) { lean_object *b = take(); return b ? pentora_seams(b) : 0xFFFFFFFFu; }
uint32_t suspects(void) { lean_object *b = take(); return b ? pentora_suspects(b) : 0xFFFFFFFFu; }
uint32_t addressByte(uint32_t i) { lean_object *b = take(); return b ? pentora_address_byte(b, i) : 0xFFFFFFFFu; }
uint32_t tally(uint32_t c, uint32_t t) { lean_object *b = take(); return b ? pentora_tally(b, c, t) : 0xFFFFFFFFu; }
uint32_t owner(uint32_t v, uint32_t w) { start(); return pentora_owner(v, w); }
uint32_t vertex(uint32_t c, uint32_t j) { start(); return pentora_vertex(c, j); }

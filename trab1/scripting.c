#include "scripting.h"
#include <GL/gl.h>
#include <lauxlib.h>
#include <lua.h>
#include <stdbool.h>
#include <sys/stat.h>

typedef struct {
  double a, b, c;
} v3;

v3 getv3(lua_State *L) {
  v3 v;
  if (lua_istable(L, -1)) {
    if (luaL_len(L, -1) == 3) {
      lua_geti(L, -1, 1);
      lua_geti(L, -2, 2);
      lua_geti(L, -3, 3);
    } else {
      lua_getfield(L, -1, "x");
      lua_getfield(L, -2, "y");
      lua_getfield(L, -3, "z");
    }
  }
  v.a = luaL_checknumber(L, -3);
  v.b = luaL_checknumber(L, -2);
  v.c = luaL_checknumber(L, -1);
  return v;
}

static int l_color(lua_State *L) {
  v3 color = getv3(L);
  glColor3f(color.a, color.b, color.c);
  return 0;
}

static int l_vertex(lua_State *L) {
  v3 vertex = getv3(L);
  glVertex3f(vertex.a, vertex.b, vertex.c);
  return 0;
}

static int l_begin(lua_State *L) {
  int it = luaL_checkinteger(L, -1);
  glBegin(it);
  return 0;
}

static int l_eend(lua_State *L) {
  glEnd();
  return 0;
}

void register_globals(lua_State *L) {
#define register(name)                                                         \
  lua_pushcfunction(L, l_##name);                                              \
  lua_setglobal(L, #name)
#define register_const(name)                                                   \
  lua_pushinteger(L, name);                                                    \
  lua_setglobal(L, #name)

  register(begin);
  register(color);
  register(vertex);
  register(eend);

  register_const(GL_POINTS);
  register_const(GL_LINES);
  register_const(GL_LINE_LOOP);
  register_const(GL_LINE_STRIP);
  register_const(GL_TRIANGLES);
  register_const(GL_TRIANGLE_STRIP);
  register_const(GL_TRIANGLE_FAN);
  register_const(GL_QUADS);
  register_const(GL_QUAD_STRIP);
  register_const(GL_POLYGON);

#undef register
}

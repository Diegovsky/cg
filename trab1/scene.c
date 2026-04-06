#include "scene.h"
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <stdbool.h>
#include <sys/stat.h>
#include <unistd.h>

const char *LUA_FILE = "gl.lua";

lua_State *L = NULL;
bool errored = false;
struct timespec last_edit;

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

static int on_error(lua_State *L) {
  errored = true;
  printf("Error");
  const char *text = lua_tostring(L, -1);
  printf(": '%s'", text);
  puts("");
  return 0;
}

int l_color(lua_State *L) {
  v3 color = getv3(L);
  glColor3f(color.a, color.b, color.c);
  return 0;
}

int l_vertex(lua_State *L) {
  v3 vertex = getv3(L);
  glVertex3f(vertex.a, vertex.b, vertex.c);
  return 0;
}

void reload_script() {
  if (luaL_dofile(L, LUA_FILE)) {
    puts("File has syntax errors");
    on_error(L);
    return;
  }
  lua_getglobal(L, "draw");
  if (!lua_isfunction(L, -1)) {
    lua_pushstring(L, "`draw` is not a function");
    on_error(L);
    return;
  }

  errored = false;
}

__attribute__((constructor)) static void init() {
  L = luaL_newstate();
  luaopen_string(L);
  luaL_openlibs(L);

  lua_pushcfunction(L, l_color);
  lua_setglobal(L, "color");

  lua_pushcfunction(L, l_vertex);
  lua_setglobal(L, "vertex");
  lua_atpanic(L, on_error);

  reload_script();
}

static bool more_recent(struct timespec a, struct timespec b) {
  if (a.tv_sec == b.tv_sec)
    return a.tv_nsec > b.tv_nsec;
  else
    return a.tv_sec > b.tv_sec;
}

void scene_idle() {
  struct stat buf;
  if (stat(LUA_FILE, &buf) == 0) {
    struct timespec now = buf.st_mtim;
    if (more_recent(now, last_edit)) {
      printf("Change detected, reloading file.\n");
      reload_script();
      last_edit = now;
    }
  }
  scene_draw();
}

void scene_draw() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  glBegin(GL_QUADS);
  if (!errored) {
    lua_getglobal(L, "draw");
    if (lua_pcall(L, 0, 0, 0)) {
      on_error(L);
    }
  }
  // glVertex3f(-0.5f, -0.5f, -5.0f);
  // glVertex3f(0.5f, -0.5f, -5.0f);
  // glVertex3f(0.5f, 0.5f, -5.0f);
  // glVertex3f(-0.5f, 0.5f, -5.0f);
  glEnd();

  glutSwapBuffers();
}

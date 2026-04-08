#include "scene.h"
#define DMON_IMPL
#include "dmon.h"
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <stdbool.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "scripting.h"

const char *LUA_FILE = "gl.lua";

lua_State *L = NULL;
bool errored = false;

static int on_error(lua_State *L) {
  errored = true;
  printf("Error");
  const char *text = lua_tostring(L, -1);
  printf(": '%s'", text);
  puts("");
  return 0;
}

void reload_script() {
    int top = lua_gettop(L);
    lua_pushglobaltable(L);

    luaL_dostring(L, "for k in pairs (package.loaded) do package.loaded[k] = nil; end");
    lua_settop(L, top);


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

void on_file_change(dmon_watch_id watch_id, dmon_action action,
                    const char *rootdir, const char *filepath,
                    const char *oldfilepath, void *user) {
  if (strstr(filepath, ".lua") != NULL && (action & (DMON_ACTION_MODIFY | DMON_ACTION_CREATE)) != 0) {
    printf("Change detected, reloading file.\n");
    reload_script();
  }
}

__attribute__((constructor)) static void init() {
  L = luaL_newstate();
  luaopen_string(L);
  luaL_openlibs(L);

  register_globals(L);
  lua_atpanic(L, on_error);

  dmon_init();
  dmon_watch("./", on_file_change, DMON_WATCHFLAGS_RECURSIVE, NULL);

  reload_script();
}

void scene_idle() {
  scene_draw();
}

void scene_draw() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  if (!errored) {
    lua_getglobal(L, "draw");
    if (lua_pcall(L, 0, 0, 0)) {
      on_error(L);
    }
  }

  glutSwapBuffers();
}

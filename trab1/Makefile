# Makefile for compiling lesson1.c with OpenGL

CC = gcc
CFLAGS = -Wall -g
LDFLAGS = -lGL -lGLU -lglut -llua

TARGET = lesson1
SRC = lesson1.c

lesson1: lesson1.o scene.o scripting.o

scene.o: scripting.h

lesson1.o: scene.h

run: lesson1
	./lesson1

clean:
	rm -f $(TARGET) *.o

.PHONY: clean run

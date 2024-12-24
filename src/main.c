#include <stdio.h>
#include <raylib.h>

int main(int argc, char **argv)
{
	InitWindow(800, 600, "Pong");
	SetTargetFPS(60);

	while (!WindowShouldClose()) {
		ClearBackground(BLACK);

		EndDrawing();
	}

	CloseWindow();

	return 0;
}


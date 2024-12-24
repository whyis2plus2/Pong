#include <stdio.h>
#include <raylib.h>

#define PADDLE_SPEED 3

typedef struct { int x, y; } IntVector2;

int main(int argc, char **argv)
{
	InitWindow(800, 600, "Pong");
	SetTargetFPS(60);

	Rectangle p1 = { 15, 50, 10, 50 };
	Rectangle p2 = { 775, 545, 10, 50 };
	Rectangle ball = { 400, 300, 10, 10 };

	IntVector2 ballVel = { -5, -2 };

	while (!WindowShouldClose()) {

		ball.x += ballVel.x;
		ball.y += ballVel.y;

		if (IsKeyDown(KEY_UP)) {
			p1.y -= PADDLE_SPEED;
		}

		if (IsKeyDown(KEY_DOWN)) {
			p1.y += PADDLE_SPEED;
		}

		p2.y = ball.y;

		if (p2.y >= GetScreenHeight() - p2.height) p2.y = GetScreenHeight() - p2.height;
		if (p1.y >= GetScreenHeight() - p2.height) p1.y = GetScreenHeight() - p2.height;
		if (p1.y <= 0) p1.y = 0;

		if (CheckCollisionRecs(p1, ball) || CheckCollisionRecs(p2, ball)) ballVel.x = -ballVel.x;
		if (ball.y <= 0 || ball.y >= 590) ballVel.y = -ballVel.y;

		if (ball.x <= -10 || ball.x >= 800) ball.x = 400;

		ClearBackground(BLACK);
		
		DrawRectangleRec(p1, WHITE);
		DrawRectangleRec(p2, WHITE);
		DrawRectangleRec(ball, WHITE);

		EndDrawing();
	}

	CloseWindow();

	return 0;
}


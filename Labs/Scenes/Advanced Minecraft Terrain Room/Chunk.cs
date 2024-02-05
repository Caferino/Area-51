using Godot;
using System;
[Tool]

public partial class Chunk : StaticBody3D
{
	[Export]
	public CollisionShape3D CollisionShape { get; set; }
	[Export]
}

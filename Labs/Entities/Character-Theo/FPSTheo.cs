using Godot;
using System;
using System.Numerics;

public partial class FPSTheo : CharacterBody3D
{
	[Export] public Node3D Head { get; set; }
	[Export] public Camera3D Camera { get; set; }
	[Export] public RayCast3D RayCast { get; set; }
	[Export] public MeshInstance3D BlockHighlight { get; set; }
	
	[Export] private float _mouseSensitivity = 0.3f;
	[Export] private float _movementSpeed = 8f;
	[Export] private float _jumpVelocity = 6f;
	
	private float _cameraXRotation;
	
	private float _gravity = ProjectSettings.GetSetting("physics/3d/default_gravity").AsSingle();
	
	public static FPSTheo Instance { get; private set; }
	
	public override void _Ready() {
		Instance = this;
		
		Input.MouseMode = Input.MouseModeEnum.Captured;
	}

	public override void _Input(InputEvent @event) {
		if (@event is InputEventMouseMotion) {
			var mouseMotion = @event as InputEventMouseMotion;
			var deltaX = mouseMotion.Relative.Y * _mouseSensitivity;
			var deltaY = -mouseMotion.Relative.X * _mouseSensitivity;

			Head.RotateY(Mathf.DegToRad(deltaY));
			if (_cameraXRotation + deltaX > -90 && _cameraXRotation + deltaX < 90) {
				Camera.RotateX(Mathf.DegToRad(-deltaX));
				_cameraXRotation += deltaX;
			}
		}
	}


	public override void _Process(double delta) {
		BlockHighlight.Visible = RayCast.IsColliding();

		if (RayCast.IsColliding() && RayCast.GetCollider() is Chunk chunk) {
			BlockHighlight.Visible = true;

			var blockPosition = RayCast.GetCollisionPoint() - 0.5f * RayCast.GetCollisionNormal();
			var intBlockPosition = new Godot.Vector3(Mathf.FloorToInt(blockPosition.X), Mathf.FloorToInt(blockPosition.Y), Mathf.FloorToInt(blockPosition.Z));
			BlockHighlight.GlobalPosition = intBlockPosition + new Godot.Vector3(0.5f, 0.5f, 0.5f);

			if (Input.IsActionJustPressed("action_break")) {
				chunk.SetBlock((Godot.Vector3I)(intBlockPosition - chunk.GlobalPosition), BlockManager.Instance.Air);
			}

			if (Input.IsActionJustPressed("action_place")) {
				ChunkManager.Instance.SetBlock((Godot.Vector3I)(intBlockPosition + RayCast.GetCollisionNormal()), BlockManager.Instance.Stone);
			}
		}
		else {
			BlockHighlight.Visible = false;
		}
	}


	public override void _PhysicsProcess(double delta) {
		var velocity = Velocity;

		if (!IsOnFloor()) {
			velocity.Y -= _gravity * (float)delta;
		}

		if (Input.IsActionJustPressed("jump") && IsOnFloor()) {
			velocity.Y = _jumpVelocity;
		}

		var inputDirection = Input.GetVector("move_left", "move_right", "move_back", "move_forward").Normalized();

		var direction = Godot.Vector3.Zero;

		direction += inputDirection.X * Head.GlobalBasis.X;

		direction += inputDirection.Y * -Head.GlobalBasis.Z;

		velocity.X = direction.X * _movementSpeed;
		velocity.Z = direction.Z * _movementSpeed;

		Velocity = velocity;
		MoveAndSlide();
	}
}

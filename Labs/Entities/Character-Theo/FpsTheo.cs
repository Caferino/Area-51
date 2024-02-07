using Godot;
using System;

public partial class FpsTheo : CharacterBody3D
{
	[Export] public Node3D Head { get; set; }
	[Export] public Camera3D Camera { get; set; }
	[Export] public RayCast3D RayCast { get; set; }
	[Export] public MeshInstance3D BlockHighlight { get; set; }
	
	[Export] private float _mouseSensitivity = 0.3f;
	[Export] private float _movementSpeed = 16f;
	[Export] private float _jumpVelocity = 10f;
	
	private float _cameraXRotation;
	
	private float _gravity = ProjectSettings.GetSetting("physics/3d/default_gravity").AsSingle();
	
	public static Player Instance { get; private set; }
	
	public override void _Ready() {
		Instance = this;
		
		Input.MouseMode = Input.MouseModeEnum.Captured;
	}

    public override void _Input(InputEvent @event)
    {
        if (@event is InputEventMouseMotion) {
			var mouseMotion = @event as InputEventMouseMotion;
			var deltaX = mouseMotion.Relative.Y * _mouseSensitivity;
			var deltaY = mouseMotion.Relative.X * _mouseSensitivity;

			Head.RotateY(Mathf.DegToRad(deltaY));
			if (_cameraXRotation + deltaX > -90 && _cameraXRotation + deltaX < 90) {
				Camera.RotateX(Mathf.DegToRad(-deltaX));
				_cameraXRotation += deltaX;
			}
		}
    }
}

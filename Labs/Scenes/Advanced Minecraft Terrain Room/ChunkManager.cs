using Godot;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Linq;

[Tool]
public partial class ChunkManager : Node
{
	public static ChunkManager Instance { get; private set; }
	
	private Dictionary<Chunk, Vector2I> _chunkToPosition = new();
	private Dictionary<Vector2I, Chunk> _positionToChunk = new();
	
	private List<Chunk> _chunks;
	
	[Export] public PackedScene ChunkScene { get; set; }
	
	private int _width = 5;
	
	private Vector3 _playerPosition;
	private object _playerPositionLock = new();
	
	private CharacterBody3D Theo;
	
	public override void _Ready() {
		Instance = this;
		
		Theo = GetNode<CharacterBody3D>(new NodePath("/root/Level/Theo"));
		
		_chunks = GetParent().GetChildren().Where(child => child is Chunk).Select(child => child as Chunk).ToList();
		
		var totalWidth = _width * _width;
		for (int i = _chunks.Count; i < totalWidth; ++i) {
			var chunk = ChunkScene.Instantiate<Chunk>();
			GetParent().CallDeferred(Node.MethodName.AddChild, chunk);
			_chunks.Add(chunk);
		}
		
		for (int x = 0; x < _width; ++x) {
			for (int y = 0; y < _width; ++y) {
				var index = (y * _width) + x;
				var halfWidth = Mathf.FloorToInt(_width / 2f);
				_chunks[index].SetChunkPosition(new Vector2I(x - halfWidth, y - halfWidth));
			}
		}
		
		if (!Engine.IsEditorHint()) {
			new Thread(new ThreadStart(ThreadProcess)).Start();
		}
	}
	
	
	public void UpdateChunkPosition(Chunk chunk, Vector2I currentPosition, Vector2I previousPosition) {
		if (_positionToChunk.TryGetValue(previousPosition, out var chunkAtPosition) && chunkAtPosition == chunk) {
			_positionToChunk.Remove(previousPosition);
		}
		
		_chunkToPosition[chunk] = currentPosition;
		_positionToChunk[currentPosition] = chunk;
	}
	
	
	public void SetBlock(Vector3I globalPosition, Block block) {
		var chunkTilePosition = new Vector2I(Mathf.FloorToInt(globalPosition.X / (float)Chunk.dimensions.X), Mathf.FloorToInt(globalPosition.Z / (float)Chunk.dimensions.Z));
		lock (_positionToChunk) {
			if (_positionToChunk.TryGetValue(chunkTilePosition, out var chunk)) {
				chunk.SetBlock((Vector3I)(globalPosition - chunk.GlobalPosition), block);
			}
		}
	}
	
	
	public override void _PhysicsProcess(double delta) {
		if (!Engine.IsEditorHint()) {
			lock (_playerPositionLock) {
				_playerPosition = Theo.GlobalPosition;
				// _playerPosition = FPSTheo.Instance.GlobalPosition; // For FpsTheo.cs
			}
		}
	}
	
	
	private void ThreadProcess() {
		while (IsInstanceValid(this)) {
			int playerChunkX, playerChunkZ;
			lock (_playerPositionLock) {
				playerChunkX = Mathf.FloorToInt(_playerPosition.X / Chunk.dimensions.X);
				playerChunkZ = Mathf.FloorToInt(_playerPosition.Z / Chunk.dimensions.Z);
			}
			
			foreach (var chunk in _chunks) {
				var chunkPosition = _chunkToPosition[chunk];
				
				var chunkX = chunkPosition.X;
				var chunkZ = chunkPosition.Y;
				
				var newChunkX = (int)(Mathf.PosMod(chunkX - playerChunkX + _width / 2, _width) + playerChunkX - _width / 2);
				var newChunkZ = (int)(Mathf.PosMod(chunkZ - playerChunkZ + _width / 2, _width) + playerChunkZ - _width / 2);
				
				if (newChunkX != chunkX || newChunkZ != chunkZ) {
					lock (_positionToChunk) {
						if (_positionToChunk.ContainsKey(chunkPosition)) {
							_positionToChunk.Remove(chunkPosition);
						}
						
						var newPosition = new Vector2I(newChunkX, newChunkZ);
						
						_chunkToPosition[chunk] = newPosition;
						_positionToChunk[newPosition] = chunk;
						
						chunk.CallDeferred(nameof(Chunk.SetChunkPosition), newPosition);
					}
					
					Thread.Sleep(100);
				}
			}
			
			Thread.Sleep(100);
		}
	}
}
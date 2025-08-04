# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Godot 4.4 game project called "Rimworldlike" - a colony simulation game inspired by RimWorld. The project uses GDScript and focuses on procedural terrain generation and pathfinding systems.

## Development Commands

This project uses Godot Engine 4.4. Development is done through the Godot editor:

- **Open Project**: Launch Godot editor and open `project.godot`
- **Run Game**: Press F5 in Godot editor or use the play button
- **Export/Build**: Use Project → Export in Godot editor

No package.json scripts are currently configured (empty packages object).

## Architecture

### Core Systems

**Terrain Generation (`scripts/terrain.gd`)**
- Extends `TileMapLayer` for procedural world generation
- Uses `FastNoiseLite` with cellular noise for terrain variety
- Configurable thresholds for different terrain types (grass, dirt, rock)
- Real-time generation toggle via `generateTerrain` export variable
- Map dimensions: 128x128 tiles by default

**Pathfinding (`scripts/pathfinding.gd`)**
- Uses Godot's `AStarGrid2D` for pathfinding calculations
- Now extends `Node2D` with `@tool` annotation for editor functionality
- Integrates with terrain system via movement difficulty custom data
- Visual path rendering with purple line drawing via `_draw()` function
- Export variables for start/end points and path calculation trigger
- Terrain difficulty values: grass (1.0), grass2 (1.2), dirt (1.5), rock (3.0), obstacles (8.0)
- Grid cell size: 16x16 pixels
- Automatic pathfinding initialization on `_ready()`

### Scene Structure

**Main Scene (`main_map.tscn`)**
- Root Node2D containing TerrainLayer and Pathfinding nodes
- TerrainLayer has configured tileset with movement difficulty custom data
- Pathfinding node extends Node2D for visual path rendering
- Camera2D with zoomed out view (0.385x) positioned at (992, 846)
- Default terrain generation enabled with seed 21502

### Assets

**Tileset (`assets/art/terrain_tileset.png`)**
- 2x3 tile atlas with different terrain types
- Each tile has custom movement difficulty data for pathfinding

## Key Configuration

- **Map Size**: 128x128 tiles (configurable in TerrainLayer)
- **Terrain Seed**: 21502 (can be modified for different world generation)
- **Noise Thresholds**: Grass (-0.45), Grass2 (-0.5), Dirt (-0.55), Rock (-0.6)
- **Cell Size**: 16x16 pixels for pathfinding grid

## Development Notes

- Both terrain and pathfinding scripts use `@tool` annotation for editor functionality
- Terrain generation happens in `_process()` when `generateTerrain` flag is true and automatically on `_ready()`
- Pathfinding system initializes on `_ready()` and reinitializes on each `find_path()` call
- Path visualization draws purple lines between waypoints using `_draw()` and `queue_redraw()`
- Export variables allow real-time testing: `calculate_path`, `start`, `end` coordinates
- All scripts use Godot 4.4 syntax with typed GDScript
- The project uses Forward Plus rendering
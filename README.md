# Godot Simple Games

![godot-version](https://img.shields.io/badge/Godot-4.2.1-blue)

Simple game projects powered by the Godot Engine.  

https://godotengine.org/  
https://docs.godotengine.org/en/stable/  


## Godot: Useful Shortcuts

### Quick Open
To use Quick Open, perform the following keyboard shortcut on Godot editor. 
Be careful, it does not work on script editor so you need to switch to 2D or 
3D Workspace if you use it.

Windows: **Shift + Alt + O**  
macOS: **Shift + Option + O** -or- **Command + P**  

https://www.peanuts-code.com/en/tutorials/gd0009_various_searches/#quick-open  

### Visible Collision Shapes
You can turn on Visible Collision Shapes by checking / enabling:  
- [x] Debug > Visible Collision Shapes


## Asset Links
https://opengameart.org/content/parallax-2d-backgrounds  
https://craftpix.net/freebies/free-cartoon-parallax-2d-backgrounds/?utm_campaign=Website&utm_source=opengameart.org&utm_medium=public  
https://opengameart.org/content/512-sound-effects-8-bit-style  
https://www.kenney.nl/  
https://www.glitchthegame.com/public-domain-game-art/  
https://ansimuz.itch.io/sunny-land-pixel-game-art  
https://pixelfrog-assets.itch.io/pixel-adventure-1  

## Mac Retina Display: Everything is tiny!
1. Open Godot Settings.
2. Check **Advanced Settings** (top-right corner).
3. Go to **Display > Window**.
4. Un-check **DPI > Allow hiDPI**.


# Godot Infrastructure

## Coroutines (and yield)

The `yield` keyword is only for Godot 3.0+. Coroutines are implemented in 
Godot 4.0+ with the `await` keyword.

The await immediately returns a value that may be ignored such that the calling 
function code or the game loop continues to run. But, if you call a function 
containing an `await`, then it becomes a coroutine that can be used with `await` 
in the calling function so that code execution is paused in that calling 
function. Here is an example:

```python
func _ready():
    print("Started")
    try_await()
    print("Done")

func try_await():
    await get_tree().create_timer(1.0).timeout
    print("After timeout")
```

https://gdscript.com/solutions/coroutines-and-yield/

# Tappy Plane
Initial project setup: Open Project > Project Settings.  
Go to Display > Window. Set Viewport Width to 480, and Height to 854.  
Change Handheld > Orientation to **Portrait**.

| Tappy 1 | Tappy 2 |
| :---: | :---: |
![Tappy 1](Screenshot/tappy-01.png) | ![Tappy 1](Screenshot/tappy-02.png)

# Angry Animals
A clone of the popular "Angry Birds". Under **Project Settings**, 
Go to Display > Window. Set Viewport Width to 1024, and Height to 600. 
Set **Stretch > Mode** to `canvas_items`.

| Angry Animals 1 |
| :---: |
| ![Angry 1](Screenshot/angry-01.png) |

| Angry Animals 2 |
| :---: |
| ![Angry 2](Screenshot/angry-02.png) |

# Memory Madness
A tile-flipping memory game where you need to match tiles with the 
same image. Features image randomization and asynchronous data loading 
using Godot Coroutines. Under **Project Settings**, 
Go to Display > Window. Set Viewport Width to 1024, and Height to 768. 
Set **Stretch > Mode** to `canvas_items`.

| Memory Madness 1 |
| :---: |
| ![Memory Madness 1](Screenshot/memory-01.png) |

| Memory Madness 2 |
| :---: |
| ![Memory Madness 2](Screenshot/memory-02.png) |

# Foxy Antics
A 2D platformer where the player controls a Fox that can shoot projectiles
to destroy wild enemies: Snails, Frogs and Eagles. Features a Boss Ent that
uses an `AnimationNodeStateMachine` to manage transitions to multiple
animations that Scale, Re-Position, and Modulate the Visibility of the boss.

| Boss Animation Node State Machine |
| :---: |
| ![Foxy Antics 1](Screenshot/foxy-01.png) |

| Working with Tile Sets and Collisions |
| :---: |
| ![Foxy Antics 2](Screenshot/foxy-02.png) |

| Balls Spikes Hazard moving along a Path2D |
| :---: |
| ![Foxy Antics 3](Screenshot/foxy-03.png) |

| Main Menu with Language Selection |
| :---: |
| ![Foxy Antics 4](Screenshot/foxy-04.png) |

| Game Level with Enemy Debug Labels |
| :---: |
| ![Foxy Antics 5](Screenshot/foxy-05.png) |

# Godot GDScript Style Guide
https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html  

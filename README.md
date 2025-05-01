
# 🐍 Snake Game (x86 Assembly)

A classic **Snake Game** written entirely in **x86 Assembly (8086)** for MS-DOS using BIOS interrupts and direct memory access. This low-level implementation demonstrates real-time input handling, screen drawing via text-mode video memory, random food generation, and basic game logic like self-collision and boundary detection.

---

## 🧠 Project Highlights

- Fully functional game loop using real-mode Assembly.
- Real-time keyboard input handling (`W`, `A`, `S`, `D`, `P`, `E`) via BIOS interrupt `INT 0x16`.
- Video output directly to text mode memory (`0xB800`).
- Displays a game banner and collects user name input.
- Game over screen with score display.
- Custom delay loop and pseudo-random number generation using `RDTSC`.
- Snake growth on food consumption, including visual body/head rendering.

---

## 🎮 Game Controls

| Key | Action         |
|-----|----------------|
| W   | Move Up        |
| A   | Move Left      |
| S   | Move Down      |
| D   | Move Right     |
| P   | Pause Game     |
| E   | Exit Game      |

---

## 🛠️ Technologies Used

| Component      | Technology                         |
|----------------|-------------------------------------|
| Language       | x86 Assembly (8086 - 16-bit)        |
| Platform       | MS-DOS (Real Mode)                 |
| Assembler      | NASM                               |
| Video Output   | Direct video memory (`0xB800`)     |
| Input          | BIOS Keyboard Interrupt (`INT 0x16`) |
| Output         | BIOS and direct memory              |

---

## 📦 Requirements

To compile and run this Snake Game, you’ll need:

- [NASM](https://www.nasm.us/) (Netwide Assembler)
- [DOSBox](https://www.dosbox.com/) (or any real-mode x86 emulator)
- 16-bit real-mode capable environment (e.g., DOSBox or FreeDOS)

---

## ⚙️ Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/CodeRafay/SnakeGame_x86_NASM.git
cd SnakeGame_x86_NASM
```

### 2. Assemble the Code

```bash
nasm -f bin Snake_Game.asm -o Snake_Game.com
```

### 3. Run in DOSBox

```bash
dosbox Snake_Game.com
```

Or you can copy the `.com` file to a DOS environment and run it there.

---

## 🖥️ Game Preview

```
||--- GAME  CONTROLS ---||
W -> UP
A -> Left
S -> Down
D -> Right

GAME INSTRUCTIONS
I. Game will over if snake collides with the boundary
II. Game will over if snake collides with itself
```

🎯 The game then starts with a dynamically growing snake and randomly placed food. Your goal is to survive and increase your score as long as possible.

---


## 📄 License

This project is licensed under the **Apache License 2.0**, with additional restrictions:

- **You may use, modify, and distribute this project for educational and personal use.**
- **Commercial use, resale, or distribution of this game (in full or part) for profit or branding under your own name is strictly prohibited without prior written permission from the original creator.**
- This project is **patent-protected**. Unauthorized commercial exploitation may result in legal consequences.

© CodeRafay – All Rights Reserved.


---

## 📝 Notes

- The game uses a manual delay loop for timing, which may behave differently depending on the system/emulator.
- Input and display are handled at the hardware level, so modern OSes won’t run the `.com` file natively. Always use DOSBox or a real DOS setup.
- Designed as an academic project to learn low-level system programming concepts like memory mapping, interrupts, and I/O handling.

---

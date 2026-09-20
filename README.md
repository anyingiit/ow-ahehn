<!-- Source: Best-README-Template BLANK_README (Unlicense) — https://github.com/othneildrew/Best-README-Template -->
<a id="readme-top"></a>

# Ow Ahehn

An OverPy source script for an Overwatch custom-game hit-list mode, meant to be compiled and pasted into a Workshop lobby, not built, tested, or run as ordinary software.

**English** · [简体中文](README.zh-CN.md)

[![License](https://img.shields.io/github/license/anyingiit/ow-ahehn)](LICENSE)

[Report a bug](https://github.com/anyingiit/ow-ahehn/issues/new?template=bug_report.yml) · [Request a feature](https://github.com/anyingiit/ow-ahehn/issues/new?template=feature_request.yml)

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

## About The Project

Ow-ahehn holds two OverPy source files for an Overwatch Workshop custom game: [`main.opy`](main.opy) defines a hit-list mode (its rule names, comments, and in-game messages are all written in Chinese; the mode's own name translates to "assassination") with three configurable variants — free-for-all, a hero whitelist, and a hero blacklist — that tracks how each player died, grants a marked player a "power" charge when they are killed by another marked player (not by surviving one), and lets that player later spend the charge, by holding three buttons at once, to kill everyone currently on the list, including themselves, while the in-game HUD shows the active list, remaining charges, and hotkeys; [`test.opy`](test.opy) is a separate, minimal script that only exercises the Workshop's `switch` statement and plays no part in the mode. OverPy is a Python-like language that compiles to Overwatch's own Workshop rule format, and the compiled result only runs inside an Overwatch custom-game lobby, not as a standalone program.

See the [open issues](https://github.com/anyingiit/ow-ahehn/issues) for anything planned.

## Getting Started

### Prerequisites

- Overwatch on PC, with access to create or edit a custom game and its Workshop settings — the only place the compiled rules run.
- An OverPy compiler to turn [`main.opy`](main.opy) or [`test.opy`](test.opy) into Workshop code; this repository does not include one, and its own commit history (`0f812d7`) names "overpy5.0" as the version the source was last migrated to.

### Installation

There is no package to install and no build step in this repository. Cloning it gets you a local copy of the two source files:

```sh
git clone https://github.com/anyingiit/ow-ahehn.git
cd ow-ahehn
```

To turn either file into something Overwatch can run, feed it to an OverPy compiler (not part of this repository) to produce Workshop code, then open Overwatch, create or edit a custom game, open its Workshop settings, and paste that code in.

## Usage

Neither `main.opy` nor `test.opy` runs on its own outside the game. Once `main.opy`'s compiled Workshop code sits in a custom game's settings and the lobby starts, the hit-list mode runs as written: `GameDefaultMode` picks free-for-all, whitelist, or blacklist play (at random by default, or a fixed choice), a player placed on the resulting list gains a "power" charge when killed by another player on the list, and spends one, by holding the interact, primary-fire, and secondary-fire buttons together, to kill everyone currently on the list, including themselves, and the HUD keeps every player informed of the active list, their remaining charges, and the hotkeys. `test.opy` is unrelated to that mode — it is a small script kept only to check how the Workshop's `switch` statement behaves.

## Contributing

Contributions are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) for how to open an issue or a pull request, and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for the standards expected of everyone taking part.

Please do not report security issues in public issues or pull requests. [SECURITY.md](SECURITY.md) explains how to report them privately.

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.

## Contact

Project link: [https://github.com/anyingiit/ow-ahehn](https://github.com/anyingiit/ow-ahehn)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

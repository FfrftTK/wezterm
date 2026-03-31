# WezTerm & Starship Config

WezTerm とStarship のターミナル設定ファイル。

## ファイル構成

- `wezterm.lua` — WezTerm のメイン設定
- `keybinds.lua` — キーバインド設定
- `starship.toml` — Starship プロンプトの設定

## セットアップ

### 1. このリポジトリをクローン

```sh
git clone <repo-url> ~/.config/wezterm
```

### 2. Starship の設定を zshrc に追加

`~/.zshrc` に以下を追記する。

```sh
export STARSHIP_CONFIG=~/.config/wezterm/starship.toml
eval "$(starship init zsh)"
```

追記後、設定を反映する。

```sh
source ~/.zshrc
```

# dotfiles

以 GNU Stow 管理設定。每個套件目錄都以使用者家目錄為相對根目錄。

| 套件 | 設定位置 |
| --- | --- |
| `fish` | `~/.config/fish/config.fish` |
| `ghostty` | `~/.config/ghostty/config.ghostty` |
| `starship` | `~/.config/starship.toml` |
| `nvim` | `~/.config/nvim/` |

## Neovim／LazyVim

在 macOS 的 Ghostty／fish 安裝工具：

```fish
brew install neovim ripgrep fd tree-sitter-cli stow
# 選配：Git 操作介面
brew install lazygit
```

另需 Git、C 編譯器與 Nerd Font。語言支援沿用 shell 中的 Node.js／npm、Python 與 JDK；目前 JDT LS 至少需要 Java 21。

若本 repo 位於 `~/dotfiles`，先預覽再建立連結：

```fish
stow --dir="$HOME/dotfiles" --target="$HOME" --simulate --verbose nvim
stow --dir="$HOME/dotfiles" --target="$HOME" --verbose nvim
nvim
```

若已有 `~/.config/nvim`，先確認它是否已連到本 repo；其他既有設定應先備份再執行 Stow。不要用 `--adopt` 直接覆蓋 repo 的設定。

`~/.config/nvim` 採用整個目錄的連結，使新產生的 `lazy-lock.json` 和 `lazyvim.json` 也儲存在 repo。首次啟動需要網路下載外掛，之後執行 `:LazyHealth` 與 `:Mason` 檢查。

已在 `nvim/.config/nvim/lazyvim.json` 啟用 Python、Java、JavaScript／TypeScript；透過 `:LazyExtras` 調整，再重啟 Neovim。Prettier 與 ESLint 可依專案需求另行啟用。

| 檔案（相對於 `nvim/.config/nvim/`） | 用途 |
| --- | --- |
| `init.lua`、`lua/config/lazy.lua` | 啟動 LazyVim 與外掛管理器 |
| `lua/config/options.lua` | 編輯器選項 |
| `lua/config/keymaps.lua` | 自訂快捷鍵 |
| `lua/config/autocmds.lua` | 自動事件 |
| `lua/plugins/*.lua` | 自訂外掛 |
| `lazyvim.json` | Extras 與 LazyVim 設定版本資料 |
| `lazy-lock.json` | 首次安裝後產生，應納入 Git 的外掛版本記錄 |

保留 LazyVim 預設操作與外觀；自訂設定檔目前提供註解範例。

更新外掛使用 `:Lazy update`。在新電腦套用已提交的版本記錄時使用 `:Lazy restore`；它還原外掛版本，不涵蓋 Neovim、Mason 工具或專案依賴。確認正常後再將變更提交：

```fish
git -C ~/dotfiles status --short
git -C ~/dotfiles add README.md nvim
git -C ~/dotfiles diff --cached
git -C ~/dotfiles commit -m "Configure Neovim with LazyVim"
```

第一次啟動前尚無 `lazy-lock.json` 是正常的；不要建立空白 lockfile。外掛與 Mason 工具存於 Neovim 的資料目錄，快取也不需要搬入 dotfiles。

參考：[LazyVim](https://www.lazyvim.org/)、[Extras](https://www.lazyvim.org/extras)、[外掛版本記錄](https://lazy.folke.io/usage/lockfile)、[GNU Stow](https://www.gnu.org/software/stow/manual/stow.html)。

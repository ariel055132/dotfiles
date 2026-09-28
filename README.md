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
| `lua/config/autocmds.lua` | 載入自動事件 |
| `lua/config/java.lua` | Java 新檔的 package 與 class 骨架 |
| `lua/plugins/*.lua` | 自訂外掛 |
| `lazyvim.json` | Extras 與 LazyVim 設定版本資料 |
| `lazy-lock.json` | 首次安裝後產生，應納入 Git 的外掛版本記錄 |

主題固定為 TokyoNight Moon，其他操作沿用 LazyVim 預設。

Java 新檔會自動建立同名的 `public class`；位於 `src/main/java/` 或 `src/test/java/` 下時，會依子目錄推算 `package`。例如 `src/main/java/Heap/Q2469.java` 會產生 `package Heap;` 與 `public class Q2469`。其他目錄只建立 class，不推測 package。

已存在的空白 `.java` 檔可用 `:JavaNewClass` 補上骨架；已有文字的檔案會保留內容。`package-info.java`、`module-info.java` 不套用 class 範本。此簡易範本支援一般英文字母、數字、底線與 `$` 識別字；特殊來源目錄或 Unicode 名稱請自行建立宣告。產生後仍需手動儲存。

Imports 保留手動控制：選取 Java 類別補全時可加入 import；`Space c a` 選擇修正、`Space c o` 整理 imports。目前未設定存檔時自動整理。

更新外掛使用 `:Lazy update`。在新電腦套用已提交的版本記錄時使用 `:Lazy restore`；它還原外掛版本，不涵蓋 Neovim、Mason 工具或專案依賴。確認正常後再將變更提交：

```fish
git -C ~/dotfiles status --short
git -C ~/dotfiles add README.md nvim
git -C ~/dotfiles diff --cached
git -C ~/dotfiles commit -m "Configure Neovim with LazyVim"
```

第一次啟動前尚無 `lazy-lock.json` 是正常的；不要建立空白 lockfile。外掛與 Mason 工具存於 Neovim 的資料目錄，快取也不需要搬入 dotfiles。

參考：[LazyVim](https://www.lazyvim.org/)、[Extras](https://www.lazyvim.org/extras)、[外掛版本記錄](https://lazy.folke.io/usage/lockfile)、[GNU Stow](https://www.gnu.org/software/stow/manual/stow.html)。

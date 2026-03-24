# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## Repo / Backup Conventions

- 杨玲 / 玲玲 是同一身份。
- 这套身份相关的 GitHub 备份与拉取默认走 `yangling` 分支。
- 需要“备份记忆/拉取记忆/同步杨玲工作区”时，优先看 `yangling`，不要默认用 `main`。
- 默认备份/同步范围：就是仓库里当前已经作为这套备份一部分的那批文件；如果柳哥没额外说明，不自行扩容范围。
- 做人工筛选合并时：以 `yangling` 作为杨玲记忆与工作区变更来源，再决定哪些内容合入本地 `main`。
- 备份、同步、合并时优先只处理**有改动**的文件；没改动的不 push、不 merge，避免制造无意义提交。

Add whatever helps you do your job. This is your cheat sheet.

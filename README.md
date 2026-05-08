用符号链接的方式链接文件到游戏目录

Windows 下可以直接运行各游戏目录中的 `Link-Cfg.ps1`。脚本开始运行时会要求输入游戏安装根目录，然后自动把该目录中的 cfg 链接到该游戏的目标文件夹；如果目标位置已有文件，会先备份为 `.backup-时间戳`。

创建符号链接可能需要管理员权限，或在 Windows 中启用开发人员模式。

```powershell
powershell -ExecutionPolicy Bypass -File ".\Counter-Strike 2\Link-Cfg.ps1"
powershell -ExecutionPolicy Bypass -File ".\Deadlock\Link-Cfg.ps1"
powershell -ExecutionPolicy Bypass -File ".\Team Fortress 2\Link-Cfg.ps1"
powershell -ExecutionPolicy Bypass -File ".\Counter-Strike\Link-Cfg.ps1"
powershell -ExecutionPolicy Bypass -File ".\Counter-Strike Source\Link-Cfg.ps1"
powershell -ExecutionPolicy Bypass -File ".\Counter-Strike Global Offensive\Link-Cfg.ps1"
powershell -ExecutionPolicy Bypass -File ".\Day of Defeat Source\Link-Cfg.ps1"
```

CS2:
```
mklink "D:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg\mycs2.cfg" "D:\LUN-1\Dev\ValveMyCFG\Counter-Strike 2\mycs2.cfg"
```
```
mklink "D:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg\mydemo.cfg" "D:\LUN-1\Dev\ValveMyCFG\Counter-Strike 2\mydemo.cfg"
```
```
mklink "D:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg\f97cs2alist.cfg" "D:\LUN-1\Dev\ValveMyCFG\Counter-Strike 2\f97cs2alist.cfg"
```
```
mklink "D:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg\f97cs2basic.cfg" "D:\LUN-1\Dev\ValveMyCFG\Counter-Strike 2\f97cs2basic.cfg"
```

DL:
```
mklink "D:\Program Files (x86)\Steam\steamapps\common\Deadlock\game\core\cfg\mydl.cfg" "D:\LUN-1\Dev\ValveMyCFG\Deadlock\mydl.cfg"
```


TF2:
```
mklink "J:\SteamLibrary\steamapps\common\Team Fortress 2\tf\cfg\mytf2.cfg" "D:\LUN-1\Dev\ValveMyCFG\Team Fortress 2\mytf2.cfg"
```

CS1.6:
```
mklink "J:\SteamLibrary\steamapps\common\Half-Life\cstrike\mycs.cfg" "D:\LUN-1\Dev\ValveMyCFG\Counter-Strike\mycs.cfg"
```
```
mklink "J:\SteamLibrary\steamapps\common\Half-Life\cstrike\cross.cfg" "D:\LUN-1\Dev\ValveMyCFG\Counter-Strike\cross.cfg"
```

CSS:
```
mklink "J:\SteamLibrary\steamapps\common\Counter-Strike Source\cstrike\cfg\mycss.cfg" "D:\LUN-1\Dev\ValveMyCFG\Counter-Strike Source\mycss.cfg"
```

CSGO:
```
mklink "D:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg\mycsgo.cfg" "D:\LUN-1\Dev\ValveMyCFG\Counter-Strike Global Offensive\mycsgo.cfg"
```

DODS:
```
mklink "J:\SteamLibrary\steamapps\common\Day of Defeat Source\dod\cfg\mydods.cfg" "D:\LUN-1\Dev\ValveMyCFG\Day of Defeat Source\mydods.cfg"
```

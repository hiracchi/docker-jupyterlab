# Docker for jupyter notebook

## 使い方
- `jupyter_notebook_config.py` を `${WORKDIR}` (デフォルトはcontainer内の `/work` ) に置くとこれを読み込む。
  - オリジナルは `jupyter_notebook_config.py.orig`

- ブラウザで `http://localhost:8888/` を開く


## インストール済み拡張機能
- nglview (https://github.com/arose/nglview)

## 重要PATH
- c.LabApp.user_settings_dir = '/home/docker/.jupyter/lab/user-settings'
- c.LabApp.workspaces_dir = '/home/docker/.jupyter/lab/workspaces'

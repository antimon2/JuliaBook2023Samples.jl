# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.14.4
#   kernelspec:
#     display_name: Julia (4 threads) 1.8.5
#     language: julia
#     name: julia-_4-threads_-1.8
# ---

versioninfo()

# ## 1-4. Julia を JupyterLab で使用する

# ### 1-4-1. JupyterLab および IJulia のインストール

# #### IJulia を利用して JupyterLab をインストールする

# ##### 仮想コード1-9. IJulia からの JupyterLab インストール例（Windows での例）

# ```julia
# julia> # `]` をタイプしてパッケージモードに移行
#
# (@v1.7) pkg> add IJulia
# # : 《動作例略》
#
# julia> using IJulia
#
# julia> jupyterlab()  # `IJulia.jupyterlab()`
# install Jupyter via Conda, y/n? [y]:
# [ Info: Downloading miniconda installer ...
# [ Info: Installing miniconda ...
# [ Info: Running `conda install -y jupyterlab` in root environment
# Collecting package metadata (current_repodata.json): done
# Solving environment: done
#
# # :《中略》
# done
# [ Info: running setenv(`'C:\Users\username\.julia\conda\3\Scripts\jupyter.exe' lab`, # ...《以下略》
# ```

# #### JupyterLab を Python のパッケージマネージャからインストールする

# ##### 仮想コード1-10. JupyterLab のコマンドラインインストール方法（例）

# ```shell
# $ conda install -c conda-forge jupyterlab
#
# # または 
#
# $ pip install jupyterlab
# ```

# #### Julia カーネルを追加する

# ##### コード1-18. `IJulia.jl` パッケージの追加（＝Julia カーネルの追加）

# ```julia
# julia> # `]` をタイプしてパッケージモードに移行
#
# (@v1.7) pkg> add IJulia
#     Updating registry at `~/.julia/registries/General.toml`
#    Resolving package versions...
#    Installed Conda ─────────── v1.7.0
#    Installed VersionParsing ── v1.3.0
#    Installed Parsers ───────── v2.3.1
#    Installed ZMQ ───────────── v1.2.1
#    Installed Preferences ───── v1.3.0
#    Installed JSON ──────────── v0.21.3
#    Installed IJulia ────────── v1.23.3
#    Installed JLLWrappers ───── v1.4.1
#    Installed ZeroMQ_jll ────── v4.3.4+0
#    Installed SoftGlobalScope ─ v1.1.0
#    Installed libsodium_jll ─── v1.0.20+0
#    Installed MbedTLS ───────── v1.0.3
#   Downloaded artifact: ZeroMQ
#   Downloaded artifact: libsodium
#     Updating `~/.julia/environments/v1.7/Project.toml`
#   [7073ff75] + IJulia v1.23.3
#     Updating `~/.julia/environments/v1.7/Manifest.toml`
#   [8f4d0f93] + Conda v1.7.0
#   [7073ff75] + IJulia v1.23.3
#    # :《中略》
#   [3f19e933] + p7zip_jll
#     Building Conda ─→ `~/.julia/scratchspaces/44cfe95a-1eb2-52ea-b672-e2afdf69b78f/6e47d11ea2776bc5627421d59cdcc1296c058071/build.log`
#     Building IJulia → `~/.julia/scratchspaces/44cfe95a-1eb2-52ea-b672-e2afdf69b78f/98ab633acb0fe071b671f6c1785c46cd70bb86bd/build.log`
# Precompiling project...
#   11 dependencies successfully precompiled in 3 seconds (4 already precompiled)
# ```

# ##### コード1-19. Jupyterカーネル追加例（4スレッド対応）

# ```julia
# julia> ENV["JUPYTER_DATA_DIR"] = ENV["CONDA_PREFIX"] * "/share/jupyter"
#        # 環境変数 CONDA_PREFIX が未設定だとエラーが発生しますのでご注意！
# "/path/to/conda_prefix/share/jupyter"
#
# julia> using IJulia
#
# julia> IJulia.installkernel("Julia (4 threads)", "--project=@.", env=Dict("JULIA_NUM_THREADS"=>"4"))
# [ Info: Installing Julia (4 threads) kernelspec in /path/to/conda_prefix/share/jupyter/kernels/julia-(4-threads)-1.7
# "/path/to/conda_prefix/share/jupyter/kernels/julia-(4-threads)-1.7"
# ```

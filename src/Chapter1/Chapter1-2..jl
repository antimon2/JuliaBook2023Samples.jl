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

# ## 1-2. Julia のインストール

# ### 1-2-2. `juliaup` を利用したインストール

# #### `juliaup` のインストール（Linux、macOS 等）

# ##### 仮想コード1-5. シェル（Linux, bash）での `juliaup` インストール概要（ログ）

# ```bash
# username@HOST:~$ curl -fsSL https://install.julialang.org | sh
#
# info: downloading installer
# Welcome to Julia!
#
# This will download and install the official Julia Language distribution
# and its version manager Juliaup.
#
# Juliaup will be installed into the Juliaup home directory, located at:
#
#   /home/username/.juliaup
#
# The julia, juliaup and other commands will be added to
# Juliaup's bin directory, located at:
#
#   /home/username/.juliaup/bin
#
# This path will then be added to your PATH environment variable by
# modifying the profile files located at:
#
#   /home/username/.bashrc
#   /home/username/.profile
#
# Julia will look for a new version of Juliaup itself every 1440 seconds when you start julia.
#
# You can uninstall at any time with juliaup self uninstall and these
# changes will be reverted.
#
# ? Do you want to install with these default configuration choices? ›
# ❯ Proceed with installation
#   Customize installation
#   Cancel installation
# # 《↑矢印キー上下で選択、Enter で決定》
# ✔ Proceed with installation
#
# Now installing Juliaup
# Installing Julia 1.7.2+0 (x64).
# Julia was successfully installed on your system.
#
# Depending on which shell you are using, run one of the following
# commands to reload the the PATH environment variable:
#
#   . /home/username/.bashrc
#   . /home/username/.profile
#
# username@HOST:~$
#
# ```

# #### `juliaup` による Julia のインストール・更新（Windows/Linux/macOS 共通）

# ##### 仮想コード1-6. `juliaup st` コマンド実行例

# ```bash
# $ juliaup st
#  Default  Channel  Version      Update
# ---------------------------------------
#        *  release  1.7.2+0~x64
# ```

# ##### 仮想コード1-7. `juliaup add` コマンド実行例

# ```bash
# $ juliaup add lts
# Installing Julia 1.6.6+0 (x64).
# $ juliaup add beta
# Installing Julia 1.8.0-beta3+0 (x64).
# $ juliaup st
#  Default  Channel  Version            Update
# ---------------------------------------------
#           beta     1.8.0-beta3+0~x64
#           lts      1.6.6+0~x64
#        *  release  1.7.2+0~x64
#
# $ julia +lts
#                _
#    _       _ _(_)_     |  Documentation: https://docs.julialang.org
#   (_)     | (_) (_)    |
#    _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
#   | | | | | | |/ _` |  |
#   | | |_| | | | (_| |  |  Version 1.6.6 (2022-03-28)
#  _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
# |__/                   |
#
# julia> 
# ```

# ##### 仮想コード1-8. `juliaup up` コマンド実行例

# ```bash
# $ juliaup st
#  Default  Channel  Version            Update
# ----------------------------------------------------------------------------
#           beta     1.8.0-beta1+0~x64  Update to 1.8.0-beta3+0~x64 available
#           lts      1.6.5+0~x64        Update to 1.6.6+0~x64 available
#        *  release  1.7.2+0~x64        Update to 1.7.3+0~x64 available
#
# $ juliaup up
# Installing Julia 1.8.0-beta3+0 (x64).
# Installing Julia 1.6.6+0 (x64).
# Installing Julia 1.7.3+0 (x64).
# $ juliaup st
#  Default  Channel  Version            Update
# ---------------------------------------------
#           beta     1.8.0-beta3+0~x64
#           lts      1.6.6+0~x64
#        *  release  1.7.3+0~x64
# $ julia --version
# julia version 1.7.3
# $ julia +lts --version
# julia version 1.6.6
# $ julia +beta --version
# julia version 1.8.0-beta3
# ```

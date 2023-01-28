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
#     display_name: Julia 1.8.5
#     language: julia
#     name: julia-1.8
# ---

versioninfo()

# ## 2-2. 変数/定数

# ### コード2-24. 変数・定数の例

x = 1.0

x = 1

const xx = 1.0

xx = 1

# ### 仮想コード2-1. 変数（識別子）として有効な Unicode 文字の例（「仮想コード1-5.」再掲）

# ```julia
# θ
# Fₙ
# σ²
# μ
# x̄
# ```

# + `\theta` + <kbd>TAB</kbd> （⇒ `θ`）
# + `F\_n` + <kbd>TAB</kbd> （⇒ `Fₙ`）
# + `\sigma` + <kbd>TAB</kbd> + `\^2` + <kbd>TAB</kbd> （⇒ `σ²`）
# + `\mu` + <kbd>TAB</kbd> （⇒ `μ`）
# + `x\bar` + <kbd>TAB</kbd> （⇒ `x̄`）

# ### 表2-3. 代表的な定義済定数

# | 定数名 | 値 | 説明 |
# | :-- | :-- | :-- |
# | `Inf`, `Inf16`, `Inf32`, `Inf64` | （正の無限大） | 浮動小数点数の無限大 |
# | `NaN`, `NaN16`, `NaN32`, `NaN64` | （NaN） | 浮動小数点数の NaN |
# | `π`, `pi` | （3.1415926535897...） | 円周率 |
# | `ℯ` | （2.7182818284590...） | 自然対数の底（ネイピア数） |
# | `im` | （虚数単位） | 虚数単位 |
# | `nothing` | `Nothing()` | Nothing |
# | `missing` | `Missing()` | 欠損値 |

Inf, Inf16, Inf32, Inf64

NaN, NaN16, NaN32, NaN64

π  # === pi

ℯ

im

nothing

missing

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

# ## 1-3. Julia を REPL で使用する

# ### 1-3-1. Julia モード

# #### コード1-13. Julia の REPL（Julia モードの例）

1 + 1  # 演算（足し算）

sin(1.0)  # 関数呼び出し

if π > 3
    "π は 3 より大きい"
else
    error("ここには絶対来ないはず（来たら文字通りエラー）")
end  # `if` 文（`if` 式）

fib_simple(n) = n < 2 ? n : fib_simple(n - 1) + fib_simple(n - 2)  # 関数定義

using BenchmarkTools  # `using` 文（パッケージのインポート）

@btime fib_simple(40)  # マクロ呼び出し（`@btime` は `BenchmarkTools` で定義されているマクロ）

#= 複数行コメント。ここに記述した内容は…
sin(0.0)
のように一見有効な式を記述しても完全に無視されます。 =#

# ### 1-3-2. ヘルプモード

# #### コード1-14. Julia の REPL（ヘルプモードの例）

# ```julia
# julia> # `?` をタイプするとヘルプモードへ移行
#
# help?> sin
# search: sin sinh sind sinc sinpi sincos sincosd sincospi asin using isinf asinh asind isinteger isinvariant
#
#   sin(x)
#
#   Compute sine of x, where x is in radians.
#
#   See also [sind], [sinpi], [sincos], [cis].
#
#   # : 《以下略》
#
# help?> +
# search: +
#
#   +(x, y...)
#
#   Addition operator. x+y+z+... calls this function with all arguments, i.e. +(x, y, z, ...).
#
#   Examples
#   ≡≡≡≡≡≡≡≡≡≡
#
#   julia> 1 + 20 + 4
#   25
#
#   julia> +(1, 20, 4)
#   25
#
#   # : 《以下略》
#
# help?> π
# "π" can be typed by \pi<tab>
#
# search: π
#
#   π
#   pi
#
#   The constant pi.
#
#   Unicode π can be typed by writing \pi then pressing tab in the Julia REPL, and in many editors.
#
#   See also: sinpi, sincospi, deg2rad.
#
#   Examples
#   ≡≡≡≡≡≡≡≡≡≡
#
#   julia> pi
#   π = 3.1415926535897...
#
#   julia> 1/2pi
#   0.15915494309189535
# ```
#

#=
?sin

?+

?π
=#

# ### 1-3-3. シェルモード

# #### コード1-15. Julia の REPL（シェルモードの例、Linux/macOS の場合）

# ```julia
# julia> # `;` をタイプしてシェルモードへ移行
#
# shell> echo "Test"
# Test
#
# shell> echo "Is this me?" > isthisme.txt  # ファイル出力はされない！
# Is this me? > isthisme.txt # ファイル出力はされない！
#
# shell> bash -c "echo 'This is me.' > thisisme.txt"  # これならOK
#
# shell> ls thisisme.txt
# thisisme.txt
#
# shell> cat thisisme.txt
# This is me.
#
# shell> # `Backspace` または `Ctrl`+`C` で Julia モードに戻る
#
# julia> 
# ```

# #### コード1-16. Julia の REPL（シェルモードの例、Windows Powershell の場合）

# ```shell
# julia> # `;` をタイプしてシェルモードへ移行
#
# shell> echo NG! '#' この例が動かない
# ERROR: IOError: could not spawn `echo NG! '#' この例が動かない`: no such file or directory (ENOENT)
# # : 《以下略》
#
# shell> powershell -c "echo 'Test'"  # これならOK
# Test
#
# shell> powershell -c "echo 'This is me.' > thisisme.txt"  # リダイレクトもOK
#
# shell> powershell -c "ls thisisme.txt"
#
#
#     ディレクトリ: C:\Users\username
#
#
# Mode                 LastWriteTime         Length Name
# ----                 -------------         ------ ----
# -a----        2022/mm/dd     HH:MM             28 thisisme.txt
#
#
# shell> powershell -c "cat thisisme.txt"
# This is me.
#
# shell> # `Backspace` または `Ctrl`+`C` で Julia モードに戻る
#
# julia> 
# ```

# ### 1-3-4. パッケージモード

# #### コード1-17. Julia の REPL（パッケージモードの例、`BenchmarkTools` の追加例）

# ```julia
# julia> # `]` をタイプしてパッケージモードに移行
#
# (@v1.7) pkg> st
#       Status `~/.julia/environments/v1.7/Project.toml` (empty project)
#
# (@v1.7) pkg> add BenchmarkTools
#     Updating registry at `~/.julia/registries/General.toml`
#    Resolving package versions...
#     Updating `~/.julia/environments/v1.7/Project.toml`
#   [6e4b80f9] + BenchmarkTools v1.3.1
#     Updating `~/.julia/environments/v1.7/Manifest.toml`
#   [6e4b80f9] + BenchmarkTools v1.3.1
#   # : 《以下略》
#
# (@v1.7) pkg> up
#     Updating registry at `~/.julia/registries/General.toml`
#   No Changes to `~/.julia/environments/v1.7/Project.toml`
#   No Changes to `~/.julia/environments/v1.7/Manifest.toml`
#
# (@v1.7) pkg> st
#       Status `~/.julia/environments/v1.7/Project.toml`
#   [6e4b80f9] BenchmarkTools v1.3.1
#
# (@v1.7) pkg> # `Backspace` または `Ctrl`+`C` で Julia モードに戻る
#
# julia> 
# ```

#=
]st

]add BenchmarkTools

]up

]st
=#

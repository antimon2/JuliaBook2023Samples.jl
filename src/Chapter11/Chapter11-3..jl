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

# ## 11-3. DifferentialEquations.jl による常微分方程式の数値的解法

# ※ 本文とは環境等を少し変えています（コードはほぼ同一です）

#=
]activate DifferentialEquationsSample
=#

# ### コード11-9. `DifferentialEquations.jl` パッケージの追加

# ```julia
# (@v1.7) pkg> add DifferentialEquations
#     Updating registry at `~/.julia/registries/General`
#     Updating git-repo `https://github.com/JuliaRegistries/General`
#    Resolving package versions...
#    Installed Hwloc_jll ─────────── v2.7.1+0
#    Installed StrideArraysCore ──── v0.2.15
#    Installed DiffEqBase ────────── v6.82.2
#    Installed DualNumbers ───────── v0.6.8
#    ：《中略》
#     Updating `~/.julia/environments/v1.7/Project.toml`
#   [0c46a032] + DifferentialEquations v7.1.0
#     Updating `~/.julia/environments/v1.7/Manifest.toml`
#    ：《中略》
#   [2b5f629d] + DiffEqBase v6.82.2
#   [459566f4] + DiffEqCallbacks v2.22.0
#   [c894b116] + DiffEqJump v8.3.0
#   [77a26b50] + DiffEqNoiseProcess v5.9.0
#   [163ba53b] + DiffResults v1.0.3
#   [b552c78f] + DiffRules v1.10.0
#   [0c46a032] + DifferentialEquations v7.1.0
#    ：《以下略》
#
# (@v1.7) pkg> st DifferentialEquations
#       Status `~/.julia/environments/v1.7/Project.toml`
#   [0c46a032] DifferentialEquations v7.1.0
# ```

#=
]add DifferentialEquations@7.1.0
=#

#=
]add Plots@1.29.0
=#

#=
]st DifferentialEquations
=#

# $$
# \begin{cases}
# \begin{aligned}
# \frac{dx}{dt} &= ax - bxy & \mathrm{-\!\!-}\ (1) \\
# \frac{dy}{dt} &= cxy - dy & \mathrm{-\!\!-}\ (2)
# \end{aligned}
# \end{cases} \qquad (a,b,c,d>0)
# $$

# ### コード11-10. 微分方程式を表す関数の例（ロトカ・ヴォルテラの方程式）

function f!(du, u, params, t)
    x, y = u
    a, b, c, d = params
    du[1] = a*x - b*x*y  # -- (1)
    du[2] = c*x*y - d*y  # -- (2)
end

# ### コード11-11. 微分方程式の「初期値問題」の定義例

using DifferentialEquations

u0 = [3.0, 1.0];  # 初期値（$u(t_0)$ の値）

tspan = [0, 20];  # 時刻0（$t_0$）から20まで計算する

params = [1, 2, 3, 4];  # パラメータ（`a, b, c, d`）の値

prob = ODEProblem(f!, u0, tspan, params)  # 「常微分方程式の初期値問題」オブジェクトの生成

# ### コード11-12. 初期値問題の求解

solution = solve(prob)

# ### コード11-13. 結果の確認（グラフ描画による可視化）

#=
]st Plots
=#

using Plots  # 事前に `] add Plots` が必要

gr()  # GRバックエンドを利用

ts = solution.t;
xs = solution[1, :];  # Same as `xs = [u[1] for u in solution.u];`
ys = solution[2, :];  # Same as `ys = [u[2] for u in solution.u];`
a, b, c, d = params;
plt = plot(ts, [xs ys];
    line=([1 1.5], [:solid  :dash]),
    label=["prey \$x\$" "predator \$y\$"],
    title="Lotoka-Volterra \$a=$(a), b=$(b), c=$(c), d=$(d)\$",
    xlabel="\$t\$",
)

savefig(plt, "lotka_volterra_plot1.svg")  # 表示できなくても←これでファイルに保存できる

# ### コード11-14. 計算手法（アルゴリズム）・追加パラメータ指定の例

result = solve(prob, RK4(), dt=0.05, adaptive=false);

ts = result.t;
xs = result[1, :];
ys = result[2, :];
a, b, c, d = params;
plt = plot(ts, [xs ys];
    line=([1 1.5], [:solid  :dash]),
    label=["prey \$x\$" "predator \$y\$"],
    title="Lotoka-Volterra \$a=$(a), b=$(b), c=$(c), d=$(d)\$",
    xlabel="\$t\$",
)

savefig(plt, "lotka_volterra_plot2.svg")

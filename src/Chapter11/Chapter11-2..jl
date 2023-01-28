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

# ## 11-2. NLsolve.jl による非線形方程式の求解

# ※ 本文とは環境等を少し変えています（コードはほぼ同一です）

#=
]activate NLSolveSample
=#

# ### コード11-4. `NLsolve.jl` パッケージの追加

# ```julia
# julia> # `]` をタイプしてパッケージモードに移行
#
# (@v1.7) pkg> add NLsolve
#     Updating registry at `~/.julia/registries/General`
#     Updating git-repo `https://github.com/JuliaRegistries/General`
#    Resolving package versions...
#     Updating `~/.julia/environments/v1.7/Project.toml`
#   [2774e3e8] + NLsolve v4.5.1
#     Updating `~/.julia/environments/v1.7/Manifest.toml`
#   [4fba245c] + ArrayInterface v5.0.5
#   [d360d2e6] + ChainRulesCore v1.14.0
#    ：《以下略》
#
# (@v1.7) pkg> st NLsolve
#       Status `~/.julia/environments/v1.7/Project.toml`
#   [2774e3e8] NLsolve v4.5.1
#
# (@v1.7) pkg> st -m
#       Status `~/.julia/environments/v1.7/Manifest.toml`
#    ：《中略》
#   [6a86dc24] FiniteDiff v2.11.0
#   [f6369f11] ForwardDiff v0.10.25
#    ：《中略》
#   [d41bc354] NLSolversBase v7.8.2
#   [2774e3e8] NLsolve v4.5.1
#    ：《以下略》
# ```

#=
]add NLsolve@4.5.1
=#

#=
]st NLsolve
=#

#=
]st -m
=#

# $$
# \begin{cases}
# \begin{aligned}
# u(x, y) &= (x + 3)(y^3-7)+18 \\
# v(x, y) &= \sin(y \cdot \mathrm{e}^x-1)
# \end{aligned}
# \end{cases}
# $$

# ### コード11-5. `NLsolve.jl` の使用例(1) （README に記載のサンプル）

using NLsolve

function f!(F, xy)
    x, y = xy
    F[1] = (x+3)*(y^3-7)+18  # u
    F[2] = sin(y*exp(x)-1)  # v
end

function j!(J, xy)
    x, y = xy
    J[1, 1] = y^3-7  # ∂u/∂x
    J[1, 2] = 3y^2*(x+3)  # ∂u/∂y
    ∂v_∂y = exp(x)*cos(y*exp(x)-1)  # ∂v/∂y
    J[2, 1] = y*∂v_∂y  # ∂v/∂x
    J[2, 2] = ∂v_∂y
end

sol_uv = nlsolve(f!, j!, [0.1, 1.2])

# $$
# J = \begin{bmatrix}
# \begin{aligned}\frac{\partial u}{\partial x}\end{aligned} & \begin{aligned}\frac{\partial u}{\partial y}\end{aligned} \\
# \begin{aligned}\frac{\partial u}{\partial x}\end{aligned} & \begin{aligned}\frac{\partial u}{\partial y}\end{aligned} \\
# \end{bmatrix} = \left [\ \begin{array}{ll}
# y^3-7 & 3y^2 \ (x+3) \\
# y \ \mathrm{e}^x \cos(y \ \mathrm{e}^x-1) & \mathrm{e}^x \cos(y \ \mathrm{e}^x-1)
# \end{array} \right ]
# $$

# ### コード11-6. 求解結果の確認

sol_uv.f_converged

sol_uv.zero ≈ [0.0, 1.0]

res = similar(sol_uv.zero, 2); f!(res, sol_uv.zero);

# res ≈ [0.0, 0.0]  # ←NG!
≈(res, [0.0, 0.0]; atol=1e-8)

# ### コード11-7. `NLsolve.jl` の使用例(2) （自動微分を利用する場合）

# `j!` 指定しなくても求解可能（内部で自動微分が実施される）
nlsolve(f!, [0.1, 1.2])

# `ForwardDiff` 利用を指定
nlsolve(f!, [0.1, 1.2]; autodiff=:forward)

# ### コード11-8. `NLsolve.jl` の使用例(3) （解法を指定）

# 自動微分に `ForwardDiff` 利用を指定、解法に :newton を指定
nlsolve(f!, [0.1, 1.2]; autodiff=:forward, method=:newton)

# 解法に :broyden を指定（!j 不要）
nlsolve(f!, [0.1, 1.2]; method=:broyden)

# 解法に :anderson を指定（!j 不要）
nlsolve(f!, [0.1, 1.2]; method=:anderson)

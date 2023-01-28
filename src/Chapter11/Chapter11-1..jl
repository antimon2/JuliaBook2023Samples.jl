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

# ## 11-1. Juliaで数値計算

# $$
# \begin{cases}
# \begin{aligned}
# x + 2y &= 1 \\
# 3x + 5y &= 2
# \end{aligned}
# \end{cases}
# $$
#

# $$
# \begin{eqnarray}
# \begin{pmatrix}
# 1 & 2 \\ 3 & 5
# \end{pmatrix} \begin{pmatrix}
# x \\ y
# \end{pmatrix} &=& \begin{pmatrix}
# 1 \\ 2
# \end{pmatrix} \\
# \begin{pmatrix}
# x \\ y
# \end{pmatrix} &=& \begin{pmatrix}
# 1 & 2 \\ 3 & 5
# \end{pmatrix}^{-1}\begin{pmatrix}
# 1 \\ 2
# \end{pmatrix}
# \end{eqnarray}
# $$
#

# ### コード11-1. 数値線型代数の例（連立1次方程式の求解）

# +
A = [1. 2.
     3. 5.];

b = [1., 2.];
# -

# x, y = A^(-1) * b
# x, y = inv(A) * b
# ↑これらでも良いが↓こちらの方がさらに良い
x, y = A \ b

[x, y] ≈ [-1., 1.]  # 期待した結果とほぼ等しいかどうかを確認

A * [x, y] ≈ b  # 確認

# ### コード11-2. ニュートン法の実装例

# +
function newtonmethod(f, f′, init=1.0;
    tol=1e-16,
    ε=1e-14,
    maxiteration=1000,
    withconverged=false
)
    solution_found = false
    x1 = x0 = init
    for i in 1:maxiteration
        y = f(x0)
        y′ = f′(x0)
        abs(y′) < ε && break
        x1 = x0 - y / y′
        if abs(x1 - x0) ≤ tol
            solution_found = true
            break
        end
        x0 = x1
    end
    withconverged && return (x1, solution_found)
    x1
end

newtonmethod(f, init::Number=1.0; h=1e-6, kwargs...) = newtonmethod(
    f,
    x -> (f(x+h) - f(x-h)) / 2h,  # 数値微分
    init;
    kwargs...)
# -

# ### コード11-3. ニュートン法による `f(x) = x^2 - 2` の求解（＝$\sqrt{2}$ の数値計算）例

f(x) = x^2 - 2

newtonmethod(f)

newtonmethod(f) ≈ √2

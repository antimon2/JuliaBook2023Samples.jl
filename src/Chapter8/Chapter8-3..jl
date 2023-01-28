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

# ## 8-3. Expr型とシンボル

# ### 8-3-1. AST

# ### 8-3-2. Expr型

# #### コード8-1. `:(～)` の例(1)

1 + 2

a + b

:(1 + 2)

:(a + b)

:(x^2+2x-1)

# #### コード8-2. `:(～)` の例(2)：`:(a + b)` の調査

ex1 = :(a + b)

typeof(ex1)

dump(ex1)

ex1.head

ex1.args

# #### コード8-3. `:(～)` の例(3)：`:(a * b + c / d)` の調査

ex2 = :(a * b + c / d)

dump(ex2)

# #### コード8-4. 複数行の式からなる `Expr`（`quote ～ end`）の例

:(
    a = 1
    b = 2
    println(a + b)
)

quote
    a = 1
    b = 2
    println(a + b)
end

:(begin
    a = 1
    b = 2
    println(a + b)
end)  # 上記と全く同等

# +
ex4 = quote
    a = 1
    b = 2
    println(a + b)
end;

Base.remove_linenums!(ex4)  # LinenumberNode を除去
# -

typeof(ex4)

ex4.head

ex4.args

# #### コード8-5. `Expr` コンストラクタ例

Expr(:if, :(a > b), :(println(a)), :(println(b)))

Base.remove_linenums!(:(if a > b println(a) else println(b) end))  # 参考

# ### 8-3-3. シンボル

# #### コード8-6. `:(～)` の例(4)：単一の値や識別子を渡した場合の挙動

:(1)

typeof(:(1))

:("123ABCあいう漢字😁")

typeof(:("123ABCあいう漢字😁"))

:(a)

typeof(:(a))

# ### 8-3-4. `QuoteNode`

# #### コード8-7. QuoteNode の例(1)

:(:a)

typeof(:(:a))

dump(:(:a))

# #### コード8-8. QuoteNode の例(2)

dump(:(d[:key]))  # 辞書（`Dict`）のキーとしてシンボルを指定した例

dump(:(a.b))  # プロパティ参照（`b`は識別子ではなくシンボルとして扱われる）

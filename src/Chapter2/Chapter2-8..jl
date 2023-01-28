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

# ## 2-8. モジュール

# ### 2-8-1. `import` と `using`

# #### コード2-117. モジュールの例(1)：`Iterators` 標準モジュールの使用例

Iterators.take(1:100, 10)

collect(Iterators.take(1:100, 10))

# #### コード2-118. モジュールの例(2)：`Iterators.take()` のインポート

import .Iterators: take  # または `using .Iterators: take`

collect(take(1:100, 10))

# #### コード2-119. モジュールの例(3)：`using` の使用例（`Statistics` 標準パッケージのインポート）

using Statistics

mean([3, 1, 4, 1, 6])

std([3, 1, 4, 1, 6])

var([3, 1, 4, 1, 6])

# ### 2-8-2. 標準モジュールとモジュールのネスト

# #### コード2-120. モジュールの例(4)：`@__MODULE__` マクロ

@__MODULE__

# ### 2-8-3. モジュールの定義

# #### コード2-121. モジュールの例(5)：モジュールの定義例

# +
module SampleModule

export hello
const SampleConstant = :sample
hello() = println("＼コンニチハ／")

end
# -

SampleModule.SampleConstant

SampleModule.hello()

using .SampleModule

hello()

# #### コード2-122. モジュールの例(6)：モジュールのネスト

# +
module OuterModule

const OuterConst1 = :outer1

module MyInnerModule1
    const InnerConst1 = :inner1

    module MyInnerModule2
        const InnerConst2 = :inner2
        println(InnerConst2)
        import ..MyInnerModule1: InnerConst1
        println(InnerConst1)
        import ....OuterModule: OuterConst1
        println(OuterConst1)
    end  # of MyInnerModule2
end  # of MyInnerModule1

end  # of OuterModule
# => inner2
# => inner1
# => outer1
# -



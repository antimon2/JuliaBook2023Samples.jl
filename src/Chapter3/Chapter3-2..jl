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

# ## 3-2. 標準ライブラリ

# ### 3-2-1. Printf

# #### コード3-48. `Printf`(1)：`@printf` マクロ

using Printf

x = 24.927;

@printf("%d", x)  # 整数に丸めて表示

@printf("%.2f", x)  # 小数点以下2桁に丸めて表示

@printf("%.5f", x)  # 小数点以下5桁まで表示（0埋め）

@printf("%.10g", x)  # 小数点以外で合計10桁まで表示、ただし後ろに続く0は出力しない

@printf(stderr, "%d", x)  # 整数に丸めて標準エラー出力に出力

# +
# open("sampleout.txt", "w") do f
#     @printf(f, "%d", x)
# end  
# ↑ファイルに出力（動作例割愛）
# -

# #### コード3-49. `Printf`(2)：`@sprintf` マクロ

using Printf

x = 24.927;

@sprintf("%d", x)  # 整数に丸めて文字列化

@sprintf("%.2f", x)  # 小数点以下2桁に丸めて文字列化

@sprintf("%.5f", x)  # 小数点以下5桁まで文字列化（0埋め）

@sprintf("%.10g", x)  # 小数点以外で合計10桁まで文字列化、ただし後ろに続く0は出力しない

# #### コード3-50. `Printf`(3)：`Printf.format()` 関数(1)、`Printf.format"～"` 書式文字列リテラル

using Printf

x = 24.927;

Printf.format(Printf.format"%d", x)  # 整数に丸めて文字列化

Printf.format(Printf.format"%.2f", x)  # 小数点以下2桁に丸めて文字列化

Printf.format(Printf.format"%.5f", x)  # 小数点以下5桁まで文字列化（0埋め）

Printf.format(Printf.format"%.10g", x)  # 小数点以外で合計10桁まで文字列化

# #### コード3-51. `Printf`(4)：`Printf.format()` 関数(1)、`Printf.Format` オブジェクト

using Printf

x = 24.927;

function createformat(v)
    Printf.Format("%.$(ceil(Int, log10(v)) + 5)g")
end

Printf.format(createformat(x), x)

Printf.format(createformat(π), π)

Printf.format(createformat(10000000), 10000000)

# #### コード3-53. `Printf`(5)：`Printf.format()` 関数(3)

using Printf

x = 24.927;

Printf.format(stdout, Printf.format"%d", x)  # 整数に丸めて表示

Printf.format(stdout, Printf.format"%.2f", x)  # 小数点以下2桁に丸めて表示

Printf.format(stdout, Printf.format"%.5f", x)  # 小数点以下5桁まで表示（0埋め）

Printf.format(stdout, Printf.format"%.10g", x)  # 小数点以外で合計10桁まで表示、ただし後ろに続く0は出力しない

# ### 3-2-2. Dates

# #### コード3-53. `Dates` パッケージの使用例 (1)：範囲オブジェクトの生成

using Dates

# + tags=[]
Date(2021,1,1):Date(2021,12,31)
# -

Date(2021,1,1):Day(1):Date(2021,12,31)

length(Date(2021,1,1):Day(1):Date(2021,12,31))

collect(Date(2021,1,31):Month(1):Date(2021,12,31))

# + tags=[]
collect(Date(2000,2,29):Year(1):Date(2100,2,28))
# -

# #### コード3-54. `Dates` パッケージの使用例 (2)：日時書式文字列リテラル

using Dates

dt1 = today()

dtm1 = now()

Dates.format(dt1, dateformat"yyyy/mm/dd")

Dates.format(dtm1, dateformat"yyyy年m月d日 H時M分S秒")

Date("2010/1/2", dateformat"y/m/d")  # `parse(Date, "2010/1/2", dateformat"y/m/d")` でもOK

# #### コード3-55. `Dates` パッケージの使用例 (3)

using Dates

dt1 = today()

dtm1 = now()

Date(dtm1) == dt1

dt1 + Day(1)  # 明日

dt1 - Day(1)  # 昨日、`dt1 + Day(-1)` でも同じ

dtm1 + Hour(2)  # 2時間後

dtm1 - Hour(2)  # 2時間前

dt1 - Date(1976, 1, 1) + Day(1)  # 1976年1月1日 からの日数

dayofyear(dt1)  # == Dates.value(dt1 - Date(2021) + Day(1))

dtm1 - DateTime(2021, 1, 1)  # 2021年1月1日 0時0分0秒 からのミリ秒数

floor(dtm1 - DateTime(2021, 1, 1), Second)  # ミリ秒を秒に変換

dayname(dt1)

# ### 3-2-3. Statistics

# #### コード3-56. `Statistics` パッケージ使用例 (1): `mean()`、`median()`、`middle()`、`quantile()`

using Statistics

x = [2.0, 1.0, 3.0, 5.0, 10.2, 16.8]

mean(x)  # 平均値

median(x)  # 中央値

middle(x)  # 中点値

quantile(x, 0.25:0.25:0.75)  # 四分位数

# #### コード3-57. `Statistics` パッケージ使用例 (2): `std()`、`var()`

using Statistics

x = [2.0, 1.0, 3.0, 5.0, 10.2, 16.8];

std(x)  # 不偏標準偏差（補正標本標準偏差）

std(x, corrected=false)  # 標本標準偏差（非補正標本標準偏差）または母標準偏差

var(x)  # 不偏分散（補正標本分散）

var(x, corrected=false)  # 標本分散（非補正標本分散）または母分散

# #### コード3-58. `Statistics` パッケージ使用例 (3): 多次元配列への適用（`dims=～` キーワード引数指定）

using Statistics

M = [2.0 3.0 5.0; 1.0 10.2 16.8]

mean(M, dims=1)

mean(M, dims=2)

median(M, dims=2)

std(M, dims=2)

std(M, corrected=false, dims=2)

var(M, dims=2)

var(M, corrected=false, dims=2)

# #### コード3-59. `Statistics` パッケージ使用例 (4): 多次元配列への適用（`mapslices()` 関数利用）

using Statistics

M = [2.0 3.0 5.0; 1.0 10.2 16.8];

middle(M)

mapslices(middle, M, dims=1)  # 列ごとの中点値

mapslices(middle, M, dims=2)  # 行ごとの中点値

quartile(x) = quantile(x, 0.25:0.25:0.75)  # 簡単のため四分位数を算出する関数を定義

mapslices(quartile, M, dims=1)  # 結果の各列が元の行列の各列の四分位数

mapslices(quartile, M, dims=2)  # 結果の各行が元の行列の各行の四分位数

# ### 3-2-4. LinearAlgebra

# #### コード3-60. `LinearAlgebra` パッケージ使用例 (1): `⋅` 演算子（`dot()` 関数）、`×` 演算子（`cross()` 関数）

using LinearAlgebra

x = [2.0, 1.0, 3.0];

y = [2., 3., 1.];

x ⋅ y  # `dot(x, y)`, `x'y` でも同じ

x × y  # `cross(x, y)` でも同じ

A = [4. 12. -16.; 12. 37. -43.; -16. -43. 98.];

dot(x, A, y)  # `x' * A * y` としても計算結果は同じ

# #### コード3-61. `LinearAlgebra` パッケージ使用例 (2): `norm()`、`opnorm()`

using LinearAlgebra

x = [2.0, 1.0, 3.0];

norm(x)  # == `√(x'x)`

norm(x, 1)  # == `sum(abs, x)`

norm(x, Inf)  # == `max(abs, x)`

A = [4. 12. -16.; 12. 37. -43.; -16. -43. 98.];

norm(A)  # フロベニウスノルム、== `sqrt(sum(x->abs(x)^2, A))`

opnorm(A)  # 作用素ノルム

# #### コード3-62. `LinearAlgebra` パッケージ使用例 (3): `rank()`、`tr()`、`det()`、`pinv()`

using LinearAlgebra

A = [1. 2. 3.; 4. 5. 6.; 7. 8. 9.]

rank(A)  # `rank(A) < minimum(size(A))` となる行列をランク落ちと言う
         # （特に正方行列なら正則行列ではない）

tr(A)

det(A)

pinv(A)  # 正則行列でない行列でも `pinv(A)` は計算できる

x = [1.0, 2.0, 4.0];

# `A \ x` は `SingularException(3)` 発生
pinv(A) * x  # `A * ○ == [1, 2, 4]` となる `○` の誤差(最)小解

pinv(x) * x ≈ 1.0

# #### コード3-63. `LinearAlgebra` パッケージ使用例 (4): 各種行列（抜粋）

A = [1. 2. 3.; 4. 5. 6.; 7. 8. 9.];

Symmetric(A)  # 対称行列

Hermitian(A+fill(im,3,3))  # エルミート行列

Diagonal(A)  # 対角行列

UpperTriangular(A)  # 上三角行列

LowerTriangular(A)  # 下三角行列

# #### コード3-64. `LinearAlgebra` パッケージ使用例 (5): 行列の分解

A = [3. 5. 2.; 5. 7. 3.; 2. 3. 1.]

factorize(A)  # == bunchkaufman(A)

cholesky(A+I)

isposdef(A)

lu(A)

qr(A)

y1 = A * [1., 2., 3.]

y2 = (A + I) * [1., 2., 3.]

factorize(A) \ y1 ≈ [1, 2, 3]

bunchkaufman(A) \ y1 ≈ [1, 2, 3]

cholesky(A+I) \ y2 ≈ [1, 2, 3]

lu(A) \ y1 ≈ [1, 2, 3]

qr(A) \ y1 ≈ [1, 2, 3]

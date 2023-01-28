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

# ## 3-1. 便利な標準関数たち

# ### 3-1-1. 演算系(1) 除算・剰余算系

# #### 整数除算関数

div(5, 2)

div(-5, 2)

fld(5, 2)

fld(-5, 2)

cld(5, 2)

cld(-5, 2)

# ##### コード3-1. `÷`演算子の関数としての利用例

÷(-5, 2)

÷(-5, 2, RoundDown)

÷(-5, 2, RoundNearest)

÷(-5, 2, RoundNearestTiesAway)

# #### 整数剰余算関数

# #### 整数除算・剰余算複合関数

# #### 値域を指定した整数剰余算関数と整数除算関数

# #### コラム. `mod1()` 関数の使い途

# ##### 仮想コード3-a. `mod1()` 関数の使用例（`Dates` モジュール内の実装イメージ）

# ```julia
# # Monday = 1....Sunday = 7
# dayofweek(date) = mod1(days(date), 7)
#
# days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday",
#                 "Friday", "Saturday", "Sunday"]
#
# dayname(date) = days_of_week[dayofweek(date)]
# ```

# #### その他の除算・剰余算関連関数

# ##### コード3-2. `\`演算子の例

2 \ 3  # == `3 / 2`

1//2 \ 3//4  # == `2 * 3//4`

A = Float64[1 2; 3 4]; x = [1, 1];
A \ x  # == `A^(-1) * x`

# ### 3-1-2. 演算系(2) 結合演算

# #### 積和演算

# ##### コード3-3. `fma()` 関数、`muladd()` 関数の例

fma(0.1, 0.2, 0.3)

muladd(0.1, 0.2, 0.3)

A = [1 2; 3 4]; x = [-1, 1]; y = 100;
muladd(A, x, y)

# + tags=[]
fma(A, x, y)
# -

# #### 冪剰余演算

# ##### コード3-4. `powermod()` 関数の例

powermod(5, 2, 20)  # == mod(5^2, 20)

powermod(1518500249, 3, 100)

mod(1518500249^3, 100)  # オーバーフローが発生するため結果が期待通りにならない例

# ### 3-1-3. 演算系(3) その他の演算系関数

# ### 3-1-4. 数学系(1) 三角関数、指数関数、対数関数

sin(2π)

sind(360)

sinpi(2)

sind(360) == sinpi(2) == 0.0

# ### 3-1-5. 数学系(2) その他の数学関数

# ### 3-1-6. 文字列関連関数

# #### 文字・文字列情報取得関数・演算子

# ##### コード3-5. `nextind()` 関数、`eachindex()` 関数の使用例

str = "abcあいう😄漢字";

[nextind(str, 0, v) for v=1:length(str)]

# 参考：上記と同じ結果になるコード
collect(eachindex(str))  # `collect(keys(str))` でもOK

# #### 文字・文字列比較関数・演算子

# #### 文字列操作関数・演算子

# ##### コード3-6. `chop()` 関数の例

str = "abcあいう😄漢字";

chop(str)

chop(str, head=1)

chop(str, tail=3)

chop(str, head=3, tail=0)

# ##### コード3-7. `split()` 関数、`rsplit()` 関数の例

split("A B  C") == ["A", "B", "C"]

split("A B  C", keepempty=true) == ["A", "B", "", "C"]

split("A B C", limit=2) == ["A", "B C"]

rsplit("A B C", limit=2) == ["A B", "C"]

split("A2B34C", 'B') == ["A2", "34C"]

rsplit("A2B34C", '0':'9') == ["A", "B", "", "C"]

rsplit("A2B34C", '0':'9', keepempty=false) == ["A", "B", "C"]

# ##### コード3-8. `strip()` 関数、`lstrip()` 関数、`rstrip()` 関数の例

strip("   ABC  ") == "ABC"

lstrip("   ABC  ") == "ABC  "

rstrip("   ABC  ") == "   ABC"

strip("{3, 5}\n", ['{', '}', '\n'])

strip("{3, 5}\n") do c
    isspace(c) || ispunct(c)
end

# #### 文字列検索・置換関数

# ##### コード3-9. `findxxxx()` 系の関数の例(1)

str = "rem2pi(42.195)";

findfirst(isdigit, str)

str[findfirst(isdigit, str)]

findnext(isdigit, str, 5)

str[findnext(isdigit, str, 5)]

findlast(isdigit, str)

str[findlast(isdigit, str)]

findprev(isdigit, str, 12)

str[findprev(isdigit, str, 12)]

findfirst("pi", str)

str[findfirst("pi", str)]

# ##### コード3-10. `occursin()` 関数、`contains()` 関数の例

occursin("pi", "rem2pi(42.195)")

contains("rem2pi(42.195)", "pi")

pred1 = occursin("rem2pi(42.195)");

map(pred1, ['.', "NOT_EXISTS", r"\d+"]) == [true, false, true]

pred2 = contains(r"\d{2,}");  # 数字2文字以上、という正規表現

filter(pred2, ["42.195", "Julia v1.6", "ALLALPHABETS"])

# ##### コード3-11. `replace()` 関数の例(1)

replace("123ABCあいう漢字", 'A'=>'α')

replace("123ABCあいう漢字", "ABC"=>"XYZ", 'あ':'ん'=>"")  # Julia v1.7 以降で有効

replace(replace("123ABCあいう漢字", "ABC"=>"XYZ"), 'あ':'ん'=>"")  # Julia v1.6 ならこちら

replace("123ABCあいう漢字", isuppercase=>lowercase)

# #### Julia の正規表現

# ##### コード3-12. 正規表現の使用例（`occursin()`/`contains()`）

occursin(r"^#[0-9a-f]{6}$"i, "#FFA800")

contains("ThereIsNoSpace!", r"\s+")

pred2 = contains(r"\d{2,}");  # 数字2文字以上、という正規表現

filter(pred2, ["42.195", "Julia v1.6", "ALLALPHABETS"])

# ##### コード3-13. `match()` 関数の例

m = match(r"\d+", "123ABCあいう漢字")

m.match  # マッチした部分文字列

m = match(r"(\d+)(?<ABC>[ABC]+)", "123ABCあいう漢字")

m.match  # マッチした部分文字列

m[1]  # キャプチャグループ（1番目）

m[2]  # キャプチャグループ（2番目）

m["ABC"]  # 名前付きキャプチャグループ（"ABC"）

match(r"\s", "ThereIsNoSpace!") === nothing

# ##### コード3-14. `eachmatch()` 関数の例

for m in eachmatch(r"\w+", "Yes, I have a number.")
    println(m.match)
end

[m[1] for m in eachmatch(r"_(\d+)_", "1_23_456_78_9", overlap=true)]

# ##### コード3-15. `replace()` 関数の例(2)：正規表現、置換文字列リテラルの例

replace("123ABCあいう漢字", r"\d"=>s"\0\0")

replace("123ABCあいう漢字", r"\d"=>s"\g<0>1")  # `s"\01"` だと "PCRE error: unknown substring" となる

replace("123ABCあいう漢字", r"(\d+)(?<abc>[a-z]+)"ia=>s"\g<abc>\1")  # `s"\2\1"` でも同じ

# #### パターンに指定出来るもの

# ##### コード3-16. `findxxxx()` 系の関数の例(2)：対応していないパターンの述語関数による代替

# + tags=[]
findfirst('A':'Z', "123ABCあいう漢字")  # MethodError 発生
# -

findfirst(∈('A':'Z'), "123ABCあいう漢字")

findall('A', "ABCABCABCA")  # Julia v1.7 ならOK、v1.6だと MethodError 発生

findall(==('A'), "ABCABCABCA") == [1, 4, 7, 10]  # Julia v1.6 でも v1.7 でもOK

# ### 3-1-7. 配列・集合演算

# #### コレクション情報取得関数・演算子

# ##### コード3-17. コレクション情報取得関数の例

A = [100z + 10y + x for x=1:3, y=1:4, z=1:2];

ndims(A)

size(A)

size(A, 1)  # == size(A)[1]

axes(A)

axes(A, 2)  # == axes(A)[2]

# + tags=[]
for x in axes(A, 1), y in axes(A, 2), z in axes(A, 3)
    println(A[x, y, z])
end
# -

axes((:a, :b, :c))

# #### 配列関連関数・演算子(1) 配列生成関連

# ##### コード3-18. 配列生成の例(1)：コンストラクタ利用

Vector{Int}(undef, 5)  # 結果は実行する度に変化する

Matrix{Float64}(undef, 2, 2)  # 結果は実行する度に変化する

Array{UInt8}(undef, 2, 3, 2)  # 結果は実行する度に変化する

# ##### コード3-19. 配列生成の例(2)：`zeros()`、`ones()`、`fill()`

zeros(Int, 5)

ones(2, 2)

fill(0x7f, 2, 2)

# ##### コード3-20. 配列生成の例(3)：`BitArray`（`BitVector`、`BitMatrix`）の生成

BitArray(undef, 2, 3)  # 結果は実行する度に変化する

trues(3, 4, 2)

typeof(1:2:10 .== [1, 3, 5, 7, 9])

# ##### コード3-21. 配列生成の例(4)：`similar()`

A = UInt8[1 2; 3 4];

similar(A)  # `Array{UInt8}(undef, 2, 2)` と同じ

similar(A, 3, 4, 2)  # `Array{UInt8}(undef, 3, 4, 2)` と同じ

similar(A, Float64)  # `Array{Float64}(undef, 2, 2)` と同じ

B = BitArray(undef, 2, 2);

similar(B, 10)  # `BitArray(undef, 10)` と同じ

# #### 配列関連関数・演算子(2) 配列加工・更新

# #### 配列関連関数・演算子(3) ベクトル・行列関連

# ##### コード3-22. 行列・ベクトル演算の例

A = [1 2; 3 4];

x = [-1, 1];

y = A * x

A \ y  # `== x`、ただし要素の型は `Float64`

# ##### コード3-23. `transpose()`、`adjoint()`（`○'`）の例

A = [1 2; 3 4]; x = [-1, 1];

transpose(A)

A'  # `adjoint(A)` としても同じ

A'A  # A' * A と同じ

C = [1+1im -1+1im; 1-1im -1-1im];

transpose(C)

C'  # `adjoint(C)` としても同じ

transpose(x)

x'  # `adjoint(x)` としても同じ

x'A  # x' * A と同じ

x'x  # x' * x と同じ

# #### 配列関連関数・演算子(4) デック（両端キュー）

# ##### コード3-24. デック(1)：先頭/末尾への追加/取り出しの例

q = [1, 2, 3, 4, 5];

push!(q, 11, 12, 13)

pop!(q)

pop!(q)

pop!(q)

q

pushfirst!(q, -2, -1)

popfirst!(q)

popfirst!(q)

prepend!(append!(q, 6:9), -2:0)

# ##### コード3-25. デック(2)：任意の位置への追加/取り出し/削除の例

q = [10, 20, 30, 40, 50];

insert!(q, 4, 35)

popat!(q, 4)

deleteat!(q, 3:4)

# + tags=[]
popat!(q, 4)  # エラー
# -

popat!(q, 4, 999)

# #### 配列関連関数・演算子(5) 集計・畳み込み関連関数

# ##### コード3-26. 集計・畳み込み関連関数(1)：`sum()`、`prod()`、`maximum()`、`minimum()` の例

A = [1 2; 3 4];

sum(A)

sum(A, dims=1)

sum(A, dims=2)

prod(A)

prod(A, dims=1)

prod(A, dims=2)

maximum(A)

maximum(A, dims=1)

maximum(A, dims=2)

minimum(A)

minimum(A, dims=1)

minimum(A, dims=2)

M = [100z + 10y + x for x=1:2, y=1:2, z=1:2];

sum(M, dims=(1, 3))

# ##### コード3-27. 集計・畳み込み関連関数の例(2)

A = [1 2; 3 4];

reduce(+, A, dims=1)  # `== sum(A, dims=1)`

reduce(-, A, dims=2, init=0)  # `reduce(-, A, dims=2)` だとエラーになる

x = [1, 2, 3, 4];

reduce(-, x)  # エラーにはならないが結果が保証されているわけでもない

foldl(-, x)  # `== (((1 - 2) - 3) - 4)`

foldr(-, x)  # `== (1 - (2 - (3 - 4)))`

foldr((n, x) -> n + inv(x), [1;fill(2,100)])  # √2 の近似値

# ##### コード3-28. 集計・畳み込み関連関数(3)：`mapslices()` の例

A = [1 2; 3 4];

norm2(v) = √(v'v)

mapslices(norm2, A, dims=1)

mapslices(norm2, A, dims=2)

mapslices(norm2, [1 2 3; 4 5 6; 7 8 9], dims=1)

# #### 配列関連関数・演算子(6) 検索・置換関連関数

# ##### コード3-29. `findxxxx()` 系の関数の例(3)：配列への適用

x = rand(10)  # 実行する度に結果は変わる

findall(>(0.3), x)

findfirst(<(0.7), x)

findnext(x, 5) do v
    v ≤ 0.2 || v ≥ 0.8
end

b = BitVector([0, 0, 1, 0, 1]);

findall(b)

findlast(b)

findprev(b, 4)

M = [3 1 4; 5 9 2];

findall(isodd, M)

# + [markdown] tags=[]
# ##### コード3-30. `argmax()`、`argmin()`、`findmax`、`findmin` の例(1)
# -

M = [3 1 4; 5 9 2];

argmax(M)

argmin(M)

findmax(M)

findmin(M)

argmax(M, dims=1)

argmin(M, dims=2)

findmax(M, dims=1)

findmin(M, dims=2)

# #### 辞書関連関数

# ##### コード3-31. 辞書関連関数(1)

D = Dict(:a=>1, :b=>2, :c=>3)

keytype(D)

valtype(D)

keys(D)

collect(values(D))

keytype(D) === eltype(keys(D))

valtype(D) === eltype(values(D))

# ##### コード3-32. 辞書関連関数(2)：`haskey(D, k)`（`k ∈ keys(D)`）

D = Dict(:a=>1, :b=>2, :c=>3);

haskey(D, :a)  # `:a ∈ keys(D)` と書いても同じ

haskey(D, :no)  # `:no ∈ keys(D)` と書いても同じ

# ##### コード3-33. 辞書関連関数(3)：キー参照関連

D = Dict(:a=>1, :b=>2, :c=>3);

D[:a]

# + tags=[]
D[:d]
# -

get(D, :a, -99)

get(D, :d, -99)

get(D, :a) do
    println("ここには来ない！")
end

get(D, :d) do
    rand(-99:-90)  # 実行する度に結果が変わる
end

get!(D, :d, 4)  # `D[:d] = 4` も実行される

D[:d]

get!(D, :e) do
    rand(-99:-90)  # 実行する度に結果が変わる
end

D[:e]

getkey(D, :e, :exists)  # ↑で登録されたので存在する

getkey(D, :f, :notexists)

# ##### コード3-34. 辞書関連関数(4)：登録・更新関連

D = Dict(:a=>1, :b=>2, :c=>3)

D[:a] = 10  # 更新

D

push!(D, :b=>4, :d=>5, :e=>6)  # `:b` は更新、`:d`, `:e` は新規登録

D

# ##### コード3-35. 辞書関連関数(5)：削除（取り出し）関連

D = Dict(:a=>1, :b=>2, :c=>3, :d=>4, :e=>-95);

delete!(D, :e)

haskey(D, :e)

delete!(D, :e)  # エラーにならない

pop!(D, :d)

haskey(D, :d)

# + tags=[]
pop!(D, :d)  # エラーになる
# -

pop!(D, :d, -99)  # エラーにならない

# ##### コード3-36. 辞書関連関数(6)：辞書のマージ

D1 = Dict(:a=>1, :b=>2, :c=>3);

D2 = Dict(:b=>4, :d=>5, :f=>6);

merge(D1, D2)

merge(D2, D1)

mergewith(+, D1, D2)

mergewith(D1, D2) do a, b
    10a + b
end

merge!(D1, D2)  # D1 が更新される

mergewith!(-, D1, D2)  # D1 が更新される

D1

# #### 集合関連関数・演算子

# ##### コード3-37. 集合関連関数(1)：積集合・和集合

S1 = Set([1, 2, 3]); S2 = Set([2, 4, 6]);

S1 ∩ S2

S1 ∪ S2

S0 = Set(1:10);

intersect!(S0, S1, S2)  # S0 が更新される

S0

union!(S0, S1, S2)  # S0 が更新される

S0

# ##### コード3-38. 集合関連関数(2)：差集合・対称差集合

S1 = Set([1, 2, 3]); S2 = Set([2, 4, 6]);

setdiff(S1, S2)

setdiff(S2, S1)

S0 = Set(1:10);

setdiff!(S0, S1, S2)  # S0 が更新される

S0

symdiff(S1, S2)

symdiff(S2, S1)

S0 = Set(1:10);

symdiff!(S0, S1, S2)  # S0 が更新される

S0

# ##### コード3-39. 集合関連関数(3)：追加・削除（取り出し）

S = Set(Int[])

push!(S, 1, 2, 3)

delete!(S, 3)

delete!(S, 4)  # 存在しない要素を指定してもエラーにならない

pop!(S, 2)

# + tags=[]
pop!(S, 2)  # エラーになる
# -

pop!(S, 2, -99)

# #### タプル・名前付きタプル関連関数

# ##### コード3-40. タプル関連関数、名前付きタプル関連関数(1)

t = ('a', 2, 99.9, π);

first(t)

last(t)

Base.front(t)

Base.tail(t)

nt = (a=1, b=2, c=3);

first(nt)

last(nt)

Base.front(nt)

Base.tail(nt)

# ##### コード3-41. 名前付きタプル関連関数(2)

nt = (c='a', i=2, f=99.9, π);

keys(nt)

values(nt)

haskey(nt, :a)

haskey(nt, 3)

get(nt, :c, 'X')

get(nt, 99, "デフォルト値")

get(nt, :x) do
    rand()
end

s = "あいう"

merge(nt, (a=1, b=2, s))

merge(nt, [:a=>1, :b=>2, :c=>3, :d=>4, :e=>5])

# ### 3-1-9. その他「あると便利」がある関数

# ### 3-1-10. 演算子は関数

# #### コード3-42. `+` 演算子の関数としての利用例

+(1)  # == `+1`

+(1, 2)  # == `1 + 2`

+(1, 2, 3)  # == `1 + 2 + 3`

+(1, 2, 3, 4)  # == `1 + 2 + 3 + 4`

+(1, 2, 3, 4 ,5)  # == `1 + 2 + 3 + 4 + 5`

# #### コード3-43. `÷` 演算子の関数としての利用例（再）

÷(5, 2)

÷(5, 2, RoundDown)

÷(5, 2, RoundUp)

÷(5, 2, RoundNearest)

÷(5, 2, RoundNearestTiesUp)

# #### コード3-44. `≈` 演算子のヘルプ

#=
?≈
=#

# #### コード3-45. `≈` 演算子の関数としての利用例

v = 1.0e-10

v ≈ 0.0

≈(v, 0.0, atol=1e-8)

# #### コード3-46. 比較演算子で作る述語関数(1)：`∈` 演算子の使用例

is1to10 = ∈(1:10);

is1to10(3)

is1to10(12)

# #### コード3-47. 比較演算子で作る述語関数(2)：`≈` 演算子の使用例

isalmost0 = ≈(0.0, atol=1e-8);

isalmost0(1.0e-10)

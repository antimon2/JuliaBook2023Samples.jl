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

# ## 9-1. タスクとチャネル

# ### 9-1-1. タスク

# #### コード9-1. 実行に5秒かかるコード例

begin
    sleep(5)
    print("Done.")
end

# #### コード9-2. タスクの定義例

@task begin
    sleep(5)
    print("Done.")
end

# #### コード9-3. タスクの実行例

t = @task begin
    sleep(5)
    print("Done.")
end

schedule(t)

# #### コード9-4. `@async` の例

@async begin
    sleep(5)
    print("Done.")
end

# #### コード9-5. `wait()` の例

t = @async begin
    sleep(5)
    print("Done.")
end

wait(t)  # ←5秒以内に実行すること！
# ↓しばらくしてから表示される
# Done.
# ↑これが表示されるまではプロンプトが返ってこない

# +
t1 = @task begin
    println("t1 start.")
    sleep(3)
    println("t1 end.")
end;

t2 = @task begin
    println("t2 start.")
    wait(t1)
    println("t2 end.")
end;

schedule(t1); schedule(t2); wait(t2)
# -

# #### コード9-6. `@sync` の例

@sync begin
    t1 = @async begin
        println("t1 start.")
        sleep(3)
        println("t1 end.")
    end
    @async begin
        println("t2 start.")
        wait(t1)
        println("t2 end.")
    end
end;

# #### コード9-7. `fetch()` の例

begin
    t1 = @async begin
        println("t1 start.")
        sleep(3)
        "t1 end."
    end
    t2 = @async begin
        println("t2 start.")
        msg = fetch(t1)
        println(msg)
        "t2 end."
    end
    println(fetch(t2))
end

fetch(t1)

fetch(t2)

# ### 9-1-2. 通知

# #### コード9-8. 通知による協調動作の例

# +
cond1 = Condition();

cond2 = Condition();

@sync begin
    @async begin
        wait(cond2)
        println("t1 start.")
        notify(cond1)
        wait(cond2)
        println("t1 end.")
        notify(cond1)
    end
    @async begin
        wait(cond1)
        println("t2 start.")
        notify(cond2)
        wait(cond1)
        println("t2 end.")
        notify(cond2)
    end
    @async notify(cond2)
end;
# -

# ### 9-1-3. チャネル

# #### コード9-9. `Channel` の使用例(1)

chnl = Channel()

isempty(chnl)

t = @async begin
    put!(chnl, "task start")
    n = 1
    while true
        put!(chnl, n)
        n += 1
        n > 15 && break
    end
    put!(chnl, "task end")
end

isempty(chnl)  # 1件でも `put!(～)` で追加した要素がある

take!(chnl)

take!(chnl)

take!(chnl)

take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);
take!(chnl);

take!(chnl)

take!(chnl)

isempty(chnl)  # 全部列挙し終わった（もう `put!()` で追加した要素がない）

# +
# take!(chnl)  # ※注意：返ってこないので実行しないこと！
# -

close(chnl)

isempty(chnl)

take!(chnl)

# #### コード9-10. `Channel` の使用例(1) の動作確認用コード

function checkchannel()
    chnl = Channel()
    t = @async begin
        println("putting value...")
        put!(chnl, "task start")
        println("put value: ", "task start")
        n = 1
        while true
            println("putting value...")
            put!(chnl, n)
            println("put value: ", n)
            n += 1
            n > 15 && break
        end
        println("putting value...")
        put!(chnl, "task end")
        println("put value: ", "task end")
    end

    while true
        println("taking value...")
        v = take!(chnl)
        println("taken value: ", v)
        v == "task end" && break
    end
    wait(t)
    close(chnl)
end

# #### コード9-11. `Channel` の使用例(1) の動作確認

checkchannel()

# #### コード9-12. `Channel` の使用例(2): Doブロック構文 の利用

chnl = Channel() do chnl
    put!(chnl, "task start")
    n = 1
    while true
        put!(chnl, n)
        n += 1
        n > 15 && break
    end
    put!(chnl, "task end")
end

for n in chnl
    println(n)
end

take!(chnl)

# #### コード9-13. `Channel` の使用例(3): 要素の型の指定

function collatz_channel(n)
    Channel{Int}() do chnl
        put!(chnl, n)
        while n != 1
            n = iseven(n) ? n ÷ 2 : 3n + 1
            put!(chnl, n)
        end
    end
end

typeof(collatz_channel(3))

eltype(collatz_channel(3))

for n in collatz_channel(3)
    println(n)
end

collect(collatz_channel(27))

# #### コード9-14. `Channel` の使用例(4) バッファドチャネル

chnl = Channel(3) do chnl
    put!(chnl, "task start")
    n = 1
    while true
        put!(chnl, n)
        n += 1
        n > 15 && break
    end
    put!(chnl, "task end")
end

for v in chnl
    println(v)
end

# #### コード9-15. `Channel` の使用例(4) の動作確認用コード

function checkchannelB()
    chnl = Channel(3)
    t = @async begin
        println("putting value...")
        put!(chnl, "task start")
        println("put value: ", "task start")
        n = 1
        while true
            println("putting value...")
            put!(chnl, n)
            println("put value: ", n)
            n += 1
            n > 15 && break
        end
        println("putting value...")
        put!(chnl, "task end")
        println("put value: ", "task end")
    end

    while true
        println("taking value...")
        v = take!(chnl)
        println("taken value: ", v)
        v == "task end" && break
    end
    wait(t)
    close(chnl)
end


# #### コード9-16. `Channel` の使用例(4) の動作確認

checkchannelB()

# #### コード9-17. `fetch(chnl)` の例

chnl = Channel(3) do chnl
    put!(chnl, 1)
    put!(chnl, 2)
    put!(chnl, 3)
end

fetch(chnl)

fetch(chnl)

take!(chnl)

fetch(chnl)

take!(chnl)

take!(chnl)

fetch(chnl)  # もしくは `take!(chnl)`

fetch(Channel())  # アンバッファドチャネルを渡した場合

# ### 9-1-4. タスク・チャネル による並行処理

# #### コード9-18. `SearchJuliaSample.jl`（`Channel` の実用例（並行処理の例））

# +
module SearchJuliaSample

using Downloads

const UA = "Mozilla/5.0 (Julia v$(VERSION))"

struct SearchEngine <: Function
    name::String
    url::String
end
const Google = SearchEngine("Google", "https://www.google.com/search?q=julialang&oe=UTF-8")
const Bing = SearchEngine("Bing", "https://www.bing.com/search?q=julialang")
const DuckDuckGo = SearchEngine("DuckDuckGo", "https://duckduckgo.com/?q=julialang")

struct SearchSummary{R}
    engine::String
    exec_time::Float64
    response::R  # Maybe Downloads.Response
    body::Vector{UInt8}
end
function Base.show(io::IO, summary::SearchSummary)
    println(io, "engine: ", summary.engine)
    println(io, "exec_time: ", summary.exec_time)
    print(io, "response: (")
    print(io, "$(summary.response.status), ")
    print(io, "$(length(summary.response.headers)) headers, ")
    println(io, "$(length(summary.body)) bytes in body)")
end

function (engine::SearchEngine)()
    buf = IOBuffer()
    res, exec_time = @timed Downloads.request(
        engine.url;
        headers=["User-Agent"=>UA],
        output=buf
    )
    SearchSummary(engine.name, exec_time, res, take!(buf))
end
function (engine::SearchEngine)(channel)
    summary = engine()
    if isopen(channel)
        put!(channel, summary)
    end
end

# "fcfs" stands for "first come, first served"  # 日本語で「早い者勝ち」
function fcfs()
    results = Channel{SearchSummary{Downloads.Response}}()

    @async Google(results)
    @async Bing(results)
    @async DuckDuckGo(results)

    res0 = take!(results)  # 同期
    close(results)

    print(res0)
end

function race()
    results = Channel{SearchSummary{Downloads.Response}}(3)

    @async Google(results)
    @async Bing(results)
    @async DuckDuckGo(results)

    res1 = take!(results)  # 同期
    println(res1)

    res2 = take!(results)  # 同期
    println(res2)

    res3 = take!(results)  # 同期
    print(res3)

    close(results)
end

end
# -

# #### コード9-19. `SearchJuliaSample.jl` の実行例(1) 基本動作

SearchJuliaSample.Google()

SearchJuliaSample.Bing()

SearchJuliaSample.DuckDuckGo()

# #### コード9-20. `SearchJuliaSample.jl` の実行例(2) 並行処理

SearchJuliaSample.fcfs()

SearchJuliaSample.fcfs()

SearchJuliaSample.fcfs()

SearchJuliaSample.race()

SearchJuliaSample.race()

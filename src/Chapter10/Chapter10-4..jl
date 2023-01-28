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

# ## 10-4. パッケージ開発の基本

# ### 10-4-1. `PkgTemplates.jl` によるパッケージディレクトリの生成

# #### コード10-1. git のグローバル設定の確認と設定（Bash/Zsh等の例、Windows Powershell でも同様）

;git config --global user.name

;git config --global user.email

;git config --global github.user

# ```shell
# # 確認
# $ git config --global user.name
# USER Name  # ←一例です。
#
# $ git config --global user.email
# username@email.example.com  # ←一例です。
#
# $ git config --global github.user
# githubuser  # ←一例です。
#
# # 未設定（何も表示されない）なら以下の要領で設定
# $ git config --global user.name "USER Name"  # ←実際にはあなたの名前を設定してください
#
# $ git config --global user.email "username@email.example.com"  # ←あなたのメールアドレスを設定
#
# $ git config --global github.user githubuser  # ←あなたの github ユーザ名を設定
# ```

mkdir("pkgdev") |> cd

]activate .

]add PkgTemplates

]st

# #### コード10-3. パッケージテンプレートの作成

using PkgTemplates

tpl = Template(;
    dir = pwd(),
    julia = v"1.6",
    plugins = [Git(ssh=true)]
)

tpl("MyPackage")

# #### コード10-5. `PkgTemplates` により自動生成されたファイル群の確認

readdir("MyPackage")

readdir("MyPackage/src")

readdir("MyPackage/test")

print(read("MyPackage/Project.toml", String))

print(read("MyPackage/src/MyPackage.jl", String))

print(read("MyPackage/test/runtests.jl", String))

# ### 10-4-2. 構成ディレクトリ・ファイルについての補足

# #### コード10-6. テストコードの簡単な例

lines = readlines("MyPackage/test/runtests.jl")
insert!(lines, length(lines), "    @test 1 + 1 == 2")
open("MyPackage/test/runtests.jl", "w") do f
    for line in lines
        println(f, line)
    end
end
print(read("MyPackage/test/runtests.jl", String))

# #### コード10-7. 開発中のパッケージのテスト実行例(1)

]dev ./MyPackage

]test MyPackage

# #### 仮想コード10-15. テスト失敗・エラーの出力例

open("MyPackage/test/runtests.jl", "a") do f
    println(f, """
@testset "Failure Sample" begin
    @test 1 + 1 == 2
    @test 1 + 1 == 3
    @test error("Error Sample")
end
""")
end
print(read("MyPackage/test/runtests.jl", String))

]test MyPackage

lines = readlines("MyPackage/test/runtests.jl")
open("MyPackage/test/runtests.jl", "w") do f
    for line in lines[1:7]
        println(f, line)
    end
end
print(read("MyPackage/test/runtests.jl", String))

# #### 表10-6. `Test` 標準パッケージに用意されているテスト用マクロ（概要）

# | マクロ | 説明 |
# | :-- | :-- |
# | `@test` | 結果が `true` かどうか |
# | `@test_throws` | 指定したエラー（例外）が `throw` されるかどうか |
# | `@test_warn` | 標準エラー出力に指定した警告が出力されるかどうか |
# | `@test_nowarn` | 標準エラー出力に警告が出力されないかどうか |
# | `@test_logs` | 指定した種類と内容のログが出力されるかどうか |
# | `@test_deprecated` | （指定した書式の）`Deprecated` 警告が発生するかどうか |
# | `@test_broken` | テストが失敗するかどうか |
# | `@test_skip` | テストをスキップする（broken 扱いにする） |
# | `@testset` | テストをグループ化する（ネスト可） |

# #### コード10-8. 開発中のパッケージのテスト実行例(2)

]activate MyPackage

]test

# #### コード10-9. コマンドラインからテストを実行する例（Bash/Zsh での例）

cd("MyPackage")

;julia --project=. -e 'using Pkg;Pkg.test()'

cd("..")

mkpath("MyPackage/deps");
open("MyPackage/deps/build.jl", "w") do f
    println(f, "@info \"MyPackage is been built...\"")
end
print(read("MyPackage/deps/build.jl", String))

]build MyPackage

print(read("MyPackage/deps/build.log", String))

# JuliaBook2023Samples.jl
2023/03/15 発売の『実践Julia入門』のサンプルコード。

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/antimon2/JuliaBook2023Samples.jl/HEAD?urlpath=lab%2Ftree%2Fnotebooks) [![Open in SageMaker Studio Lab](https://studiolab.sagemaker.aws/studiolab.svg)](https://studiolab.sagemaker.aws/import/github/antimon2/JuliaBook2023Samples.jl/blob/main/notebooks/instantiate.ipynb)

## サンプルプログラムについて

本GitHubリポジトリでは『**実践Julia入門**』（以降 **本書**）に掲載されているサンプルプログラムを収録しています。  
本リポジトリは以下のような構成となっています。

+ `notebooks/`
    + `instantiate.ipynb`：プロジェクト環境の依存パッケージをインストールする（最初に1回実行）
    + `Chapter1/` ～ `Chapter13/`：本書の対応する各章のコードを収録したディレクトリ
        + `ChapterX-Y..ipynb`：本書の各節（X-Y.）ごとのサンプルコードを収録したノートブックファイル
        + その他のファイル（`～.jl` / `～.txt` 等）：上記ノートブック内で参照されているファイル
+ `src/`
    + `instantiate.jl`：プロジェクト環境の依存パッケージをインストールする（最初に1回実行）
    + `Chapter1/` ～ `Chapter13/`：本書の対応する各章のコードを収録したディレクトリ
        + `ChapterX-Y..jl`：本書の各節（X-Y.）ごとのサンプルコードを収録したソースファイル
        + その他のファイル（`～.jl` / `～.txt` 等）：上記ソースファイル内で参照されているファイル
    + `JuliaBook2023Samples.jl`：ダミーファイル（デフォルトのモジュールファイル）
+ `Project.toml`：本書全体のプロジェクト環境を表す設定ファイル

※ `src` ディレクトリ内の各 `ChapterX-Y..jl` ファイルは、`notebooks` ディレクトリ内の対応する `ChapterX-Y..ipynb` ファイルを [jupytext](https://github.com/mwouts/jupytext) というツールを利用して変換したものであり、REPL にコピー＆ペーストして実行（もしくは対応するエディタで選択→実行等）することを想定したものです。

## 利用方法

### 1. Julia の REPL 環境で利用する

本リポジトリをクローンし、`src` ディレクトリ内の各 `ChapterX-Y..jl` ファイルをテキストエディタで開いて、REPL にコードをコピー＆ペースとして実行してください。  
対応するエディタ（IDE）なら、コードを範囲選択（もしくはコード上にカーソルを配置）して <kbd>Ctrl</kbd>+<kbd>Enter</kbd> 等でも実行できます。  
ただし、行頭が「`?`」/「`;`」/「`]`」で始まっているものは、Julia REPL の対応するモードのためのコードとなっているため、そのままでは動作しません（エラーにならないように前後の行に `#=`～`=#` を設置（複数行コメント）してコメントアウトしてあります）。これらのコード以下の表の要領で実行してください。

| コード例 | 対応するモード | 操作説明 |
| :-- | :-- | :-- |
| `?«関数名等»` | ヘルプモード | <kbd>?</kbd> をタイプしてから `«関数名等»` をタイプ |
| `;«コマンド等»` | シェルモード | <kbd>;</kbd> をタイプしてから `«コマンド等»` をタイプ |
| `]«コマンド等»` | パッケージモード | <kbd>]</kbd> をタイプしてから `«コマンド等»` をタイプ |

なお Julia REPL 起動時に、リポジトリをクローンしたディレクトリ内で `julia --project=@.` として起動すると、本サンプルコードのプロジェクト環境を活性化した状態で起動できます。その場合最初にパッケージモードで（＝<kbd>]</kbd> をタイプしてから）で `instantiate` コマンドを実行すると、本書の依存パッケージがインストールされます（最初の1回だけでOKです）。
（『プロジェクト環境』については、本書の「第10章 パッケージマネージャ」を参照してください）

また一部のコードはマルチスレッド機能を有効にしないと期待通りに動作しません。その場合は `julia -t 4 --project=@.` のように `-t N` オプションを指定して Julia REPL を起動してください。
（『マルチスレッド』についての詳細は、本書の「第9章 並行・並列処理」を参照してください）

### 2. 手元の JupyterLab 環境で利用する

本リポジトリをそのままクローンし、JupyterLab（Jupyter Notebook）環境で `notebooks` リポジトリ内を開いてください。
クローンしたら最初に `instantiate.ipynb` を実行してください。

一部のノートブックは、マルチスレッドが有効になっていないと期待通りに動作しません。マルチスレッド対応の IJulia カーネルを追加して動作確認してください（方法は本書の「第1章 1-4. Julia を JupyterLab で使用する」を参照してください）。

### 3. MyBinder で利用する

手元に Julia や JupyterLab の環境がなくても、オンラインで用意されているプレイグラウンドである [MyBinder](https://mybinder.org/) 上で全てのサンプルプログラム（ノートブック）を動作させることができます。

本 README に設置した [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/antimon2/JuliaBook2023Samples.jl/HEAD?urlpath=lab%2Ftree%2Fnotebooks) ボタンをクリックしてください。  
しばらくするとクラウド上のプレイグラウンド環境が起動するので、各章の各ノートブックを開いてください。

ただし、以下の制約があります。

+ 一定時間経過すると強制終了します（起動しっぱなしにはできません）。
+ マルチスレッドのサンプルは期待通りに動作しません（シングルコアしか割り当てられない仕様となっています）。

### 4. SageMaker Studio Lab で利用する

本リポジトリの `notebooks` は [Amazon SageMaker Studio Lab](https://aws.amazon.com/jp/sagemaker/studio-lab/)（以下 Studio Lab と略記）でも動作します。  
すでにアカウントをお持ちの方は以下の手順に従ってください。

1. 公式に用意されている [サンプルリポジトリ](https://github.com/aws/studio-lab-examples) の手順（[Juliaのインストール](https://github.com/aws/studio-lab-examples/blob/d772f7701fdb2b69f762062116a0ca2336594cb5/custom-environments/julia/1-install-julia.ipynb)）に従って、Studio Lab のお使いの環境に Julia をインストールする。
    * ※ Julia のバージョン番号が古いままなので、現時点の最新版に変更すると良いです（例：`～/x64/1.7/julia-1.7.1-linux-x86_64.tar.gz` の記述箇所を `～/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz` にする）。
2. 本 README に設置した [![Open in SageMaker Studio Lab](https://studiolab.sagemaker.aws/studiolab.svg)](https://studiolab.sagemaker.aws/import/github/antimon2/JuliaBook2023Samples.jl/blob/main/notebooks/instantiate.ipynb) ボタン（`notebooks/instantiate.ipynb` へのリンクになっています）をクリックする。
3. 指示に従ってお使いの環境に「リポジトリを丸ごとクローン」する（「ノートブックだけコピーする」の方を選択しないでください！）
4. お使いの Studio Lab 環境で `instantiate.ipynb` が開けたら、それをそのまま実行する。
5. 各章の各ノートブックを開く。

一部のノートブックは、マルチスレッドが有効になっていないと期待通りに動作しません。マルチスレッド対応の IJulia カーネルを追加して動作確認してください（方法は本書の「第1章 1-4. Julia を JupyterLab で使用する」を参照してください）。

#### Studio Lab のアカウントを作成するには？

アカウントの申し込みは、公式の [アカウント作成フォーム](https://studiolab.sagemaker.aws/requestAccount?utm_source=awareness&utm_medium=community) から行ってください。

{
  description = "Python data science environment with pyright LSP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        # データサイエンス用Pythonパッケージ
        pythonEnv = pkgs.python312.withPackages (ps:
          with ps; [
            # 基本ツール
            pip
            ipython
            jupyter

            # データ分析
            numpy
            pandas
            scipy

            # 可視化
            matplotlib
            seaborn
            plotly

            # 機械学習
            scikit-learn

            # その他便利ツール
            requests
            openpyxl # Excelファイル読み込み

            # 深層学習（必要に応じて）
            # pytorch
            # tensorflow
          ]);
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv

            # LSP
            pkgs.pyright # ← ここがポイント！

            # リンター・フォーマッター
            pkgs.ruff
          ];

          shellHook = ''
            echo "Python Data Science Environment"
            echo "Python version: $(python --version)"
            echo ""
            echo "Installed packages:"
            echo "  numpy, pandas, scipy"
            echo "  matplotlib, seaborn, plotly"
            echo "  scikit-learn"
            echo "  jupyter, ipython"
            echo ""
            echo "Available commands:"
            echo "  python script.py    - execute script"
            echo "  ipython             - REPL"
            echo "  jupyter notebook    - Jupyter Notebook"
            echo "  jupyter lab         - JupyterLab"
            echo "  ruff check .        - check codes"
            echo "  ruff format .       - format"
            echo "  pyright             - check types"
          '';
        };
      }
    );
}

VERSION=3.2.1
font_dir=$HOME/.fonts

remote_fonts=(
    "IBMPlexMono"
    "Monaspace"
    "JetBrainsMono"
    "SourceCodePro"
    "iA-Writer"
)

local_fonts=(
    "EBGaramond"
    "Hershey"
    "Lato"
    "Master of Comics"
    "Office Code Pro"
    "Proxima Nova"
)

mkdir -p $font_dir
for font in ${remote_fonts[@]}; do
  echo "Downloading $font"
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v$VERSION/$font.tar.xz -P $font_dir
  echo "Extracting $font"
  mkdir -p $font_dir/$font
  tar -xf $font_dir/$font.tar.xz -C $font_dir/$font
done

echo "Cleaning up"
rm $font_dir/*.tar.xz

for font in "${local_fonts[@]}"; do
  echo "Copying $font"
  cp -r "$font" "$font_dir"
done

echo "Done. To apply the fonts, run \`fc-cache -rv\`"

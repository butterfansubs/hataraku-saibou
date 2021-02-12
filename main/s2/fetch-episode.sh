#!/usr/bin/env bash

if [[ -n "$2" ]]; then
  mkdir -p "$2"
  cd "$2" || exit
fi

url="$1"
episode="${PWD##*/}"

filter='
/^Title: .*/c\
Title: [Butter :v] Hataraku Saibou!! - '"$episode"'
/^PlayResX: .*/c\
PlayResX: 1600
/^PlayResY: .*/c\
PlayResY: 900\
YCbCr Matrix: TV.709
'
filter_dialogue='
/^Style: .*/c\
Style: Default,Kirinashi,63,&H00FFFFFF,&H00FFFFFF,&H00000000,&H87000000,-1,0,0,0,100,100,0,0,1,3,1.25,2,138,138,50,1\
Style: Default-Alt,Kirinashi,63,&H00FFFFFF,&H00FFFFFF,&H00743E15,&HCC000000,-1,0,0,0,100,100,0,0,1,3,1.25,2,138,138,50,1
/^\[Events]/,/^Format/ {
/^Format/a\
Comment: 0,0:00:00.00,0:00:00.00,Default,,0,0,0,,== Dialogue ============================
}
/^Dialogue:/ { /{[^}]*\\an8[^}]*}/d }
'
filter_signs='
/^Style: .*/c\
Style: Signs,Kirinashi,50,&H00FFFFFF,&H00002EFF,&H00000000,&H00000000,0,0,0,0,100,100,0,0,1,0,0,5,0,0,0,1\
Style: Signs - Eyecatch,Yaldevi Colombo SemiBold,50,&H000000EE,&H00002EFF,&H00FFFFFF,&H00000000,0,0,0,0,100,100,0,0,1,0,0,5,0,0,0,1\
Style: Signs - Infobox,PT Sans,50,&H00000000,&H00002EFF,&H00000000,&H00000000,0,0,0,0,100,100,0,0,1,0,0,4,0,0,0,1
/^\[Events]/,/^Format/ {
/^Format/a\
Comment: 0,0:00:00.00,0:00:00.00,Signs,,0,0,0,,== Signs ===============================
}
/^Dialogue:/ {
  /{[^}]*\\an8[^}]*}/!d
  s/,Default,/,Signs,/
  s/{\\an8}//
}
'

dialogue="Hataraku Saibou 2 - ${episode} (Dialogue).ass"
signs="Hataraku Saibou 2 - ${episode} (Signs).ass"

curl -L "$url" | xz --decompress --stdout | sed "$filter" | tee >(sed "$filter_dialogue" >"$dialogue") >(sed "$filter_signs" | tee "$signs" "${signs%.ass}.raw.ass" >/dev/null) >/dev/null

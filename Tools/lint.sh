#!/bin/bash -ex

find       "./ArcanosMetadataAPI"           \
           "./ArcanosRadio"                 \
           "./ArcanosRadioScreenshot"       \
           "./IOZPromise"                   \
\( -name "*.h" -o -name "*.m" \)            \
-exec Tools/clang-format                    \
-style=file -i {} \;

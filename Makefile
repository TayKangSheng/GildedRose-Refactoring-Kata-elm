test: elm.json package.json tests
	elm-test --watch

tests:
	which elm-test || npm install elm-test --save-dev
	elm-test init

package.json:
	echo '{}' > package.json

elm.json:
	which elm || (echo "First, install elm https://guide.elm-lang.org/install.html"; exit 1)
	elm init

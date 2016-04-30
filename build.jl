using BuildExecutable
mkdir("bin")
build_executable("eve-julia", "src/main.jl", "bin", "native")

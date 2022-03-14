using HestiaDemonstration
using Documenter

DocMeta.setdocmeta!(HestiaDemonstration, :DocTestSetup, :(using HestiaDemonstration); recursive=true)

makedocs(;
    modules=[HestiaDemonstration],
    authors="Stephan Scholz <stephan.scholz@rwu.de> and contributors",
    repo="https://github.com/stephans3/HestiaDemonstration.jl/blob/{commit}{path}#{line}",
    sitename="HestiaDemonstration.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://stephans3.github.io/HestiaDemonstration.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/stephans3/HestiaDemonstration.jl",
    devbranch="main",
)

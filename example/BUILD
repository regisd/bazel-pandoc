load("//:pandoc.bzl", "pandoc", "pandoc_rule")

# This file generates example/hello.html
pandoc(
    name = "hello",
    src = "world.md",
    from_format = "markdown",
    to_format = "html",
)

# This file generates example/hello2.html
pandoc(
    name = "hello2",
    src = "world.md",
    extension = "htm",
    from_format = "markdown",
    to_format = "html",
)

# This file generates example/hello.txt
# If output was not given, it would be gen_hello_txt.txt
pandoc(
    name = "gen_hello_txt",
    src = "world.md",
    from_format = "markdown",
    output = "hello.txt",
    to_format = "plain",
)

# In the later case, the output is explicitly specified, we can call the rule
# directly
pandoc_rule(
    name = "gen_hello2_txt",
    src = "world.md",
    from_format = "markdown",
    output = "hello2.txt",
    to_format = "plain",
)

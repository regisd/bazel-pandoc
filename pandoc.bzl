FORMAT_EXTENSIONS = {
    "asciidoc": "adoc",
    "beamer": "tex",
    "commonmark": "md",
    "context": "tex",
    "docbook": "xml",
    "docbook4": "xml",
    "docbook5": "xml",
    "docx": "docx",
    "dokuwiki": "txt",
    "dzslides": "html",
    "epub": "epub",
    "epub2": "epub",
    "epub3": "epub",
    "fb2": "fb",
    "haddock": "txt",
    "html": "html",
    "html4": "html",
    "html5": "html",
    "icml": "icml",
    "jats": "xml",
    "json": "json",
    "latex": "tex",
    "man": "1",
    "markdown": "md",
    "markdown_github": "md",
    "markdown_mmd": "md",
    "markdown_phpextra": "md",
    "markdown_strict": "md",
    "mediawiki": "txt",
    "ms": "1",
    "muse": "txt",
    "native": "txt",
    "odt": "odt",
    "opendocument": "odt",
    "opml": "openml",
    "org": "txt",
    "plain": "txt",
    "pptx": "pptx",
    "revealjs": "html",
    "rst": "rst",
    "rtf": "rtf",
    "s5": "html",
    "slideous": "html",
    "slidy": "html",
    "tei": "html",
    "texinfo": "texi",
    "textile": "textile",
    "zimwiki": "txt",
}
PANDOC_FORMATS = FORMAT_EXTENSIONS.keys()

def _pandoc_impl(ctx):
    toolchain = ctx.toolchains["@bazel_pandoc//:pandoc_toolchain_type"]
    cli_args = ctx.attr.options + [
        "--from",
        ctx.attr.from_format,
        "--to",
        ctx.attr.to_format,
        "-o",
        ctx.outputs.output.path,
        ctx.file.src.path,
    ]
    # print("args=" + str(cli_args))
    ctx.actions.run(
        mnemonic = "Pandoc",
        executable = toolchain.pandoc.files.to_list()[0].path,
        arguments = cli_args,
        inputs = toolchain.pandoc.files + ctx.files.src,
        outputs = [ctx.outputs.output],
    )

pandoc_rule = rule(
    attrs = {
        "extension": attr.string(),
        "from_format": attr.string(mandatory = True),
        "options": attr.string_list(),
        "src": attr.label(allow_single_file = True, mandatory = True),
        "to_format": attr.string(mandatory = True),
        "output": attr.output(),
    },
    toolchains = ["@bazel_pandoc//:pandoc_toolchain_type"],
    implementation = _pandoc_impl,
)

def _pandoc_kwarg_helper(to_format, kwargs):
    extension = kwargs["extension"] if "extension" in kwargs else FORMAT_EXTENSIONS[to_format]
    if "output" not in kwargs:
        # Infer the output if not explicitely provided
        kwargs["output"] = "{name}.{extension}".format(
            name = kwargs["name"],
            extension = extension,
        )
    return kwargs

def pandoc(**kwargs):
    """Invokes the pandoc rule by inferring the output from the rule name and
    the format.
    """
    to_format = kwargs["to_format"]
    if to_format not in FORMAT_EXTENSIONS:
        fail("Unknown output format: " + to_format)
    args = _pandoc_kwarg_helper(to_format, kwargs)
    pandoc_rule(**args)

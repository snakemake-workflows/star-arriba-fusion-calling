rule arriba:
    input:
        unpack(get_optional_arriba_inputs),
        # STAR bam containing chimeric alignments
        bam="<results>/star_align/{sample}/{sample}.sorted_by_coordinate.bam",
        # path to reference genome
        genome=f"<resources>/{genome_name}.fasta",
        # path to annotation gtf
        annotation=f"<resources>/{genome_name}.gtf",
    output:
        # approved gene fusions
        fusions="<results>/arriba_fusions/{sample}/{sample}.tsv",
        # discarded gene fusions
        discarded="<results>/arriba_fusions/{sample}/{sample}.discarded.tsv",  # optional
    log:
        "<logs>/arriba_fusions/{sample}/{sample}.log",
    params:
        # required when any of blacklist or known_fusions is set to True
        genome_build=lookup(within=config, dpath="ref/build"),
        # strongly recommended, see https://arriba.readthedocs.io/en/latest/input-files/#blacklist
        # automatically turned off, if a custom_blacklist file is specified in config
        default_blacklist=(
            False
            if lookup(
                within=config, dpath="params/arriba/custom_blacklist", default=""
            )
            else True
        ),
        # automatically turned off, if a custom_known_fusions file is specified in config
        default_known_fusions=(
            False
            if lookup(
                within=config, dpath="params/arriba/custom_known_fusions", default=""
            )
            else True
        ),
    threads: 1
    wrapper:
        "v9.0.0/bio/arriba"

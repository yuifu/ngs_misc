mkpath("../test_out/")
run(`julia ../gtfToBed12.jl ../test_data/gencode_vM9_chr19.gtf ../test_out/gencode_vM9_chr19.gtf.bed`)
using GZip


function convertGtfChr(path_gtf::AbstractString, path_convert_file::AbstractString, path_ofile::AbstractString)
	arr = Array{AbstractString, 9}
	chr = ""
	dic = Dict{AbstractString, AbstractString}()

	f = open(path_convert_file)
	readline(f)
	for line in eachline(f)
		arr = split(chomp(line), "\t")
		dic[arr[4]] = "chr" * arr[1]
	end
	close(f)
	
	if ismatch(r"\.gz$", path_gtf)
		f = GZip.open(path_gtf)
	else
		f = open(path_gtf)
	end

	if ismatch(r"\.gz$", path_ofile)
		path_ofile2 = path_ofile * ".skip.gtf.gz"

		fw1 = GZip.open(path_ofile, "w")
		fw2 = GZip.open(path_ofile2, "w")
	else
		path_ofile2 = path_ofile * ".skip.gtf"

		fw1 = open(path_ofile, "w")
		fw2 = open(path_ofile2, "w")
	end


	for line in eachline(f)
		arr = split(chomp(line), "\t")
		chr = arr[1]
		if haskey(dic, chr)
			arr[1] = dic[chr]
			write(fw1, join(arr, "\t") * "\n")
		else
			write(fw2, line)
		end
	end
	close(f)
	close(fw1)
	close(fw2)
end

path_gtf = "ref_GRCm38.p3_top_level.gff3.gz"
path_convert_file = "GRC_Mouse_Genome_Assembly_Data.txt"
path_ofile = "ref_GRCm38.p3_top_level.convert_to_mm10.gff3.gz"

convertGtfChr(path_gtf, path_convert_file, path_ofile)

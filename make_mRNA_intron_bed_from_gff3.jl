# Before use, run `import Pkg; Pkg.add("GenomicFeatures")`


using GenomicFeatures
using Printf

"""
    make_mRNA_intron_bed_from_gff3(path_input_gff3::String, path_out_bed::String)

From a GFF3 file, generate a BED file containing intronic regions.
Introns are calculated for each "mRNA" feature.
"""
function make_mRNA_intron_bed_from_gff3(path_input_gff3::String, path_out_bed::String)

    writer = open(path_out_bed, "w")

    reader = open(GFF3.Reader, path_input_gff3)
    lefts = Array{Integer,1}()
    rights = Array{Integer,1}()
    rec = GFF3.Record()
    mRNA_id = ""
    mRNA_strand = ""
    mRNA_seqname = ""
    intron_count = 0
    # Iterate over records.
    for record in reader
        rec = record
        if GFF3.featuretype(rec) == "mRNA"
            if lastindex(lefts) != 0
                intron_count = 0
                sort!(lefts)
                sort!(rights)
                for i in 1:(lastindex(lefts)-1)
                    if rights[i] == lefts[i+1]-1
                        continue
                    end
                    intron_count += 1
                    res = @sprintf "%s\t%d\t%d\t%s_intron_%d\t0\t%s\n" mRNA_seqname rights[i] (lefts[i+1]-1) mRNA_id intron_count string(strand(rec))
                    write(writer, res)
                end
                empty!(lefts)
                empty!(rights)                    
            end
            for p in GFF3.attributes(rec)
                if p[1] == "ID"
                    mRNA_id = p[2][1]
                    mRNA_strand = string(strand(rec))
                    mRNA_seqname = seqname(rec)

                    break
                end            
            end
        elseif GFF3.featuretype(rec) == "gene" || GFF3.featuretype(rec) == "operon"
            continue
        else
            for p in GFF3.attributes(rec)
                if p[1] == "Parent" && p[2][1] == mRNA_id
                    push!(lefts, leftposition(rec))
                    push!(rights, rightposition(rec))
                end            
            end                        
        end
    end

    if lastindex(lefts) != 0
        intron_count = 0
        sort!(lefts)
        sort!(rights)
        for i in 1:(lastindex(lefts)-1)
            if rights[i] == lefts[i+1]-1
                continue
            end
            intron_count += 1
            res = @sprintf "%s\t%d\t%d\t%s_intron_%d\t0\t%s\n" mRNA_seqname rights[i] (lefts[i+1]-1) mRNA_id intron_count string(strand(rec))
            write(writer, res)
        end        
    end
    close(reader)
    close(writer)
end


path_input_gff3 = ARGS[1]
path_out_bed = ARGS[2]

make_mRNA_intron_bed_from_gff3(path_input_gff3, path_out_bed)




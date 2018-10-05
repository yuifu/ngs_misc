


import java.io.File;
import java.io.IOException;
import net.sf.samtools.SAMFileReader;
import net.sf.samtools.SAMFileWriter;
import net.sf.samtools.SAMFileWriterFactory;
import net.sf.samtools.SAMRecord;


public class bam_remove_multihit {
	public static void main(String[] args) throws IOException, InterruptedException{
		// arguments 
		
		String fileName = "/Users/haruka/Dropbox/Research/aori_ngs/results/130917_medaka_tophat/test.bam";
		String outFile = "/Users/haruka/Dropbox/Research/aori_ngs/results/130917_medaka_tophat/test.out.bam";
		if(args.length > 0){
			fileName = args[0];
			outFile = args[1];
		}
		System.err.println("input BAM: "+fileName);
		System.err.println("output BAM: "+outFile);
		
		int count_l = 0;
		int count_r = 0;
		
		File inputBamFile = new File(fileName);
		File outputBamFile = new File(outFile);
		
		SAMFileReader inputBam = new SAMFileReader(inputBamFile);
		SAMFileWriter outputBam = new SAMFileWriterFactory().makeBAMWriter(inputBam.getFileHeader(), false, outputBamFile);

		for(final SAMRecord samRecord : inputBam){ //unmapped -> MAPQ=255 or die, should be 0, 7and8 should be set
			
			//Number of reported alignments that contains the query in the current record
			if(samRecord.getIntegerAttribute("NH") == 1){
				//System.out.println(samRecord.getIntegerAttribute("NH"));
				outputBam.addAlignment(samRecord);
				
				count_l++;
			}else{
				count_r++;
			}
			//Matcher match = nhPattern.matcher(line);
			//if(match.find()){
				//nh = Integer.parseInt(match.group(1));
		}
		inputBam.close();
		outputBam.close();
		System.err.println("removed: "+count_r);
		System.err.println("retaind: "+count_l);

		
		
	}
		
}

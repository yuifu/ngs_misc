
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


public class util {
	public static BufferedReader openFile(String fileName) throws FileNotFoundException{
		FileInputStream fis = new FileInputStream(fileName);
		InputStreamReader isr = new InputStreamReader(fis);
		BufferedReader br = new BufferedReader(isr);
		return br;
	}
	
	public static BufferedReader openCmd(String cmd) throws IOException{
		Process prc = Runtime.getRuntime().exec(cmd);
		InputStream is = prc.getInputStream();
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		return br;
	}
	
	public static PrintWriter openWrite(String fileName) throws FileNotFoundException{
		File outfile = new File(fileName);
		FileOutputStream fos = new FileOutputStream(outfile);
	    OutputStreamWriter osw = new OutputStreamWriter(fos);
	    PrintWriter pw = new PrintWriter(osw);
	    return pw;
	}
	
	public static <E, T> void writeHM(PrintWriter pw, Map<T, T> hm){
		Iterator<T> i = hm.keySet().iterator();
		while(i.hasNext()){
			Object key = i.next();
			pw.println(key+"\t"+hm.get(key));
		}
	}

	
	public static <E, T, U, S> void writeHMHM(PrintWriter pw, Map<T, Map<S, U>> hm){
		Iterator<T> i = hm.keySet().iterator();
		while(i.hasNext()){
			Object key = i.next();
			pw.print(key);
			Iterator<S> i2 = hm.get(key).keySet().iterator();
			while(i2.hasNext()){
				Object key2 = i2.next();
				pw.print("\t"+key2+":"+hm.get(key).get(key2));
			}
			pw.println();
		}
	}
	
	public static void checkHashMapSII(Map<String, Map<Integer, Integer>> hm, String s, Integer i){
		if(!hm.containsKey(s)){
			Map<Integer, Integer> hmII = new HashMap<Integer, Integer>();
			hm.put(s, hmII);
		}
		if(!hm.get(s).containsKey(i)){
			hm.get(s).put(i, 0);
		}
	}
	
	public static void checkHashMapIII(Map<Integer, Map<Integer, Integer>> hm, Integer i1, Integer i2){
		if(!hm.containsKey(i1)){
			Map<Integer, Integer> hmII = new HashMap<Integer, Integer>();
			hm.put(i1, hmII);
		}
		if(!hm.get(i1).containsKey(i2)){
			hm.get(i1).put(i2, 0);
		}
	}
	
	public static void checkTreeMapIII(Map<Integer,HashMap<Integer,Integer>> tm, Integer i1, Integer i2){
		if(!tm.containsKey(i1)){
			HashMap<Integer, Integer> hmII = new HashMap<Integer, Integer>();
			tm.put(i1, hmII);
		}
		if(!tm.get(i1).containsKey(i2)){
			tm.get(i1).put(i2, 0);
		}
	}
	
	

	public static void checkHashMapIID(Map<Integer, Map<Integer, Double>> hm, Integer i1, Integer i2){
		if(!hm.containsKey(i1)){
			Map<Integer, Double> hmID = new HashMap<Integer, Double>();
			hm.put(i1, hmID);
		}
		if(!hm.get(i1).containsKey(i2)){
			hm.get(i1).put(i2, 0.0);
		}
	}
	
	
	public static void checkHashMapII(Map<Integer, Integer> hm, Integer i){
		if(!hm.containsKey(i)){
			hm.put(i, 0);
		}
	}



	

}



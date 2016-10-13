package at.ac.tuwien.cg.gesture.data;

import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import at.ac.tuwien.cg.gesture.math.Vector3f;

public class MatlabLogger {
	
	private String data;
	private String filename;
	private String dir="matlab/";
	private FileWriter fw;
	private int count=0;
	
	public MatlabLogger() {
		
	}
	
	public void addData(Vector3f [] data,Long deltatime){
		
		if(fw==null)
			try {
				
				Date date = new Date(); 
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss"); 
				
				fw = new FileWriter( dir+formatter.format(date)+".csv", true );
	      		fw.write("time, x, y, z, orX, orY, orZ, orRowX, orRowY, orRowZ\n");
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
          try {
        
      		fw.write(deltatime+"  , "+data[0].x+" , "+data[0].y+" , "+data[0].z+"    , "+data[1].x+" , "+data[1].y+" , "+data[1].z+"    ,"+data[2].x+" , "+data[2].y+" , "+data[2].z+"\n");
			count++;
          } catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public void writeData(){
		
        try {
        	if(fw!=null)
        	{
        		fw.flush();
        		fw.close();
        		fw=null;
        		System.out.println("Es wurden "+count+" Messpunkte gespeichert");
        		count=0;
        	}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
	}
	
	

}

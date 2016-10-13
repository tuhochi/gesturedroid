import java.util.Calendar;

import javax.media.opengl.GL;


public class RenderLoop {
	
	//Window that shows the context
	private MainWindow mainWindow;
	
	
	private GL gl;
	
	public RenderLoop(MainWindow mainWindow){
		this.mainWindow = mainWindow;
		//this.gl = mainWindow.getGL();
	}
	
	public void run(){
		
		while ( mainWindow.isVisible() ) {
            
			//Update Camera
			
			//FPS
			mainWindow.calculateFPS();
			
			//Draw Window
			mainWindow.draw();
		}
	}

}

import javax.media.opengl.GL;
import javax.media.opengl.GLAutoDrawable;
import javax.media.opengl.GLCanvas;
import javax.media.opengl.GLCapabilities;
import javax.media.opengl.GLEventListener;
import javax.media.opengl.glu.GLU;
import javax.swing.JFrame;

import com.sun.opengl.util.Animator;
import com.sun.opengl.util.GLUT;

/**
 * This is a very small OpenGL app that tests whether Eclipse and JOGL have
 * been correctly installed and configured.
 * 
 * @author Stefan Gaffga
 */
public class InstallTest implements GLEventListener {

	private GLUT glut;
	
	public static void main(String[] args) {
		JFrame frame = new JFrame("OpenGL Install Test");
		frame.setSize(400, 400);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		GLCanvas canvas = new GLCanvas(new GLCapabilities());
		canvas.addGLEventListener(new InstallTest());

		frame.add(canvas);		
		frame.setVisible(true);
		
		Animator animator = new Animator(canvas);
		animator.start();
	}
	
	@Override
	public void display(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		


		gl.glClear(GL.GL_DEPTH_BUFFER_BIT|GL.GL_COLOR_BUFFER_BIT);

		gl.glRotatef(0.05f, 0.5f, 1, 0.2f);
		gl.glColor3f(1,1,1);
		glut.glutSolidTeapot(13.0);
		
	}

	@Override
	public void displayChanged(GLAutoDrawable drawable, boolean modeChanged,
			boolean deviceChanged) {
		// unused
	}

	@Override
	public void init(GLAutoDrawable drawable) {
		GL gl = drawable.getGL();
		glut = new GLUT();
		GLU glu = new GLU();
		
		gl.glMatrixMode(GL.GL_PROJECTION);
		gl.glLoadIdentity();
		
		//glu.gluLookAt(0.0, 0, 0, 0, 0, -60, 0, 1, 0);
		gl.glFrustum(-0.1, 0.1, -0.1, 0.1, 0.1, 100.0);
		gl.glTranslatef(0, 0, -30);
		
		gl.glMatrixMode(GL.GL_MODELVIEW);
		gl.glLoadIdentity();
		
		gl.glEnable(GL.GL_DEPTH_TEST);
		gl.glEnable(GL.GL_LIGHTING);
		gl.glEnable(GL.GL_LIGHT0);
		gl.glEnable(GL.GL_COLOR_MATERIAL);
		
		gl.glClearColor(0.0f, 0.5f, 1.0f, 1.0f);
	}

	@Override
	public void reshape(GLAutoDrawable drawable, int x, int y, int width,
			int height) {
		// unused
	}

	
}
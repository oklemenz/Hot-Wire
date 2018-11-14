package de.oklemenz.wire;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.swing.JFrame;

import de.oklemenz.wire.WirePart.End;
import de.oklemenz.wire.WirePart.Kind;

public class Wire extends JFrame implements MouseMotionListener {
	
	private static final long serialVersionUID = 7481337926073176873L;
	
	public static final double ZOOM = 1.0;
	
	public static final int SCREEN_WIDTH      = 480;
	public static final int SCREEN_HEIGHT     = 320;
	public static final int WIRE_SPACE_WIDTH  = (int)(480 * ZOOM);
	public static final int WIRE_SPACE_HEIGHT = (int)(320 * ZOOM);
	public static final int GRID_X = (int)(ZOOM * 10);
	public static final int GRID_Y = (int)(ZOOM * 10);
	
	public static final int BORDER_LEFT   = 3;  // 8  if JFrame is resizable
	public static final int BORDER_RIGHT  = 3;  // 8  if JFrame is resizable
	public static final int BORDER_TOP    = 23; // 28 if JFrame is resizable
	public static final int BORDER_BOTTOM = 3;  // 8  if JFrame is resizable
	
	public static final Random random = new Random();

	private static final int SEED   		 = (int)Math.PI;
	private static final int LEVEL           = 1; // Problematic 15
	private static final int LENGTH			 = 1000;
	private static final int DEPTH			 = 1000; 
	private static final int MAX_NOT_CHANGED = 20;
	private static final int WIND_UP_DECAY	 = 1;
	
	private List<WirePart> wireParts = new ArrayList<WirePart>(); 
	private Set<Point> points = new HashSet<Point>();
	private Map<Square, WirePart> wirePartBySquare = new HashMap<Square, WirePart>();
	private WirePart rightMostWirePart = null;
	private WirePart mouseWirePart = null;
	
	private int depthCounter = 0;
	private int charCount = 0;
	private String hashCodeString = "";
		
	private int maxWirePartCount = 0;
	private int maxWirePartCountNotChangedCounter = 0;
	private boolean backtraceToRightMostWirePart  = false;
	
	private int handleX = 0;
	private int handleY = 0;
	
	public int offsetX = 0;
	public int offsetY = 0;

	public Wire() {
		setTitle("Wire");
		setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
		
		Toolkit toolKit = Toolkit.getDefaultToolkit();
		Dimension screen = toolKit.getScreenSize();
		setBounds((screen.width - SCREEN_WIDTH) / 2, (screen.height - SCREEN_HEIGHT) / 2, 
				   SCREEN_WIDTH + BORDER_LEFT + BORDER_RIGHT, SCREEN_HEIGHT + BORDER_TOP + BORDER_BOTTOM);
		
		addWindowListener(new java.awt.event.WindowAdapter() {
			public void windowClosing(java.awt.event.WindowEvent evt) {
				System.exit(0);
			}
		});
		
		addMouseMotionListener(this);
		setupWire();
	
		setResizable(false);
		setVisible(true);
	}
	
	public void paint(Graphics g) {
		/*Graphics2D g2d = (Graphics2D)g;
		g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);*/
		int width  = g.getClip().getBounds().width;
		int height = g.getClip().getBounds().height;
		Image image = this.createImage(width, height);
		Graphics buffer = image.getGraphics();
		buffer.setColor(Color.WHITE);
		buffer.fillRect(0, 0, width, height);
		drawGrid(buffer);
		drawWires(buffer);
		drawHandle(buffer);
		g.drawImage(image, 0, 0, null);
	}
	
	private void setupWire() {
		//WirePart wirePart = new WirePart(Kind.w1v3v, End.e1v, 0, 0);
		WirePart wirePart = new WirePart(Kind.w1h2h, End.e1h, 0, SCREEN_HEIGHT / GRID_Y / 2);
		points.add(wirePart.getStartPoint());
		recursiveSetupWire(wirePart);
		points.clear();
	}
	
	private boolean recursiveSetupWire(WirePart wirePart) {
		if (wireParts.size() > maxWirePartCount) {
			maxWirePartCount = wireParts.size();
			maxWirePartCountNotChangedCounter = 0;
		} else {
			maxWirePartCountNotChangedCounter++;
		}
		if (maxWirePartCountNotChangedCounter >= MAX_NOT_CHANGED) {
			backtraceToRightMostWirePart = true;
			maxWirePartCountNotChangedCounter = 0;
			return false;
		}
		wireParts.add(wirePart);
		points.add(wirePart.getEndPoint());
		wirePartBySquare.put(wirePart.getSquare(), wirePart);
		WirePart previousRightMostWirePart = rightMostWirePart;
		if (rightMostWirePart == null || wirePart.getEndX() >= rightMostWirePart.getEndX()) {
			rightMostWirePart = wirePart;
		}
		if (++depthCounter >= DEPTH) {
			return true;
		}
		if (wireParts.size() >= LENGTH) {
			return true;
		}
		if ((wirePart.getEndX() == WIRE_SPACE_WIDTH  / GRID_X && wirePart.getEndY() >= WIRE_SPACE_HEIGHT / GRID_Y / 2) ||
			(wirePart.getEndY() == WIRE_SPACE_HEIGHT / GRID_Y && wirePart.getEndX() >= WIRE_SPACE_WIDTH  / GRID_X / 2)) {
			return true;
		}
		List<WirePart> validWireParts = new ArrayList<WirePart>();
		for (WirePart nextWirePart : wirePart.getFittingWireParts()) {
			if (nextWirePart.isValid() || validateWirePart(nextWirePart)) {
				nextWirePart.setValid();
				validWireParts.add(nextWirePart);
			}
		}
		if (!validWireParts.isEmpty()) {
			int[] iterationOrder = getIterationOrder(LEVEL, validWireParts.size()); 
			for (int i = 0; i < iterationOrder.length; i++) {
				WirePart nextWirePart = validWireParts.get(iterationOrder[i]);
				if (!nextWirePart.isUsed() && recursiveSetupWire(nextWirePart)) {
					nextWirePart.setUsed();
					return true;
				}
				if (backtraceToRightMostWirePart) {
					if (rightMostWirePart == wirePart) {
						backtraceToRightMostWirePart = false;
					}
					break;
				}
			}
		}
		rightMostWirePart = previousRightMostWirePart;
		wireParts.remove(wireParts.size()-1);
		points.remove(wirePart.getEndPoint());
		wirePartBySquare.remove(wirePart.getSquare());
		return false;
	}
	
	private boolean validateWirePart(WirePart wirePart) {
		return wirePart.getLeft() >= 0 && wirePart.getRight()  <= WIRE_SPACE_WIDTH  / GRID_X &&
			   wirePart.getTop()  >= 0 && wirePart.getBottom() <= WIRE_SPACE_HEIGHT / GRID_Y &&
			   !points.contains(wirePart.getEndPoint()) &&
			   doesNotCross(wirePart) && doesNotWindUp(wirePart); 
	}
	
	private boolean doesNotCross(WirePart wirePart) {
		return Math.abs(wirePart.getEndX() - wirePart.getStartX()) != 1 ||
			   Math.abs(wirePart.getEndY() - wirePart.getStartY()) != 1 ||
			   !wirePartBySquare.keySet().contains(wirePart.getSquare());
	}
	
	private boolean doesNotWindUp(WirePart wirePart) {
		int deltaX = wirePart.getEndX() - wirePart.getStartX();
		int deltaY = wirePart.getEndY() - wirePart.getStartY();
		Point point = wirePart.getEndPoint();
		Square square = wirePart.getSquare();
		int decay = WIND_UP_DECAY;
		while (point.x >= 0 && point.x <= WIRE_SPACE_WIDTH / GRID_X && point.y >= 0 && point.y <= WIRE_SPACE_HEIGHT / GRID_Y) {
			if (points.contains(point)) {
				return false;
			}
			if (wirePartBySquare.keySet().contains(square)) {
				return false;
			}
			point = new Point(point.x + deltaX, point.y + deltaY);
			square = new Square(square.x1 + deltaX, square.y1 + deltaY);
			if (--decay == 0) {
				return true;
			}
		}
		return true; 
	}
	
	private int[] getIterationOrder(int level, int count) {
		while (hashCodeString.length() < count) {
			char c = (char)charCount;
			hashCodeString += Math.abs(("" + c+c+c+c + "" + (level * SEED) + "" + c+c+c+c).hashCode());
			charCount++;
		}
		int[] order = new int[count];
		for (int i = 0; i < order.length; i++) {
			order[i] = Integer.parseInt(hashCodeString.substring(i, i+1));
		}
		hashCodeString = hashCodeString.substring(count);
		return radixSort(order);
	}
	
	@SuppressWarnings("unchecked")
	private static int[] radixSort(int[] order) {
		int[] newOrder = new int[order.length];
		List<Integer>[] count = (List<Integer>[])Array.newInstance(ArrayList.class, 10); 
		for (int i = 0; i < order.length; i++) {
			if (count[order[i]] == null) {
				count[order[i]] = new ArrayList<Integer>();
			}
			count[order[i]].add(i);
		}
		int c = 0;
		for (int i = 0; i < count.length; i++) {
			if (count[i] != null) {
				for (int j : count[i]) {
					newOrder[c++] = j;
				}
			}
		}
		return newOrder; 
	}
	
	private void drawHandle(Graphics g) {
		g.drawLine(handleX, handleY, handleX, handleY-20);
	}
	
	private void drawWires(Graphics g) {
		for (WirePart wirePart : wireParts) {
			wirePart.draw(g, offsetX, offsetY);
		}
	}

	public void drawGrid(Graphics g) {
		g.setColor(Color.LIGHT_GRAY);
		for (int i = 0; i < WIRE_SPACE_WIDTH / GRID_X; i++) {
			g.drawLine(i*GRID_X + BORDER_LEFT - offsetX, BORDER_TOP - offsetY, i*GRID_X + BORDER_LEFT - offsetX, BORDER_TOP + WIRE_SPACE_HEIGHT - offsetY);
		}
		for (int i = 0; i < WIRE_SPACE_HEIGHT / GRID_Y; i++) {
			g.drawLine(BORDER_LEFT - offsetX, i*GRID_Y + BORDER_TOP - offsetY, WIRE_SPACE_WIDTH + BORDER_LEFT - offsetX, i*GRID_Y + BORDER_TOP - offsetY);
		}
	}

	public void mouseDragged(MouseEvent event) {
		offsetX = event.getX() - SCREEN_WIDTH / 2;
		offsetY = event.getY() - SCREEN_HEIGHT / 2;
		if (offsetX < 0) {
			offsetX = 0;
		}
		if (offsetX > WIRE_SPACE_WIDTH - SCREEN_WIDTH) {
			offsetX = WIRE_SPACE_WIDTH - SCREEN_WIDTH;
		}
		if (offsetY < 0) {
			offsetY = 0;
		}
		if (offsetY > WIRE_SPACE_HEIGHT - SCREEN_HEIGHT) {
			offsetY = WIRE_SPACE_HEIGHT - SCREEN_HEIGHT;
		}
		mouseMoved(event);
	}

	public void mouseMoved(MouseEvent event) {
		handleX = event.getX();
		handleY = event.getY();
		int squareX = handleX / GRID_X;
		int squareY = (handleY - 20) / GRID_Y - 2;
		Square square = new Square(squareX, squareY);
		WirePart wirePart = wirePartBySquare.get(square);
		if (wirePart != null && mouseWirePart != wirePart) {
			mouseWirePart = wirePart;
			System.out.println(mouseWirePart);
		}
		repaint();
	}
	
	public static void main(String[] args) {
		new Wire();
	}
}